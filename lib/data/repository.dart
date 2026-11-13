import 'package:drift/drift.dart';

import '../domain/consumption.dart';
import 'database.dart';

class VehicleStats {
  const VehicleStats({
    required this.latestSegment,
    required this.averageConsumption,
    required this.totalCost,
    required this.fuelCost,
    required this.distanceKm,
    required this.costPerKm,
    required this.nextReminder,
    required this.fillUpCount,
  });

  final ConsumptionSegment? latestSegment;
  final double? averageConsumption;
  final double totalCost;
  final double fuelCost;
  final double distanceKm;
  final double? costPerKm;
  final Reminder? nextReminder;
  final int fillUpCount;
}

class FuelixRepository {
  FuelixRepository(this.db);

  final AppDatabase db;

  // ---------------------------------------------------------------- vehicles

  Stream<List<Vehicle>> watchVehicles({bool includeArchived = false}) {
    final query = db.select(db.vehicles);
    if (!includeArchived) {
      query.where((v) => v.isArchived.equals(false));
    }
    query.orderBy([(v) => OrderingTerm.asc(v.createdAt)]);
    return query.watch();
  }

  Future<List<Vehicle>> vehicles({bool includeArchived = false}) {
    final query = db.select(db.vehicles);
    if (!includeArchived) {
      query.where((v) => v.isArchived.equals(false));
    }
    query.orderBy([(v) => OrderingTerm.asc(v.createdAt)]);
    return query.get();
  }

  Future<Vehicle?> vehicle(int id) =>
      (db.select(db.vehicles)..where((v) => v.id.equals(id)))
          .getSingleOrNull();

  Future<int> insertVehicle(VehiclesCompanion vehicle) =>
      db.into(db.vehicles).insert(vehicle);

  Future<void> updateVehicle(VehiclesCompanion vehicle) =>
      (db.update(db.vehicles)..where((v) => v.id.equals(vehicle.id.value)))
          .write(vehicle);

  Future<void> deleteVehicle(int id) =>
      (db.delete(db.vehicles)..where((v) => v.id.equals(id))).go();

  Stream<Vehicle?> watchFavoriteVehicle() =>
      (db.select(db.vehicles)
            ..where((v) => v.isFavorite.equals(true))
            ..limit(1))
          .watchSingleOrNull();

  Future<Vehicle?> favoriteVehicle() =>
      (db.select(db.vehicles)
            ..where((v) => v.isFavorite.equals(true))
            ..limit(1))
          .getSingleOrNull();

  /// Marks [vehicleId] as the only favourite vehicle.
  Future<void> setFavoriteVehicle(int vehicleId) async {
    await db.transaction(() async {
      await db.update(db.vehicles).write(
        const VehiclesCompanion(isFavorite: Value(false)),
      );
      await (db.update(db.vehicles)..where((v) => v.id.equals(vehicleId)))
          .write(const VehiclesCompanion(isFavorite: Value(true)));
    });
  }

  Future<void> clearFavoriteVehicle() => db.update(db.vehicles).write(
    const VehiclesCompanion(isFavorite: Value(false)),
  );

  // ----------------------------------------------------------------- fillups

  Stream<List<FillUp>> watchFillUps(int vehicleId) {
    return (db.select(db.fillUps)
          ..where((f) => f.vehicleId.equals(vehicleId))
          ..orderBy([
            (f) => OrderingTerm.desc(f.odometer),
            (f) => OrderingTerm.desc(f.date),
          ]))
        .watch();
  }

  Future<List<FillUp>> fillUps(int vehicleId) {
    return (db.select(db.fillUps)
          ..where((f) => f.vehicleId.equals(vehicleId))
          ..orderBy([
            (f) => OrderingTerm.asc(f.odometer),
            (f) => OrderingTerm.asc(f.date),
          ]))
        .get();
  }

  Stream<List<FillUp>> watchAllFillUps() => db.select(db.fillUps).watch();

  Future<List<FillUp>> allFillUps() =>
      (db.select(db.fillUps)..orderBy([(f) => OrderingTerm.asc(f.date)]))
          .get();

