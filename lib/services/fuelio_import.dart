import 'dart:math' as math;

import 'package:drift/drift.dart' show Value;

import '../app_state.dart';
import '../data/database.dart';
import '../util/format.dart';

class FuelioVehicleDraft {
  const FuelioVehicleDraft({
    required this.name,
    required this.make,
    required this.model,
    required this.plate,
    required this.year,
    required this.tankCapacity,
    required this.initialOdometer,
    required this.fuelType,
    required this.note,
    required this.externalId,
  });

  final String name;
  final String make;
  final String model;
  final String plate;
  final int? year;
  final double? tankCapacity;
  final double initialOdometer;
  final String fuelType;
  final String note;
  final String? externalId;
}

class FuelioFillUpDraft {
  const FuelioFillUpDraft({
    required this.date,
    required this.odometer,
    required this.liters,
    required this.totalPrice,
    required this.pricePerLiter,
    required this.isFull,
    required this.isMissed,
    required this.stationName,
    required this.latitude,
    required this.longitude,
    required this.note,
    required this.tankNumber,
    required this.excludeDistance,
    required this.externalId,
  });

  final DateTime date;
  final double odometer;
  final double liters;
  final double totalPrice;
  final double pricePerLiter;
  final bool isFull;
  final bool isMissed;
  final String stationName;
  final double? latitude;
  final double? longitude;
  final String note;
  final int tankNumber;
  final bool excludeDistance;
  final String? externalId;
}

class FuelioExpenseDraft {
  const FuelioExpenseDraft({
    required this.title,
    required this.date,
    required this.odometer,
    required this.categoryKey,
    required this.amount,
    required this.note,
    required this.isIncome,
    required this.externalId,
  });

  final String title;
  final DateTime date;
  final double? odometer;
  final String categoryKey;
  final double amount;
  final String note;
  final bool isIncome;
  final String? externalId;
}

class FuelioReminderDraft {
  const FuelioReminderDraft({
    required this.title,
    required this.categoryKey,
    required this.dueDate,
    required this.dueOdometer,
    required this.repeatMonths,
    required this.repeatKm,
    required this.note,
    required this.externalId,
  });

  final String title;
  final String categoryKey;
  final DateTime? dueDate;
  final double? dueOdometer;
  final int? repeatMonths;
  final double? repeatKm;
  final String note;
  final String? externalId;
}

class FuelioCategoryDraft {
  const FuelioCategoryDraft({
    required this.key,
    required this.label,
    required this.color,
  });

  final String key;
  final String label;
  final int color;
}

class FuelioStationDraft {
  const FuelioStationDraft({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.externalId,
  });

  final String name;
  final double? latitude;
  final double? longitude;
  final String? externalId;
}

class FuelioPreview {
  const FuelioPreview({
    required this.vehicle,
    required this.fillUps,
    required this.expenses,
    required this.reminders,
    required this.categories,
    required this.stations,
    required this.tripsSkipped,
    required this.skippedRows,
  });

  final FuelioVehicleDraft vehicle;
  final List<FuelioFillUpDraft> fillUps;
  final List<FuelioExpenseDraft> expenses;
  final List<FuelioReminderDraft> reminders;
  final List<FuelioCategoryDraft> categories;
  final List<FuelioStationDraft> stations;
  final int tripsSkipped;
  final int skippedRows;

  int get totalRecords =>
      fillUps.length + expenses.length + reminders.length;
}

class FuelioImportResult {
  const FuelioImportResult({
    required this.fillUps,
    required this.expenses,
    required this.reminders,
    required this.categories,
    required this.duplicates,
  });

  final int fillUps;
  final int expenses;
  final int reminders;
  final int categories;
  final int duplicates;

  int get total => fillUps + expenses + reminders;
}

class FuelioImporter {
  const FuelioImporter._();

