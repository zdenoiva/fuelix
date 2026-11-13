import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

class Vehicles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get make => text().withDefault(const Constant(''))();
  TextColumn get model => text().withDefault(const Constant(''))();
  TextColumn get plate => text().withDefault(const Constant(''))();
  IntColumn get year => integer().nullable()();
  TextColumn get fuelType => text().withDefault(const Constant('petrol95'))();
  RealColumn get tankCapacity => real().nullable()();
  RealColumn get initialOdometer => real().withDefault(const Constant(0))();
  TextColumn get currency => text().withDefault(const Constant('EUR'))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get externalId => text().nullable()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class FillUps extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vehicleId =>
      integer().references(Vehicles, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get date => dateTime()();
  RealColumn get odometer => real()();
  RealColumn get liters => real()();
  RealColumn get pricePerLiter => real().withDefault(const Constant(0))();
  RealColumn get totalPrice => real().withDefault(const Constant(0))();
  BoolColumn get isFull => boolean().withDefault(const Constant(true))();
  BoolColumn get isMissed => boolean().withDefault(const Constant(false))();
  TextColumn get stationName => text().withDefault(const Constant(''))();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get note => text().withDefault(const Constant(''))();
  TextColumn get fuelType => text().nullable()();
  IntColumn get tankNumber => integer().withDefault(const Constant(1))();
  BoolColumn get excludeDistance =>
      boolean().withDefault(const Constant(false))();
  TextColumn get receiptPath => text().nullable()();
  TextColumn get externalId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class ExpenseCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  TextColumn get label => text()();
  IntColumn get color => integer().withDefault(const Constant(0xFF607D8B))();
  BoolColumn get isBuiltin => boolean().withDefault(const Constant(false))();
}

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vehicleId =>
      integer().references(Vehicles, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  DateTimeColumn get date => dateTime()();
  RealColumn get odometer => real().nullable()();
  TextColumn get categoryKey => text().withDefault(const Constant('other'))();
  RealColumn get amount => real().withDefault(const Constant(0))();
  TextColumn get note => text().withDefault(const Constant(''))();
  BoolColumn get isIncome => boolean().withDefault(const Constant(false))();
  TextColumn get receiptPath => text().nullable()();
  TextColumn get externalId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Reminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vehicleId =>
      integer().references(Vehicles, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  TextColumn get categoryKey => text().withDefault(const Constant('service'))();
  DateTimeColumn get dueDate => dateTime().nullable()();
  RealColumn get dueOdometer => real().nullable()();
  IntColumn get repeatMonths => integer().nullable()();
  RealColumn get repeatKm => real().nullable()();
  IntColumn get advanceDays => integer().withDefault(const Constant(14))();
  RealColumn get advanceKm => real().withDefault(const Constant(500))();
  DateTimeColumn get lastDoneDate => dateTime().nullable()();
  RealColumn get lastDoneOdometer => real().nullable()();
  TextColumn get note => text().withDefault(const Constant(''))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get externalId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Stations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get brand => text().withDefault(const Constant(''))();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get externalId => text().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastUsedAt => dateTime().nullable()();
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    Vehicles,
    FillUps,
    Expenses,
    ExpenseCategories,
    Reminders,
    Stations,
    AppSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'fuelix'));

  /// Used by tests to open an in-memory database.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seed();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(vehicles, vehicles.isFavorite);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> _seed() async {
    const builtin = [
      ('service', 'Služba', 0xFF2196F3),
      ('maintenance', 'Údržba', 0xFF673AB7),
      ('registration', 'Registrácia', 0xFF3F51B5),
      ('parking', 'Parkovanie', 0xFF9E9E9E),
      ('wash', 'Umytie', 0xFFFFEB3B),
      ('toll', 'Mýto', 0xFF795548),
      ('fines', 'Pokuty', 0xFF880E4F),
      ('tuning', 'Tuning', 0xFFE91E63),
      ('insurance', 'Poistenie', 0xFF4CAF50),
      ('inspection', 'STK/EK', 0xFFE91E63),
      ('purchase', 'Nadobudnutie vozidla', 0xFFCDDC39),
      ('tires', 'Pneumatiky', 0xFF607D8B),
      ('other', 'Ostatné', 0xFF607D8B),
    ];
    await batch((b) {
      b.insertAll(expenseCategories, [
        for (final c in builtin)
          ExpenseCategoriesCompanion.insert(
            key: c.$1,
            label: c.$2,
            color: Value(c.$3),
            isBuiltin: const Value(true),
          ),
      ]);
    });
  }
}