  Future<FillUp?> lastFillUp(int vehicleId) {
    return (db.select(db.fillUps)
          ..where((f) => f.vehicleId.equals(vehicleId))
          ..orderBy([(f) => OrderingTerm.desc(f.odometer)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Last distinct station names used for this vehicle, newest first.
  Future<List<String>> recentStations(int vehicleId, {int limit = 3}) async {
    final rows = await (db.select(db.fillUps)
          ..where(
            (f) =>
                f.vehicleId.equals(vehicleId) &
                f.stationName.isBiggerThanValue(''),
          )
          ..orderBy([(f) => OrderingTerm.desc(f.date)])
          ..limit(40))
        .get();
    final seen = <String>{};
    final names = <String>[];
    for (final row in rows) {
      final name = row.stationName.trim();
      if (name.isEmpty || !seen.add(name)) continue;
      names.add(name);
      if (names.length >= limit) break;
    }
    return names;
  }

  Future<int> insertFillUp(FillUpsCompanion fillUp) =>
      db.into(db.fillUps).insert(fillUp);

  Future<void> updateFillUp(FillUpsCompanion fillUp) =>
      (db.update(db.fillUps)..where((f) => f.id.equals(fillUp.id.value)))
          .write(fillUp);

  Future<void> deleteFillUp(int id) =>
      (db.delete(db.fillUps)..where((f) => f.id.equals(id))).go();

  // ---------------------------------------------------------------- expenses

  Stream<List<Expense>> watchExpenses(int vehicleId) {
    return (db.select(db.expenses)
          ..where((e) => e.vehicleId.equals(vehicleId))
          ..orderBy([(e) => OrderingTerm.desc(e.date)]))
        .watch();
  }

  Future<List<Expense>> expenses(int vehicleId) {
    return (db.select(db.expenses)
          ..where((e) => e.vehicleId.equals(vehicleId))
          ..orderBy([(e) => OrderingTerm.desc(e.date)]))
        .get();
  }

  Stream<List<Expense>> watchAllExpenses() =>
      db.select(db.expenses).watch();

  Future<List<Expense>> allExpenses() =>
      (db.select(db.expenses)..orderBy([(e) => OrderingTerm.asc(e.date)]))
          .get();

  Future<int> insertExpense(ExpensesCompanion expense) =>
      db.into(db.expenses).insert(expense);

  Future<void> updateExpense(ExpensesCompanion expense) =>
      (db.update(db.expenses)..where((e) => e.id.equals(expense.id.value)))
          .write(expense);

  Future<void> deleteExpense(int id) =>
      (db.delete(db.expenses)..where((e) => e.id.equals(id))).go();

  // --------------------------------------------------------------- reminders

  Stream<List<Reminder>> watchReminders(int vehicleId) {
    return (db.select(db.reminders)
          ..where((r) => r.vehicleId.equals(vehicleId) & r.isActive.equals(true))
          ..orderBy([(r) => OrderingTerm.asc(r.dueDate)]))
        .watch();
  }

  Future<List<Reminder>> reminders(int vehicleId) {
    return (db.select(db.reminders)
          ..where(
            (r) => r.vehicleId.equals(vehicleId) & r.isActive.equals(true),
          )
          ..orderBy([(r) => OrderingTerm.asc(r.dueDate)]))
        .get();
  }

  Future<List<Reminder>> allReminders() => db.select(db.reminders).get();

  Future<int> insertReminder(RemindersCompanion reminder) =>
      db.into(db.reminders).insert(reminder);

  Future<void> updateReminder(RemindersCompanion reminder) =>
      (db.update(db.reminders)..where((r) => r.id.equals(reminder.id.value)))
          .write(reminder);

  Future<void> deleteReminder(int id) =>
      (db.delete(db.reminders)..where((r) => r.id.equals(id))).go();

  // -------------------------------------------------------------- categories

  Future<List<ExpenseCategory>> categories() =>
      (db.select(db.expenseCategories)..orderBy([(c) => OrderingTerm.asc(c.id)]))
          .get();

  Stream<List<ExpenseCategory>> watchCategories() =>
      (db.select(db.expenseCategories)..orderBy([(c) => OrderingTerm.asc(c.id)]))
          .watch();

  // ------------------------------------------------------------------ stats

  Future<VehicleStats> stats(int vehicleId) async {
    final vehicle = await this.vehicle(vehicleId);
    final fills = await fillUps(vehicleId);
    final costs = await expenses(vehicleId);
    final openReminders = await reminders(vehicleId);

    final points = fills.map(_point).toList();
    final segments = consumptionSegments(points);
    final distance = drivenDistance(
      odometers: fills.map((f) => f.odometer),
      initialOdometer: vehicle?.initialOdometer ?? 0,
    );
    final fuelCost = fills.fold<double>(0, (sum, f) => sum + f.totalPrice);
    final extraCost = costs.fold<double>(
      0,
      (sum, c) => sum + (c.isIncome ? -c.amount : c.amount),
    );
    final totalCost = fuelCost + extraCost;

    return VehicleStats(
      latestSegment: latestSegment(segments),
      averageConsumption: averageConsumption(segments),
      totalCost: totalCost,
      fuelCost: fuelCost,
      distanceKm: distance,
      costPerKm: costPerKm(cost: totalCost, distanceKm: distance),
      nextReminder: _nextReminder(openReminders, fills),
      fillUpCount: fills.length,
    );
  }

  ConsumptionSegment? latestConsumptionFor(List<FillUp> fills) =>
      latestSegment(consumptionSegments(fills.map(_point)));

  double? averageFor(List<FillUp> fills) =>
      averageConsumption(consumptionSegments(fills.map(_point)));

  FillUpPoint _point(FillUp fill) => FillUpPoint(
    id: fill.id,
    date: fill.date,
    odometer: fill.odometer,
    liters: fill.liters,
    isFull: fill.isFull,
    isMissed: fill.isMissed,
    excludeDistance: fill.excludeDistance,
  );

  Reminder? _nextReminder(List<Reminder> reminders, List<FillUp> fills) {
    if (reminders.isEmpty) return null;
    final currentOdometer = fills.isEmpty ? 0.0 : fills.last.odometer;
    Reminder? best;
    DateTime? bestDate;

    for (final reminder in reminders) {
      final due = _effectiveDue(reminder, currentOdometer);
      if (due == null) continue;
      if (best == null || due.isBefore(bestDate!)) {
        best = reminder;
        bestDate = due;
      }
    }
    return best;
  }

  DateTime? _effectiveDue(Reminder reminder, double currentOdometer) {
    if (reminder.dueDate != null) return reminder.dueDate;
    final dueKm = reminder.dueOdometer;
    if (dueKm == null) return null;
    final kmLeft = dueKm - currentOdometer;
    // Rough estimate: 1 500 km per month for date-less reminders.
    return DateTime.now().add(Duration(days: (kmLeft / 50).round()));
  }

  // ----------------------------------------------------------------- settings

  Future<String?> setting(String key) async {
    final row = await (db.select(db.appSettings)
          ..where((s) => s.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String value) =>
      db.into(db.appSettings).insertOnConflictUpdate(
        AppSettingsCompanion.insert(key: key, value: value),
      );
}
