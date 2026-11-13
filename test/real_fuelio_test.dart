import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fuelix/domain/consumption.dart';
import 'package:fuelix/services/fuelio_import.dart';

/// Runs the importer against a real Fuelio export so regressions in the CSV
/// parser or in the consumption maths show up immediately.
void main() {
  final file = File('test/fixtures/fuelio_export.csv');
  if (!file.existsSync()) {
    // The real export is personal data and is therefore not committed.
    test('real Fuelio export', () {}, skip: 'fixture not present');
    return;
  }
  final csv = file.readAsStringSync();
  final preview = FuelioImporter.parse(csv);

  test('reads the real vehicle', () {
    expect(preview.vehicle.name, 'Renault Scenic');
    expect(preview.vehicle.plate, 'PD404DU');
    expect(preview.vehicle.make, 'Renault');
    expect(preview.vehicle.year, 2010);
  });

  test('imports every fill-up', () {
    expect(preview.fillUps, hasLength(122));

    final newest = preview.fillUps.first;
    expect(newest.odometer, 175084);
    expect(newest.liters, 50);
    expect(newest.totalPrice, 93);
    expect(newest.pricePerLiter, 1.86);
    expect(newest.stationName, 'Prievidza - Tesco');
    expect(newest.latitude, closeTo(48.77904, 0.00001));

    // "GPS" in the City column means the station was not named.
    expect(preview.fillUps[1].stationName, 'Prievidza - Shell');
  });

  test('imports costs and builds reminders', () {
    expect(preview.expenses.length, greaterThan(60));
    expect(preview.reminders, isNotEmpty);
    // Every category in this export maps to a built-in one, so no custom
    // categories need to be created.
    expect(preview.categories, isEmpty);
    expect(preview.stations, hasLength(2));
    expect(preview.tripsSkipped, 509);

    final stk = preview.reminders.firstWhere((r) => r.title == 'STK a EK');
    expect(stk.dueDate, DateTime(2028, 10, 16));
    expect(stk.repeatMonths, 24);
    expect(stk.categoryKey, 'inspection');
  });

  test('consumption matches the values Fuelio stored in the export', () {
    final segments = consumptionSegments(
      preview.fillUps.map(
        (fill) => FillUpPoint(
          id: fill.fillUpsHashCode,
          date: fill.date,
          odometer: fill.odometer,
          liters: fill.liters,
          isFull: fill.isFull,
          isMissed: fill.isMissed,
          excludeDistance: fill.excludeDistance,
        ),
      ),
    );

    final newest = segments.last;
    // Export row: 50 l, 535 km, Fuelio wrote 9.35 l/100 km.
    expect(newest.distanceKm, 535);
    expect(newest.consumption, closeTo(9.35, 0.01));
    expect(averageConsumption(segments), isNotNull);
    expect(averageConsumption(segments)!, inInclusiveRange(5, 15));
  });
}

extension on FuelioFillUpDraft {
  int get fillUpsHashCode => odometer.hashCode;
}