  /// Parses a Fuelio CSV export. Throws [FormatException] when the file does
  /// not contain a `## Vehicle` section.
  static FuelioPreview parse(String input) {
    final rows = _parseCsv(input.replaceFirst('\uFEFF', ''));
    final sections = _sections(rows);

    final vehicleSection = sections['Vehicle'];
    if (vehicleSection == null || vehicleSection.rows.isEmpty) {
      throw const FormatException('Missing ## Vehicle section');
    }

    final categoryDrafts = <FuelioCategoryDraft>[];
    final categoryById = <String, String>{};
    final costCategories = sections['CostCategories'];
    if (costCategories != null) {
      for (final row in costCategories.rows) {
        final id = row.valueOf('CostTypeID');
        final name = row.valueOf('Name');
        if (id.isEmpty || name.isEmpty) continue;
        final key = _builtinCategoryKey(name);
        categoryById[id] = key;
        if (key.startsWith('f_')) {
          categoryDrafts.add(
            FuelioCategoryDraft(
              key: key,
              label: name,
              color: _parseColor(row.valueOf('color')),
            ),
          );
        }
      }
    }

    final vehicleRow = vehicleSection.rows.first;
    final fills = <FuelioFillUpDraft>[];
    final log = sections['Log'];
    if (log != null) {
      for (final row in log.rows) {
        final date = _parseDate(row.valueOf('Data'));
        final odometer = _parseDouble(row.valueOf('Odo (km)'));
        final liters = _parseDouble(row.valueOf('Fuel (litres)'));
        if (date == null || odometer == null || liters == null) continue;
        final price = _parseDouble(row.valueOf('Price (optional)'));
        final pricePerLiter =
            _parseDouble(row.valueOf('VolumePrice')) ??
            (price != null && liters > 0 ? price / liters : null);
        final total = price ?? (pricePerLiter == null ? 0 : liters * pricePerLiter);
        fills.add(
          FuelioFillUpDraft(
            date: date,
            odometer: odometer,
            liters: liters,
            totalPrice: total,
            pricePerLiter: pricePerLiter ?? 0,
            isFull: row.valueOf('Full') != '0',
            isMissed: row.valueOf('Missed') == '1',
            stationName: _stationName(row.valueOf('City (optional)')),
            latitude: _parseDouble(row.valueOf('latitude (optional)')),
            longitude: _parseDouble(row.valueOf('longitude (optional)')),
            note: row.valueOf('Notes (optional)'),
            tankNumber: int.tryParse(row.valueOf('TankNumber')) ?? 1,
            excludeDistance: row.valueOf('ExcludeDistance') == '1',
            externalId: _nonEmpty(row.valueOf('guid')) ??
                _nonEmpty(row.valueOf('UniqueId')),
          ),
        );
      }
    }

    final expenses = <FuelioExpenseDraft>[];
    final reminders = <FuelioReminderDraft>[];
    final costs = sections['Costs'];
    if (costs != null) {
      for (final row in costs.rows) {
        final title = row.valueOf('CostTitle');
        final date = _parseDate(row.valueOf('Date'));
        if (title.isEmpty || date == null) continue;
        final typeId = row.valueOf('CostTypeID');
        final categoryKey = categoryById[typeId] ?? 'other';
        final amount = _parseDouble(row.valueOf('Cost')) ?? 0;
        final odometer = _parseDouble(row.valueOf('Odo'));
        final isTemplate = row.valueOf('isTemplate') == '1';

        if (amount > 0 && !isTemplate) {
          expenses.add(
            FuelioExpenseDraft(
              title: title,
              date: date,
              odometer: odometer != null && odometer > 0 ? odometer : null,
              categoryKey: categoryKey,
              amount: amount,
              note: row.valueOf('Notes'),
              isIncome: row.valueOf('isIncome') == '1',
              externalId: _nonEmpty(row.valueOf('guid')),
            ),
          );
        }

        final remindDate = _parseDate(row.valueOf('RemindDate'));
        final remindOdo = _parseDouble(row.valueOf('RemindOdo'));
        final repeatMonths = int.tryParse(row.valueOf('RepeatMonths')) ?? 0;
        final repeatKm = _parseDouble(row.valueOf('RepeatOdo')) ?? 0;
        final hasReminder = (remindDate != null || (remindOdo ?? 0) > 0);
        if (hasReminder) {
          reminders.add(
            FuelioReminderDraft(
              title: title,
              categoryKey: categoryKey,
              dueDate: remindDate,
              dueOdometer: remindOdo != null && remindOdo > 0
                  ? remindOdo
                  : null,
              repeatMonths: repeatMonths > 0 ? repeatMonths : null,
              repeatKm: repeatKm > 0 ? repeatKm : null,
              note: row.valueOf('Notes'),
              externalId: '${_nonEmpty(row.valueOf('guid')) ?? title}:reminder',
            ),
          );
        }
      }
    }

    final stations = <FuelioStationDraft>[];
    final favStations = sections['FavStations'];
    if (favStations != null) {
      for (final row in favStations.rows) {
        final name = row.valueOf('NameBrand');
        if (name.isEmpty) continue;
        stations.add(
          FuelioStationDraft(
            name: name,
            latitude: _parseDouble(row.valueOf('Latitude')),
            longitude: _parseDouble(row.valueOf('Longitude')),
            externalId: _nonEmpty(row.valueOf('StationID')),
          ),
        );
      }
    }

    final minOdometer = fills.isEmpty
        ? 0.0
        : fills.map((f) => f.odometer).reduce(math.min);

    final trips = sections['TripLog'];

    return FuelioPreview(
      vehicle: FuelioVehicleDraft(
        name: vehicleRow.valueOf('Name').isEmpty
            ? 'Fuelio vehicle'
            : vehicleRow.valueOf('Name'),
        make: vehicleRow.valueOf('Make'),
        model: vehicleRow.valueOf('Model'),
        plate: vehicleRow.valueOf('Plate'),
        year: int.tryParse(vehicleRow.valueOf('Year')),
        tankCapacity: _parseDouble(vehicleRow.valueOf('Tank1Capacity')),
        initialOdometer: fills.isEmpty ? 0 : minOdometer,
        fuelType: _fuelType(vehicleRow.valueOf('Tank1Type')),
        note: vehicleRow.valueOf('Description'),
        externalId: _nonEmpty(vehicleRow.valueOf('guid')),
      ),
      fillUps: fills,
      expenses: expenses,
      reminders: reminders,
      categories: categoryDrafts,
      stations: stations,
      tripsSkipped: trips?.rows.length ?? 0,
      skippedRows: (log?.rows.length ?? 0) - fills.length,
    );
  }

