import 'package:flutter_test/flutter_test.dart';
import 'package:fuelix/domain/consumption.dart';

FillUpPoint point({
  required int id,
  required double odometer,
  required double liters,
  bool full = true,
  bool missed = false,
  bool exclude = false,
  int? month,
}) => FillUpPoint(
  id: id,
  date: DateTime(2026, month ?? id, 10),
  odometer: odometer,
  liters: liters,
  isFull: full,
  isMissed: missed,
  excludeDistance: exclude,
);

void main() {
  group('consumptionSegments', () {
    test('calculates litres per 100 km between full tanks', () {
      final segments = consumptionSegments([
        point(id: 1, odometer: 1000, liters: 40),
        point(id: 2, odometer: 1500, liters: 50),
      ]);

      expect(segments, hasLength(1));
      expect(segments.single.distanceKm, 500);
      expect(segments.single.consumption, closeTo(10, 0.001));
      expect(segments.single.reliable, isTrue);
    });

    test('carries partial fill-ups into the next full tank', () {
      final segments = consumptionSegments([
        point(id: 1, odometer: 1000, liters: 40),
        point(id: 2, odometer: 1300, liters: 15, full: false),
        point(id: 3, odometer: 1600, liters: 20, full: false),
        point(id: 4, odometer: 2000, liters: 25),
      ]);

      expect(segments, hasLength(1));
      // 15 + 20 + 25 = 60 l over 1000 km.
      expect(segments.single.liters, 60);
      expect(segments.single.consumption, closeTo(6, 0.001));
      expect(segments.single.fillUpId, 4);
    });

    test('ignores the first fill-up as a baseline', () {
      expect(consumptionSegments([point(id: 1, odometer: 1000, liters: 40)]),
          isEmpty);
    });

    test('flags segments with a missed fill-up as unreliable', () {
      final segments = consumptionSegments([
        point(id: 1, odometer: 1000, liters: 40),
        point(id: 2, odometer: 1400, liters: 44, missed: true),
      ]);

      expect(segments.single.reliable, isFalse);
      expect(averageConsumption(segments), isNull);
    });

    test('skips a segment when the odometer did not move', () {
      final segments = consumptionSegments([
        point(id: 1, odometer: 1000, liters: 40),
        point(id: 2, odometer: 1000, liters: 40),
        point(id: 3, odometer: 1200, liters: 20),
      ]);

      expect(segments, hasLength(1));
      expect(segments.single.fillUpId, 3);
      expect(segments.single.consumption, closeTo(10, 0.001));
    });

    test('average is weighted by litres, not by segment count', () {
      final segments = consumptionSegments([
        point(id: 1, odometer: 0, liters: 40),
        point(id: 2, odometer: 1000, liters: 50), // 5 l/100
        point(id: 3, odometer: 1200, liters: 20), // 10 l/100
        point(id: 4, odometer: 1400, liters: 20),
      ]);

      // 40 l over 1 400 km overall is not used: segments are 50/1000 and 40/400.
      expect(averageConsumption(segments), closeTo(90 / 1400 * 100, 0.001));
    });
  });

  group('previewConsumption', () {
    test('previews the segment a new full fill-up would close', () {
      final value = previewConsumption(
        existing: [point(id: 1, odometer: 1000, liters: 40)],
        date: DateTime(2026, 5, 1),
        odometer: 1550,
        liters: 44,
        isFull: true,
      );

      expect(value, closeTo(44 / 550 * 100, 0.001));
    });

    test('returns null for a partial fill-up', () {
      final value = previewConsumption(
        existing: [point(id: 1, odometer: 1000, liters: 40)],
        date: DateTime(2026, 5, 1),
        odometer: 1200,
        liters: 10,
        isFull: false,
      );

      expect(value, isNull);
    });
  });

  test('costPerKm handles empty distance', () {
    expect(costPerKm(cost: 100, distanceKm: 0), isNull);
    expect(costPerKm(cost: 100, distanceKm: 500), 0.2);
  });

  test('drivenDistance includes the initial odometer', () {
    expect(
      drivenDistance(odometers: [1500, 2000], initialOdometer: 1000),
      1000,
    );
  });
}
