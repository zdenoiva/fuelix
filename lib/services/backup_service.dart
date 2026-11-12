import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../app_state.dart';
import '../data/database.dart';
import '../util/format.dart';

class BackupService {
  BackupService._();

  static Future<File> createBackup() async {
    final db = AppState.instance.db;
    final vehicles = await db.select(db.vehicles).get();
    final fills = await db.select(db.fillUps).get();
    final expenses = await db.select(db.expenses).get();
    final reminders = await db.select(db.reminders).get();
    final categories = await db.select(db.expenseCategories).get();
    final stations = await db.select(db.stations).get();

    final data = {
      'app': 'fuelix',
      'schema': 1,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      'vehicles': [for (final v in vehicles) _vehicleToJson(v)],
      'fillUps': [for (final f in fills) _fillUpToJson(f)],
      'expenses': [for (final e in expenses) _expenseToJson(e)],
      'reminders': [for (final r in reminders) _reminderToJson(r)],
      'categories': [
        for (final c in categories)
          {
            'key': c.key,
            'label': c.label,
            'color': c.color,
            'isBuiltin': c.isBuiltin,
          },
      ],
      'stations': [
        for (final s in stations)
          {
            'name': s.name,
            'brand': s.brand,
            'latitude': s.latitude,
            'longitude': s.longitude,
            'externalId': s.externalId,
            'isFavorite': s.isFavorite,
          },
      ],
    };

    final dir = await getTemporaryDirectory();
    final stamp = DateFormat('yyyyMMdd-HHmm').format(DateTime.now());
    final file = File(p.join(dir.path, 'fuelix-backup-$stamp.json'));
    await file.writeAsString(jsonEncode(data));
    return file;
  }

  static Future<File> exportCsv() async {
    final db = AppState.instance.db;
    final vehicles = await db.select(db.vehicles).get();
    final fills = await db.select(db.fillUps).get();
    final byId = {for (final v in vehicles) v.id: v};

    final buffer = StringBuffer()
      ..writeln(
        '"Vehicle","Date","Odometer (km)","Fuel (l)","Price per litre",'
        '"Total","Full","Missed","Station","Notes"',
      );
    for (final fill in fills) {
      buffer.writeln(
        [
          _csv(byId[fill.vehicleId]?.name ?? ''),
          _csv(isoDay(fill.date)),
          fill.odometer.toStringAsFixed(1),
          fill.liters.toStringAsFixed(3),
          fill.pricePerLiter.toStringAsFixed(3),
          fill.totalPrice.toStringAsFixed(2),
          fill.isFull ? '1' : '0',
          fill.isMissed ? '1' : '0',
          _csv(fill.stationName),
          _csv(fill.note),
        ].join(','),
      );
    }

    final dir = await getTemporaryDirectory();
    final stamp = DateFormat('yyyyMMdd-HHmm').format(DateTime.now());
    final file = File(p.join(dir.path, 'fuelix-$stamp.csv'));
    await file.writeAsString(buffer.toString());
    return file;
  }