  static Future<FuelioImportResult> apply(FuelioPreview preview) async {
    final db = AppState.instance.db;
    final repo = AppState.instance.repo;
    var duplicates = 0;
    var fillUps = 0;
    var expenses = 0;
    var reminders = 0;
    var categories = 0;

    final existingVehicle = preview.vehicle.externalId == null
        ? null
        : await (db.select(db.vehicles)..where(
                (v) => v.externalId.equals(preview.vehicle.externalId!),
              ))
            .getSingleOrNull();

    final vehicleId = existingVehicle?.id ??
        await repo.insertVehicle(
          VehiclesCompanion.insert(
            name: preview.vehicle.name,
            make: Value(preview.vehicle.make),
            model: Value(preview.vehicle.model),
            plate: Value(preview.vehicle.plate),
            year: Value(preview.vehicle.year),
            fuelType: Value(preview.vehicle.fuelType),
            tankCapacity: Value(preview.vehicle.tankCapacity),
            initialOdometer: Value(preview.vehicle.initialOdometer),
            notes: Value(preview.vehicle.note),
            externalId: Value(preview.vehicle.externalId),
          ),
        );

    for (final category in preview.categories) {
      final existing = await (db.select(db.expenseCategories)
            ..where((c) => c.key.equals(category.key)))
          .getSingleOrNull();
      if (existing != null) continue;
      await db.into(db.expenseCategories).insert(
        ExpenseCategoriesCompanion.insert(
          key: category.key,
          label: category.label,
          color: Value(category.color),
          isBuiltin: const Value(false),
        ),
      );
      categories++;
    }

    final existingFillIds = (await db.select(db.fillUps).get())
        .map((f) => f.externalId)
        .whereType<String>()
        .toSet();
    final existingExpenseIds = (await db.select(db.expenses).get())
        .map((e) => e.externalId)
        .whereType<String>()
        .toSet();
    final existingReminderIds = (await db.select(db.reminders).get())
        .map((r) => r.externalId)
        .whereType<String>()
        .toSet();

    for (final fill in preview.fillUps) {
      if (fill.externalId != null &&
          existingFillIds.contains(fill.externalId)) {
        duplicates++;
        continue;
      }
      await repo.insertFillUp(
        FillUpsCompanion.insert(
          vehicleId: vehicleId,
          date: fill.date,
          odometer: fill.odometer,
          liters: fill.liters,
          pricePerLiter: Value(fill.pricePerLiter),
          totalPrice: Value(fill.totalPrice),
          isFull: Value(fill.isFull),
          isMissed: Value(fill.isMissed),
          stationName: Value(fill.stationName),
          latitude: Value(fill.latitude),
          longitude: Value(fill.longitude),
          note: Value(fill.note),
          tankNumber: Value(fill.tankNumber),
          excludeDistance: Value(fill.excludeDistance),
          externalId: Value(fill.externalId),
        ),
      );
      fillUps++;
    }

    for (final expense in preview.expenses) {
      if (expense.externalId != null &&
          existingExpenseIds.contains(expense.externalId)) {
        duplicates++;
        continue;
      }
      await repo.insertExpense(
        ExpensesCompanion.insert(
          vehicleId: vehicleId,
          title: expense.title,
          date: expense.date,
          odometer: Value(expense.odometer),
          categoryKey: Value(expense.categoryKey),
          amount: Value(expense.amount),
          note: Value(expense.note),
          isIncome: Value(expense.isIncome),
          externalId: Value(expense.externalId),
        ),
      );
      expenses++;
    }

    for (final reminder in preview.reminders) {
      if (reminder.externalId != null &&
          existingReminderIds.contains(reminder.externalId)) {
        duplicates++;
        continue;
      }
      await repo.insertReminder(
        RemindersCompanion.insert(
          vehicleId: vehicleId,
          title: reminder.title,
          categoryKey: Value(reminder.categoryKey),
          dueDate: Value(reminder.dueDate),
          dueOdometer: Value(reminder.dueOdometer),
          repeatMonths: Value(reminder.repeatMonths),
          repeatKm: Value(reminder.repeatKm),
          note: Value(reminder.note),
          externalId: Value(reminder.externalId),
        ),
      );
      reminders++;
    }

    for (final station in preview.stations) {
      await db.into(db.stations).insert(
        StationsCompanion.insert(
          name: station.name,
          latitude: Value(station.latitude),
          longitude: Value(station.longitude),
          externalId: Value(station.externalId),
          isFavorite: const Value(true),
        ),
      );
    }

    return FuelioImportResult(
      fillUps: fillUps,
      expenses: expenses,
      reminders: reminders,
      categories: categories,
      duplicates: duplicates,
    );
  }

