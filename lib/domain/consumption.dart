import 'dart:math' as math;

/// A single fill-up reduced to the fields the consumption maths needs.
class FillUpPoint {
  const FillUpPoint({
    required this.id,
    required this.date,
    required this.odometer,
    required this.liters,
    required this.isFull,
    this.isMissed = false,
    this.excludeDistance = false,
  });

  final int id;
  final DateTime date;
  final double odometer;
  final double liters;
  final bool isFull;
  final bool isMissed;
  final bool excludeDistance;
}

/// Consumption for one tank-to-tank segment (always between full tanks).
class ConsumptionSegment {
  const ConsumptionSegment({
    required this.fillUpId,
    required this.date,
    required this.distanceKm,
    required this.liters,
    required this.consumption,
    required this.reliable,
  });

  /// Fill-up that closes the segment.
  final int fillUpId;
  final DateTime date;
  final double distanceKm;
  final double liters;

  /// Litres per 100 km.
  final double consumption;

  /// False when a fill-up was skipped or excluded, so the number is a guess.
  final bool reliable;
}

/// Calculates tank-to-tank consumption.
///
/// Litres of partial fill-ups are carried over until the next full tank, which
/// is how Fuelio and every other fuel log does it. The very first full tank is
/// the baseline and has no consumption.
List<ConsumptionSegment> consumptionSegments(Iterable<FillUpPoint> points) {
  final list = points.toList()
    ..sort((a, b) {
      final byOdometer = a.odometer.compareTo(b.odometer);
      return byOdometer != 0 ? byOdometer : a.date.compareTo(b.date);
    });

  final result = <ConsumptionSegment>[];
  FillUpPoint? lastFull;
  var pendingLiters = 0.0;
  var unreliable = false;

  for (final point in list) {
    if (lastFull == null) {
      if (point.isFull) {
        lastFull = point;
        pendingLiters = 0;
        unreliable = point.isMissed;
      }
      continue;
    }

    final distance = point.odometer - lastFull.odometer;
    pendingLiters += point.liters;
    unreliable = unreliable || point.isMissed || point.excludeDistance;

    if (!point.isFull) continue;

    if (distance > 0) {
      result.add(
        ConsumptionSegment(
          fillUpId: point.id,
          date: point.date,
          distanceKm: distance,
          liters: pendingLiters,
          consumption: pendingLiters / distance * 100,
          reliable: !unreliable,
        ),
      );
    }

    lastFull = point;
    pendingLiters = 0;
    unreliable = point.isMissed;
  }

  return result;
}

/// Weighted average over reliable segments (total litres / total distance).
double? averageConsumption(Iterable<ConsumptionSegment> segments) {
  var liters = 0.0;
  var distance = 0.0;
  for (final segment in segments) {
    if (!segment.reliable) continue;
    liters += segment.liters;
    distance += segment.distanceKm;
  }
  if (distance <= 0) return null;
  return liters / distance * 100;
}

/// Consumption for the newest segment, even when it is flagged unreliable.
ConsumptionSegment? latestSegment(Iterable<ConsumptionSegment> segments) {
  ConsumptionSegment? latest;
  for (final segment in segments) {
    if (latest == null || segment.date.isAfter(latest.date)) latest = segment;
  }
  return latest;
}

/// Preview of the consumption a new fill-up would produce.
double? previewConsumption({
  required Iterable<FillUpPoint> existing,
  required DateTime date,
  required double odometer,
  required double liters,
  required bool isFull,
}) {
  final candidate = FillUpPoint(
    id: -1,
    date: date,
    odometer: odometer,
    liters: liters,
    isFull: isFull,
  );
  final segments = consumptionSegments([...existing, candidate]);
  final segment = latestSegment(segments);
  if (segment == null || segment.fillUpId != -1) return null;
  return segment.consumption;
}

/// Cost per kilometre for the driven distance.
double? costPerKm({required double cost, required double distanceKm}) {
  if (distanceKm <= 0) return null;
  return cost / distanceKm;
}

/// Distance driven between the first and last known odometer reading.
double drivenDistance({
  required Iterable<double> odometers,
  required double initialOdometer,
}) {
  final values = odometers.where((value) => value > 0).toList();
  if (values.isEmpty) return 0;
  final minOdometer = math.min(values.reduce(math.min), initialOdometer > 0 ? initialOdometer : double.infinity);
  final maxOdometer = values.reduce(math.max);
  return math.max(0, maxOdometer - minOdometer);
}