  /// Saves [file] through the system file picker, falling back to sharing.
  static Future<bool> saveFile(File file, {String? mimeType}) async {
    final bytes = await file.readAsBytes();
    try {
      final uri = await FilePicker.saveFile(
        dialogTitle: p.basename(file.path),
        fileName: p.basename(file.path),
        bytes: bytes,
        mimeType: mimeType ?? 'application/octet-stream',
      );
      if (uri != null) return true;
    } catch (_) {
      // Fall through to sharing.
    }
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path, mimeType: mimeType)]),
    );
    return true;
  }

  static Future<int> restore(Uint8List bytes) async {
    final decoded = jsonDecode(utf8.decode(bytes));
    if (decoded is! Map) throw const FormatException('Invalid backup');
    final map = Map<String, dynamic>.from(decoded);
    if (map['app'] != 'fuelix') {
      throw const FormatException('Not a Fuelix backup');
    }

    final db = AppState.instance.db;
    await db.transaction(() async {
      await db.delete(db.expenses).go();
      await db.delete(db.reminders).go();
      await db.delete(db.fillUps).go();
      await db.delete(db.vehicles).go();
      await db.delete(db.stations).go();
      await (db.delete(db.expenseCategories)
            ..where((c) => c.isBuiltin.equals(false)))
          .go();

      for (final raw in (map['categories'] as List? ?? const [])) {
        final item = Map<String, dynamic>.from(raw as Map);
        await db.into(db.expenseCategories).insertOnConflictUpdate(
          ExpenseCategoriesCompanion.insert(
            key: item['key'] as String,
            label: item['label'] as String,
            color: Value((item['color'] as num?)?.toInt() ?? 0xFF607D8B),
            isBuiltin: Value(item['isBuiltin'] as bool? ?? false),
          ),
        );
      }

      for (final raw in (map['vehicles'] as List? ?? const [])) {
        final item = Map<String, dynamic>.from(raw as Map);
        await db.into(db.vehicles).insert(
          VehiclesCompanion.insert(
            id: Value(item['id'] as int),
            name: item['name'] as String,
            make: Value(item['make'] as String? ?? ''),
            model: Value(item['model'] as String? ?? ''),
            plate: Value(item['plate'] as String? ?? ''),
            year: Value(item['year'] as int?),
            fuelType: Value(item['fuelType'] as String? ?? 'petrol95'),
            tankCapacity: Value((item['tankCapacity'] as num?)?.toDouble()),
            initialOdometer: Value(
              (item['initialOdometer'] as num?)?.toDouble() ?? 0,
            ),
            currency: Value(item['currency'] as String? ?? 'EUR'),
            notes: Value(item['notes'] as String? ?? ''),
            externalId: Value(item['externalId'] as String?),
            isArchived: Value(item['isArchived'] as bool? ?? false),
            createdAt: Value(DateTime.parse(item['createdAt'] as String)),
          ),
        );
      }

      for (final raw in (map['fillUps'] as List? ?? const [])) {
        final item = Map<String, dynamic>.from(raw as Map);
        await db.into(db.fillUps).insert(
          FillUpsCompanion.insert(
            id: Value(item['id'] as int),
            vehicleId: item['vehicleId'] as int,
            date: DateTime.parse(item['date'] as String),
            odometer: (item['odometer'] as num).toDouble(),
            liters: (item['liters'] as num).toDouble(),
            pricePerLiter: Value(
              (item['pricePerLiter'] as num?)?.toDouble() ?? 0,
            ),
            totalPrice: Value((item['totalPrice'] as num?)?.toDouble() ?? 0),
            isFull: Value(item['isFull'] as bool? ?? true),
            isMissed: Value(item['isMissed'] as bool? ?? false),
            stationName: Value(item['stationName'] as String? ?? ''),
            latitude: Value((item['latitude'] as num?)?.toDouble()),
            longitude: Value((item['longitude'] as num?)?.toDouble()),
            note: Value(item['note'] as String? ?? ''),
            fuelType: Value(item['fuelType'] as String?),
            tankNumber: Value(item['tankNumber'] as int? ?? 1),
            excludeDistance: Value(item['excludeDistance'] as bool? ?? false),
            receiptPath: Value(item['receiptPath'] as String?),
            externalId: Value(item['externalId'] as String?),
            createdAt: Value(DateTime.parse(item['createdAt'] as String)),
          ),
        );
      }

      for (final raw in (map['expenses'] as List? ?? const [])) {
        final item = Map<String, dynamic>.from(raw as Map);
        await db.into(db.expenses).insert(
          ExpensesCompanion.insert(
            id: Value(item['id'] as int),
            vehicleId: item['vehicleId'] as int,
            title: item['title'] as String,
            date: DateTime.parse(item['date'] as String),
            odometer: Value((item['odometer'] as num?)?.toDouble()),
            categoryKey: Value(item['categoryKey'] as String? ?? 'other'),
            amount: Value((item['amount'] as num?)?.toDouble() ?? 0),
            note: Value(item['note'] as String? ?? ''),
            isIncome: Value(item['isIncome'] as bool? ?? false),
            receiptPath: Value(item['receiptPath'] as String?),
            externalId: Value(item['externalId'] as String?),
            createdAt: Value(DateTime.parse(item['createdAt'] as String)),
          ),
        );
      }

      for (final raw in (map['reminders'] as List? ?? const [])) {
        final item = Map<String, dynamic>.from(raw as Map);
        await db.into(db.reminders).insert(
          RemindersCompanion.insert(
            id: Value(item['id'] as int),
            vehicleId: item['vehicleId'] as int,
            title: item['title'] as String,
            categoryKey: Value(item['categoryKey'] as String? ?? 'service'),
            dueDate: Value(_parseDate(item['dueDate'])),
            dueOdometer: Value((item['dueOdometer'] as num?)?.toDouble()),
            repeatMonths: Value(item['repeatMonths'] as int?),
            repeatKm: Value((item['repeatKm'] as num?)?.toDouble()),
            advanceDays: Value(item['advanceDays'] as int? ?? 14),
            advanceKm: Value((item['advanceKm'] as num?)?.toDouble() ?? 500),
            lastDoneDate: Value(_parseDate(item['lastDoneDate'])),
            lastDoneOdometer: Value(
              (item['lastDoneOdometer'] as num?)?.toDouble(),
            ),
            note: Value(item['note'] as String? ?? ''),
            isActive: Value(item['isActive'] as bool? ?? true),
            externalId: Value(item['externalId'] as String?),
            createdAt: Value(DateTime.parse(item['createdAt'] as String)),
          ),
        );
      }

      for (final raw in (map['stations'] as List? ?? const [])) {
        final item = Map<String, dynamic>.from(raw as Map);
        await db.into(db.stations).insert(
          StationsCompanion.insert(
            name: item['name'] as String,
            brand: Value(item['brand'] as String? ?? ''),
            latitude: Value((item['latitude'] as num?)?.toDouble()),
            longitude: Value((item['longitude'] as num?)?.toDouble()),
            externalId: Value(item['externalId'] as String?),
            isFavorite: Value(item['isFavorite'] as bool? ?? false),
          ),
        );
      }
    });

    return (map['fillUps'] as List? ?? const []).length;
  }

  static DateTime? _parseDate(Object? value) =>
      value == null ? null : DateTime.tryParse(value as String);

  static Map<String, Object?> _vehicleToJson(Vehicle v) => {
    'id': v.id,
    'name': v.name,
    'make': v.make,
    'model': v.model,
    'plate': v.plate,
    'year': v.year,
    'fuelType': v.fuelType,
    'tankCapacity': v.tankCapacity,
    'initialOdometer': v.initialOdometer,
    'currency': v.currency,
    'notes': v.notes,
    'externalId': v.externalId,
    'isArchived': v.isArchived,
    'createdAt': v.createdAt.toIso8601String(),
  };

  static Map<String, Object?> _fillUpToJson(FillUp f) => {
    'id': f.id,
    'vehicleId': f.vehicleId,
    'date': f.date.toIso8601String(),
    'odometer': f.odometer,
    'liters': f.liters,
    'pricePerLiter': f.pricePerLiter,
    'totalPrice': f.totalPrice,
    'isFull': f.isFull,
    'isMissed': f.isMissed,
    'stationName': f.stationName,
    'latitude': f.latitude,
    'longitude': f.longitude,
    'note': f.note,
    'fuelType': f.fuelType,
    'tankNumber': f.tankNumber,
    'excludeDistance': f.excludeDistance,
    'receiptPath': f.receiptPath,
    'externalId': f.externalId,
    'createdAt': f.createdAt.toIso8601String(),
  };

  static Map<String, Object?> _expenseToJson(Expense e) => {
    'id': e.id,
    'vehicleId': e.vehicleId,
    'title': e.title,
    'date': e.date.toIso8601String(),
    'odometer': e.odometer,
    'categoryKey': e.categoryKey,
    'amount': e.amount,
    'note': e.note,
    'isIncome': e.isIncome,
    'receiptPath': e.receiptPath,
    'externalId': e.externalId,
    'createdAt': e.createdAt.toIso8601String(),
  };

  static Map<String, Object?> _reminderToJson(Reminder r) => {
    'id': r.id,
    'vehicleId': r.vehicleId,
    'title': r.title,
    'categoryKey': r.categoryKey,
    'dueDate': r.dueDate?.toIso8601String(),
    'dueOdometer': r.dueOdometer,
    'repeatMonths': r.repeatMonths,
    'repeatKm': r.repeatKm,
    'advanceDays': r.advanceDays,
    'advanceKm': r.advanceKm,
    'lastDoneDate': r.lastDoneDate?.toIso8601String(),
    'lastDoneOdometer': r.lastDoneOdometer,
    'note': r.note,
    'isActive': r.isActive,
    'externalId': r.externalId,
    'createdAt': r.createdAt.toIso8601String(),
  };

  static String _csv(String value) =>
      '"${value.replaceAll('"', '""')}"';
}