  // ------------------------------------------------------------------ helpers

  static Map<String, _Section> _sections(List<List<String>> rows) {
    final sections = <String, _Section>{};
    String? current;
    List<String>? header;

    for (final row in rows) {
      if (row.isEmpty) continue;
      final first = row.first.trim();
      if (first.startsWith('## ')) {
        current = first.substring(3).trim();
        header = null;
        sections[current] = _Section(const []);
        continue;
      }
      if (current == null) continue;
      if (header == null) {
        header = row.map((cell) => cell.trim()).toList();
        sections[current] = _Section(header);
        continue;
      }
      if (row.length == 1 && row.first.isEmpty) continue;
      sections[current]!.rows.add(_Row(header, row));
    }
    return sections;
  }

  static List<List<String>> _parseCsv(String input) {
    final rows = <List<String>>[];
    var row = <String>[];
    var field = StringBuffer();
    var inQuotes = false;

    for (var i = 0; i < input.length; i++) {
      final char = input[i];
      if (inQuotes) {
        if (char == '"') {
          if (i + 1 < input.length && input[i + 1] == '"') {
            field.write('"');
            i++;
          } else {
            inQuotes = false;
          }
        } else {
          field.write(char);
        }
        continue;
      }
      if (char == '"') {
        inQuotes = true;
      } else if (char == ',') {
        row.add(field.toString());
        field = StringBuffer();
      } else if (char == '\n') {
        row.add(field.toString());
        rows.add(row);
        row = <String>[];
        field = StringBuffer();
      } else if (char != '\r') {
        field.write(char);
      }
    }
    if (field.isNotEmpty || row.isNotEmpty) {
      row.add(field.toString());
      rows.add(row);
    }
    return rows;
  }

  static DateTime? _parseDate(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;
    final match = RegExp(
      r'^(\d{4})-(\d{2})-(\d{2})(?:[ T](\d{2}):(\d{2}))?',
    ).firstMatch(text);
    if (match == null) return null;
    final date = DateTime(
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      int.parse(match.group(3)!),
      int.tryParse(match.group(4) ?? '') ?? 0,
      int.tryParse(match.group(5) ?? '') ?? 0,
    );
    // Fuelio uses 2011-01-01 as "no reminder".
    if (date.isBefore(DateTime(2011, 1, 2))) return null;
    return date;
  }

  static double? _parseDouble(String? raw) {
    if (raw == null) return null;
    final text = raw.trim().replaceAll(',', '.');
    if (text.isEmpty) return null;
    return double.tryParse(text);
  }

  static String? _nonEmpty(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty || text == '0' ? null : text;
  }

  static String _stationName(String raw) {
    final text = raw.trim();
    return text.toUpperCase() == 'GPS' ? '' : text;
  }

  static String _fuelType(String? id) => switch (id) {
    '100' || '110' => 'petrol95',
    '111' || '112' => 'petrol98',
    '120' || '121' => 'diesel',
    '130' || '131' => 'lpg',
    '140' || '141' => 'cng',
    '150' => 'e85',
    '160' => 'electric',
    _ => 'petrol95',
  };

  static int _parseColor(String? raw) {
    final text = raw?.trim() ?? '';
    if (text.startsWith('#') && text.length == 7) {
      final value = int.tryParse(text.substring(1), radix: 16);
      if (value != null) return 0xFF000000 | value;
    }
    return 0xFF607D8B;
  }

  static String _builtinCategoryKey(String name) {
    final normalized = slugify(name);
    const map = {
      'sluzba': 'service',
      'udrzba': 'maintenance',
      'registracia': 'registration',
      'parkovanie': 'parking',
      'umytie': 'wash',
      'myto': 'toll',
      'blocky_pokuty': 'fines',
      'tuning': 'tuning',
      'poistenie': 'insurance',
      'stk_ek': 'inspection',
      'nadobudnutie_vozidla': 'purchase',
      'pneumatiky': 'tires',
    };
    return map[normalized] ?? 'other';
  }
}

class _Section {
  _Section(this.header);

  final List<String> header;
  final List<_Row> rows = [];
}

class _Row {
  const _Row(this._header, this._values);

  final List<String> _header;
  final List<String> _values;

  String valueOf(String column) {
    final index = _header.indexOf(column);
    if (index < 0 || index >= _values.length) return '';
    return _values[index].trim();
  }
}
