// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $VehiclesTable extends Vehicles with TableInfo<$VehiclesTable, Vehicle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _makeMeta = const VerificationMeta('make');
  @override
  late final GeneratedColumn<String> make = GeneratedColumn<String>(
    'make',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _plateMeta = const VerificationMeta('plate');
  @override
  late final GeneratedColumn<String> plate = GeneratedColumn<String>(
    'plate',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fuelTypeMeta = const VerificationMeta(
    'fuelType',
  );
  @override
  late final GeneratedColumn<String> fuelType = GeneratedColumn<String>(
    'fuel_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('petrol95'),
  );
  static const VerificationMeta _tankCapacityMeta = const VerificationMeta(
    'tankCapacity',
  );
  @override
  late final GeneratedColumn<double> tankCapacity = GeneratedColumn<double>(
    'tank_capacity',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _initialOdometerMeta = const VerificationMeta(
    'initialOdometer',
  );
  @override
  late final GeneratedColumn<double> initialOdometer = GeneratedColumn<double>(
    'initial_odometer',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('EUR'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    make,
    model,
    plate,
    year,
    fuelType,
    tankCapacity,
    initialOdometer,
    currency,
    notes,
    externalId,
    isArchived,
    isFavorite,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Vehicle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('make')) {
      context.handle(
        _makeMeta,
        make.isAcceptableOrUnknown(data['make']!, _makeMeta),
      );
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    }
    if (data.containsKey('plate')) {
      context.handle(
        _plateMeta,
        plate.isAcceptableOrUnknown(data['plate']!, _plateMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('fuel_type')) {
      context.handle(
        _fuelTypeMeta,
        fuelType.isAcceptableOrUnknown(data['fuel_type']!, _fuelTypeMeta),
      );
    }
    if (data.containsKey('tank_capacity')) {
      context.handle(
        _tankCapacityMeta,
        tankCapacity.isAcceptableOrUnknown(
          data['tank_capacity']!,
          _tankCapacityMeta,
        ),
      );
    }
    if (data.containsKey('initial_odometer')) {
      context.handle(
        _initialOdometerMeta,
        initialOdometer.isAcceptableOrUnknown(
          data['initial_odometer']!,
          _initialOdometerMeta,
        ),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vehicle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vehicle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      make: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}make'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      plate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plate'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      fuelType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fuel_type'],
      )!,
      tankCapacity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tank_capacity'],
      ),
      initialOdometer: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}initial_odometer'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $VehiclesTable createAlias(String alias) {
    return $VehiclesTable(attachedDatabase, alias);
  }
}

class Vehicle extends DataClass implements Insertable<Vehicle> {
  final int id;
  final String name;
  final String make;
  final String model;
  final String plate;
  final int? year;
  final String fuelType;
  final double? tankCapacity;
  final double initialOdometer;
  final String currency;
  final String notes;
  final String? externalId;
  final bool isArchived;
  final bool isFavorite;
  final DateTime createdAt;
  const Vehicle({
    required this.id,
    required this.name,
    required this.make,
    required this.model,
    required this.plate,
    this.year,
    required this.fuelType,
    this.tankCapacity,
    required this.initialOdometer,
    required this.currency,
    required this.notes,
    this.externalId,
    required this.isArchived,
    required this.isFavorite,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['make'] = Variable<String>(make);
    map['model'] = Variable<String>(model);
    map['plate'] = Variable<String>(plate);
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    map['fuel_type'] = Variable<String>(fuelType);
    if (!nullToAbsent || tankCapacity != null) {
      map['tank_capacity'] = Variable<double>(tankCapacity);
    }
    map['initial_odometer'] = Variable<double>(initialOdometer);
    map['currency'] = Variable<String>(currency);
    map['notes'] = Variable<String>(notes);
    if (!nullToAbsent || externalId != null) {
      map['external_id'] = Variable<String>(externalId);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  VehiclesCompanion toCompanion(bool nullToAbsent) {
    return VehiclesCompanion(
      id: Value(id),
      name: Value(name),
      make: Value(make),
      model: Value(model),
      plate: Value(plate),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      fuelType: Value(fuelType),
      tankCapacity: tankCapacity == null && nullToAbsent
          ? const Value.absent()
          : Value(tankCapacity),
      initialOdometer: Value(initialOdometer),
      currency: Value(currency),
      notes: Value(notes),
      externalId: externalId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalId),
      isArchived: Value(isArchived),
      isFavorite: Value(isFavorite),
      createdAt: Value(createdAt),
    );
  }

  factory Vehicle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vehicle(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      make: serializer.fromJson<String>(json['make']),
      model: serializer.fromJson<String>(json['model']),
      plate: serializer.fromJson<String>(json['plate']),
      year: serializer.fromJson<int?>(json['year']),
      fuelType: serializer.fromJson<String>(json['fuelType']),
      tankCapacity: serializer.fromJson<double?>(json['tankCapacity']),
      initialOdometer: serializer.fromJson<double>(json['initialOdometer']),
      currency: serializer.fromJson<String>(json['currency']),
      notes: serializer.fromJson<String>(json['notes']),
      externalId: serializer.fromJson<String?>(json['externalId']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'make': serializer.toJson<String>(make),
      'model': serializer.toJson<String>(model),
      'plate': serializer.toJson<String>(plate),
      'year': serializer.toJson<int?>(year),
      'fuelType': serializer.toJson<String>(fuelType),
      'tankCapacity': serializer.toJson<double?>(tankCapacity),
      'initialOdometer': serializer.toJson<double>(initialOdometer),
      'currency': serializer.toJson<String>(currency),
      'notes': serializer.toJson<String>(notes),
      'externalId': serializer.toJson<String?>(externalId),
      'isArchived': serializer.toJson<bool>(isArchived),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Vehicle copyWith({
    int? id,
    String? name,
    String? make,
    String? model,
    String? plate,
    Value<int?> year = const Value.absent(),
    String? fuelType,
    Value<double?> tankCapacity = const Value.absent(),
    double? initialOdometer,
    String? currency,
    String? notes,
    Value<String?> externalId = const Value.absent(),
    bool? isArchived,
    bool? isFavorite,
    DateTime? createdAt,
  }) => Vehicle(
    id: id ?? this.id,
    name: name ?? this.name,
    make: make ?? this.make,
    model: model ?? this.model,
    plate: plate ?? this.plate,
    year: year.present ? year.value : this.year,
    fuelType: fuelType ?? this.fuelType,
    tankCapacity: tankCapacity.present ? tankCapacity.value : this.tankCapacity,
    initialOdometer: initialOdometer ?? this.initialOdometer,
    currency: currency ?? this.currency,
    notes: notes ?? this.notes,
    externalId: externalId.present ? externalId.value : this.externalId,
    isArchived: isArchived ?? this.isArchived,
    isFavorite: isFavorite ?? this.isFavorite,
    createdAt: createdAt ?? this.createdAt,
  );
  Vehicle copyWithCompanion(VehiclesCompanion data) {
    return Vehicle(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      make: data.make.present ? data.make.value : this.make,
      model: data.model.present ? data.model.value : this.model,
      plate: data.plate.present ? data.plate.value : this.plate,
      year: data.year.present ? data.year.value : this.year,
      fuelType: data.fuelType.present ? data.fuelType.value : this.fuelType,
      tankCapacity: data.tankCapacity.present
          ? data.tankCapacity.value
          : this.tankCapacity,
      initialOdometer: data.initialOdometer.present
          ? data.initialOdometer.value
          : this.initialOdometer,
      currency: data.currency.present ? data.currency.value : this.currency,
      notes: data.notes.present ? data.notes.value : this.notes,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vehicle(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('make: $make, ')
          ..write('model: $model, ')
          ..write('plate: $plate, ')
          ..write('year: $year, ')
          ..write('fuelType: $fuelType, ')
          ..write('tankCapacity: $tankCapacity, ')
          ..write('initialOdometer: $initialOdometer, ')
          ..write('currency: $currency, ')
          ..write('notes: $notes, ')
          ..write('externalId: $externalId, ')
          ..write('isArchived: $isArchived, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    make,
    model,
    plate,
    year,
    fuelType,
    tankCapacity,
    initialOdometer,
    currency,
    notes,
    externalId,
    isArchived,
    isFavorite,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vehicle &&
          other.id == this.id &&
          other.name == this.name &&
          other.make == this.make &&
          other.model == this.model &&
          other.plate == this.plate &&
          other.year == this.year &&
          other.fuelType == this.fuelType &&
          other.tankCapacity == this.tankCapacity &&
          other.initialOdometer == this.initialOdometer &&
          other.currency == this.currency &&
          other.notes == this.notes &&
          other.externalId == this.externalId &&
          other.isArchived == this.isArchived &&
          other.isFavorite == this.isFavorite &&
          other.createdAt == this.createdAt);
}

class VehiclesCompanion extends UpdateCompanion<Vehicle> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> make;
  final Value<String> model;
  final Value<String> plate;
  final Value<int?> year;
  final Value<String> fuelType;
  final Value<double?> tankCapacity;
  final Value<double> initialOdometer;
  final Value<String> currency;
  final Value<String> notes;
  final Value<String?> externalId;
  final Value<bool> isArchived;
  final Value<bool> isFavorite;
  final Value<DateTime> createdAt;
  const VehiclesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.make = const Value.absent(),
    this.model = const Value.absent(),
    this.plate = const Value.absent(),
    this.year = const Value.absent(),
    this.fuelType = const Value.absent(),
    this.tankCapacity = const Value.absent(),
    this.initialOdometer = const Value.absent(),
    this.currency = const Value.absent(),
    this.notes = const Value.absent(),
    this.externalId = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  VehiclesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.make = const Value.absent(),
    this.model = const Value.absent(),
    this.plate = const Value.absent(),
    this.year = const Value.absent(),
    this.fuelType = const Value.absent(),
    this.tankCapacity = const Value.absent(),
    this.initialOdometer = const Value.absent(),
    this.currency = const Value.absent(),
    this.notes = const Value.absent(),
    this.externalId = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Vehicle> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? make,
    Expression<String>? model,
    Expression<String>? plate,
    Expression<int>? year,
    Expression<String>? fuelType,
    Expression<double>? tankCapacity,
    Expression<double>? initialOdometer,
    Expression<String>? currency,
    Expression<String>? notes,
    Expression<String>? externalId,
    Expression<bool>? isArchived,
    Expression<bool>? isFavorite,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (make != null) 'make': make,
      if (model != null) 'model': model,
      if (plate != null) 'plate': plate,
      if (year != null) 'year': year,
      if (fuelType != null) 'fuel_type': fuelType,
      if (tankCapacity != null) 'tank_capacity': tankCapacity,
      if (initialOdometer != null) 'initial_odometer': initialOdometer,
      if (currency != null) 'currency': currency,
      if (notes != null) 'notes': notes,
      if (externalId != null) 'external_id': externalId,
      if (isArchived != null) 'is_archived': isArchived,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  VehiclesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? make,
    Value<String>? model,
    Value<String>? plate,
    Value<int?>? year,
    Value<String>? fuelType,
    Value<double?>? tankCapacity,
    Value<double>? initialOdometer,
    Value<String>? currency,
    Value<String>? notes,
    Value<String?>? externalId,
    Value<bool>? isArchived,
    Value<bool>? isFavorite,
    Value<DateTime>? createdAt,
  }) {
    return VehiclesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      make: make ?? this.make,
      model: model ?? this.model,
      plate: plate ?? this.plate,
      year: year ?? this.year,
      fuelType: fuelType ?? this.fuelType,
      tankCapacity: tankCapacity ?? this.tankCapacity,
      initialOdometer: initialOdometer ?? this.initialOdometer,
      currency: currency ?? this.currency,
      notes: notes ?? this.notes,
      externalId: externalId ?? this.externalId,
      isArchived: isArchived ?? this.isArchived,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (make.present) {
      map['make'] = Variable<String>(make.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (plate.present) {
      map['plate'] = Variable<String>(plate.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (fuelType.present) {
      map['fuel_type'] = Variable<String>(fuelType.value);
    }
    if (tankCapacity.present) {
      map['tank_capacity'] = Variable<double>(tankCapacity.value);
    }
    if (initialOdometer.present) {
      map['initial_odometer'] = Variable<double>(initialOdometer.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiclesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('make: $make, ')
          ..write('model: $model, ')
          ..write('plate: $plate, ')
          ..write('year: $year, ')
          ..write('fuelType: $fuelType, ')
          ..write('tankCapacity: $tankCapacity, ')
          ..write('initialOdometer: $initialOdometer, ')
          ..write('currency: $currency, ')
          ..write('notes: $notes, ')
          ..write('externalId: $externalId, ')
          ..write('isArchived: $isArchived, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FillUpsTable extends FillUps with TableInfo<$FillUpsTable, FillUp> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FillUpsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<int> vehicleId = GeneratedColumn<int>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _odometerMeta = const VerificationMeta(
    'odometer',
  );
  @override
  late final GeneratedColumn<double> odometer = GeneratedColumn<double>(
    'odometer',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _litersMeta = const VerificationMeta('liters');
  @override
  late final GeneratedColumn<double> liters = GeneratedColumn<double>(
    'liters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pricePerLiterMeta = const VerificationMeta(
    'pricePerLiter',
  );
  @override
  late final GeneratedColumn<double> pricePerLiter = GeneratedColumn<double>(
    'price_per_liter',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalPriceMeta = const VerificationMeta(
    'totalPrice',
  );
  @override
  late final GeneratedColumn<double> totalPrice = GeneratedColumn<double>(
    'total_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isFullMeta = const VerificationMeta('isFull');
  @override
  late final GeneratedColumn<bool> isFull = GeneratedColumn<bool>(
    'is_full',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_full" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isMissedMeta = const VerificationMeta(
    'isMissed',
  );
  @override
  late final GeneratedColumn<bool> isMissed = GeneratedColumn<bool>(
    'is_missed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_missed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _stationNameMeta = const VerificationMeta(
    'stationName',
  );
  @override
  late final GeneratedColumn<String> stationName = GeneratedColumn<String>(
    'station_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _fuelTypeMeta = const VerificationMeta(
    'fuelType',
  );
  @override
  late final GeneratedColumn<String> fuelType = GeneratedColumn<String>(
    'fuel_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tankNumberMeta = const VerificationMeta(
    'tankNumber',
  );
  @override
  late final GeneratedColumn<int> tankNumber = GeneratedColumn<int>(
    'tank_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _excludeDistanceMeta = const VerificationMeta(
    'excludeDistance',
  );
  @override
  late final GeneratedColumn<bool> excludeDistance = GeneratedColumn<bool>(
    'exclude_distance',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("exclude_distance" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _receiptPathMeta = const VerificationMeta(
    'receiptPath',
  );
  @override
  late final GeneratedColumn<String> receiptPath = GeneratedColumn<String>(
    'receipt_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    date,
    odometer,
    liters,
    pricePerLiter,
    totalPrice,
    isFull,
    isMissed,
    stationName,
    latitude,
    longitude,
    note,
    fuelType,
    tankNumber,
    excludeDistance,
    receiptPath,
    externalId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fill_ups';
  @override
  VerificationContext validateIntegrity(
    Insertable<FillUp> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('odometer')) {
      context.handle(
        _odometerMeta,
        odometer.isAcceptableOrUnknown(data['odometer']!, _odometerMeta),
      );
    } else if (isInserting) {
      context.missing(_odometerMeta);
    }
    if (data.containsKey('liters')) {
      context.handle(
        _litersMeta,
        liters.isAcceptableOrUnknown(data['liters']!, _litersMeta),
      );
    } else if (isInserting) {
      context.missing(_litersMeta);
    }
    if (data.containsKey('price_per_liter')) {
      context.handle(
        _pricePerLiterMeta,
        pricePerLiter.isAcceptableOrUnknown(
          data['price_per_liter']!,
          _pricePerLiterMeta,
        ),
      );
    }
    if (data.containsKey('total_price')) {
      context.handle(
        _totalPriceMeta,
        totalPrice.isAcceptableOrUnknown(data['total_price']!, _totalPriceMeta),
      );
    }
    if (data.containsKey('is_full')) {
      context.handle(
        _isFullMeta,
        isFull.isAcceptableOrUnknown(data['is_full']!, _isFullMeta),
      );
    }
    if (data.containsKey('is_missed')) {
      context.handle(
        _isMissedMeta,
        isMissed.isAcceptableOrUnknown(data['is_missed']!, _isMissedMeta),
      );
    }
    if (data.containsKey('station_name')) {
      context.handle(
        _stationNameMeta,
        stationName.isAcceptableOrUnknown(
          data['station_name']!,
          _stationNameMeta,
        ),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('fuel_type')) {
      context.handle(
        _fuelTypeMeta,
        fuelType.isAcceptableOrUnknown(data['fuel_type']!, _fuelTypeMeta),
      );
    }
    if (data.containsKey('tank_number')) {
      context.handle(
        _tankNumberMeta,
        tankNumber.isAcceptableOrUnknown(data['tank_number']!, _tankNumberMeta),
      );
    }
    if (data.containsKey('exclude_distance')) {
      context.handle(
        _excludeDistanceMeta,
        excludeDistance.isAcceptableOrUnknown(
          data['exclude_distance']!,
          _excludeDistanceMeta,
        ),
      );
    }
    if (data.containsKey('receipt_path')) {
      context.handle(
        _receiptPathMeta,
        receiptPath.isAcceptableOrUnknown(
          data['receipt_path']!,
          _receiptPathMeta,
        ),
      );
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FillUp map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FillUp(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vehicle_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      odometer: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}odometer'],
      )!,
      liters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}liters'],
      )!,
      pricePerLiter: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_per_liter'],
      )!,
      totalPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_price'],
      )!,
      isFull: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_full'],
      )!,
      isMissed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_missed'],
      )!,
      stationName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}station_name'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      fuelType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fuel_type'],
      ),
      tankNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tank_number'],
      )!,
      excludeDistance: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}exclude_distance'],
      )!,
      receiptPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_path'],
      ),
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FillUpsTable createAlias(String alias) {
    return $FillUpsTable(attachedDatabase, alias);
  }
}

class FillUp extends DataClass implements Insertable<FillUp> {
  final int id;
  final int vehicleId;
  final DateTime date;
  final double odometer;
  final double liters;
  final double pricePerLiter;
  final double totalPrice;
  final bool isFull;
  final bool isMissed;
  final String stationName;
  final double? latitude;
  final double? longitude;
  final String note;
  final String? fuelType;
  final int tankNumber;
  final bool excludeDistance;
  final String? receiptPath;
  final String? externalId;
  final DateTime createdAt;
  const FillUp({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.odometer,
    required this.liters,
    required this.pricePerLiter,
    required this.totalPrice,
    required this.isFull,
    required this.isMissed,
    required this.stationName,
    this.latitude,
    this.longitude,
    required this.note,
    this.fuelType,
    required this.tankNumber,
    required this.excludeDistance,
    this.receiptPath,
    this.externalId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vehicle_id'] = Variable<int>(vehicleId);
    map['date'] = Variable<DateTime>(date);
    map['odometer'] = Variable<double>(odometer);
    map['liters'] = Variable<double>(liters);
    map['price_per_liter'] = Variable<double>(pricePerLiter);
    map['total_price'] = Variable<double>(totalPrice);
    map['is_full'] = Variable<bool>(isFull);
    map['is_missed'] = Variable<bool>(isMissed);
    map['station_name'] = Variable<String>(stationName);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    map['note'] = Variable<String>(note);
    if (!nullToAbsent || fuelType != null) {
      map['fuel_type'] = Variable<String>(fuelType);
    }
    map['tank_number'] = Variable<int>(tankNumber);
    map['exclude_distance'] = Variable<bool>(excludeDistance);
    if (!nullToAbsent || receiptPath != null) {
      map['receipt_path'] = Variable<String>(receiptPath);
    }
    if (!nullToAbsent || externalId != null) {
      map['external_id'] = Variable<String>(externalId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FillUpsCompanion toCompanion(bool nullToAbsent) {
    return FillUpsCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      date: Value(date),
      odometer: Value(odometer),
      liters: Value(liters),
      pricePerLiter: Value(pricePerLiter),
      totalPrice: Value(totalPrice),
      isFull: Value(isFull),
      isMissed: Value(isMissed),
      stationName: Value(stationName),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      note: Value(note),
      fuelType: fuelType == null && nullToAbsent
          ? const Value.absent()
          : Value(fuelType),
      tankNumber: Value(tankNumber),
      excludeDistance: Value(excludeDistance),
      receiptPath: receiptPath == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptPath),
      externalId: externalId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalId),
      createdAt: Value(createdAt),
    );
  }

  factory FillUp.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FillUp(
      id: serializer.fromJson<int>(json['id']),
      vehicleId: serializer.fromJson<int>(json['vehicleId']),
      date: serializer.fromJson<DateTime>(json['date']),
      odometer: serializer.fromJson<double>(json['odometer']),
      liters: serializer.fromJson<double>(json['liters']),
      pricePerLiter: serializer.fromJson<double>(json['pricePerLiter']),
      totalPrice: serializer.fromJson<double>(json['totalPrice']),
      isFull: serializer.fromJson<bool>(json['isFull']),
      isMissed: serializer.fromJson<bool>(json['isMissed']),
      stationName: serializer.fromJson<String>(json['stationName']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      note: serializer.fromJson<String>(json['note']),
      fuelType: serializer.fromJson<String?>(json['fuelType']),
      tankNumber: serializer.fromJson<int>(json['tankNumber']),
      excludeDistance: serializer.fromJson<bool>(json['excludeDistance']),
      receiptPath: serializer.fromJson<String?>(json['receiptPath']),
      externalId: serializer.fromJson<String?>(json['externalId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vehicleId': serializer.toJson<int>(vehicleId),
      'date': serializer.toJson<DateTime>(date),
      'odometer': serializer.toJson<double>(odometer),
      'liters': serializer.toJson<double>(liters),
      'pricePerLiter': serializer.toJson<double>(pricePerLiter),
      'totalPrice': serializer.toJson<double>(totalPrice),
      'isFull': serializer.toJson<bool>(isFull),
      'isMissed': serializer.toJson<bool>(isMissed),
      'stationName': serializer.toJson<String>(stationName),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'note': serializer.toJson<String>(note),
      'fuelType': serializer.toJson<String?>(fuelType),
      'tankNumber': serializer.toJson<int>(tankNumber),
      'excludeDistance': serializer.toJson<bool>(excludeDistance),
      'receiptPath': serializer.toJson<String?>(receiptPath),
      'externalId': serializer.toJson<String?>(externalId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FillUp copyWith({
    int? id,
    int? vehicleId,
    DateTime? date,
    double? odometer,
    double? liters,
    double? pricePerLiter,
    double? totalPrice,
    bool? isFull,
    bool? isMissed,
    String? stationName,
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    String? note,
    Value<String?> fuelType = const Value.absent(),
    int? tankNumber,
    bool? excludeDistance,
    Value<String?> receiptPath = const Value.absent(),
    Value<String?> externalId = const Value.absent(),
    DateTime? createdAt,
  }) => FillUp(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    date: date ?? this.date,
    odometer: odometer ?? this.odometer,
    liters: liters ?? this.liters,
    pricePerLiter: pricePerLiter ?? this.pricePerLiter,
    totalPrice: totalPrice ?? this.totalPrice,
    isFull: isFull ?? this.isFull,
    isMissed: isMissed ?? this.isMissed,
    stationName: stationName ?? this.stationName,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    note: note ?? this.note,
    fuelType: fuelType.present ? fuelType.value : this.fuelType,
    tankNumber: tankNumber ?? this.tankNumber,
    excludeDistance: excludeDistance ?? this.excludeDistance,
    receiptPath: receiptPath.present ? receiptPath.value : this.receiptPath,
    externalId: externalId.present ? externalId.value : this.externalId,
    createdAt: createdAt ?? this.createdAt,
  );
  FillUp copyWithCompanion(FillUpsCompanion data) {
    return FillUp(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      date: data.date.present ? data.date.value : this.date,
      odometer: data.odometer.present ? data.odometer.value : this.odometer,
      liters: data.liters.present ? data.liters.value : this.liters,
      pricePerLiter: data.pricePerLiter.present
          ? data.pricePerLiter.value
          : this.pricePerLiter,
      totalPrice: data.totalPrice.present
          ? data.totalPrice.value
          : this.totalPrice,
      isFull: data.isFull.present ? data.isFull.value : this.isFull,
      isMissed: data.isMissed.present ? data.isMissed.value : this.isMissed,
      stationName: data.stationName.present
          ? data.stationName.value
          : this.stationName,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      note: data.note.present ? data.note.value : this.note,
      fuelType: data.fuelType.present ? data.fuelType.value : this.fuelType,
      tankNumber: data.tankNumber.present
          ? data.tankNumber.value
          : this.tankNumber,
      excludeDistance: data.excludeDistance.present
          ? data.excludeDistance.value
          : this.excludeDistance,
      receiptPath: data.receiptPath.present
          ? data.receiptPath.value
          : this.receiptPath,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FillUp(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('date: $date, ')
          ..write('odometer: $odometer, ')
          ..write('liters: $liters, ')
          ..write('pricePerLiter: $pricePerLiter, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('isFull: $isFull, ')
          ..write('isMissed: $isMissed, ')
          ..write('stationName: $stationName, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('note: $note, ')
          ..write('fuelType: $fuelType, ')
          ..write('tankNumber: $tankNumber, ')
          ..write('excludeDistance: $excludeDistance, ')
          ..write('receiptPath: $receiptPath, ')
          ..write('externalId: $externalId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    date,
    odometer,
    liters,
    pricePerLiter,
    totalPrice,
    isFull,
    isMissed,
    stationName,
    latitude,
    longitude,
    note,
    fuelType,
    tankNumber,
    excludeDistance,
    receiptPath,
    externalId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FillUp &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.date == this.date &&
          other.odometer == this.odometer &&
          other.liters == this.liters &&
          other.pricePerLiter == this.pricePerLiter &&
          other.totalPrice == this.totalPrice &&
          other.isFull == this.isFull &&
          other.isMissed == this.isMissed &&
          other.stationName == this.stationName &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.note == this.note &&
          other.fuelType == this.fuelType &&
          other.tankNumber == this.tankNumber &&
          other.excludeDistance == this.excludeDistance &&
          other.receiptPath == this.receiptPath &&
          other.externalId == this.externalId &&
          other.createdAt == this.createdAt);
}

class FillUpsCompanion extends UpdateCompanion<FillUp> {
  final Value<int> id;
  final Value<int> vehicleId;
  final Value<DateTime> date;
  final Value<double> odometer;
  final Value<double> liters;
  final Value<double> pricePerLiter;
  final Value<double> totalPrice;
  final Value<bool> isFull;
  final Value<bool> isMissed;
  final Value<String> stationName;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String> note;
  final Value<String?> fuelType;
  final Value<int> tankNumber;
  final Value<bool> excludeDistance;
  final Value<String?> receiptPath;
  final Value<String?> externalId;
  final Value<DateTime> createdAt;
  const FillUpsCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.date = const Value.absent(),
    this.odometer = const Value.absent(),
    this.liters = const Value.absent(),
    this.pricePerLiter = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.isFull = const Value.absent(),
    this.isMissed = const Value.absent(),
    this.stationName = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.note = const Value.absent(),
    this.fuelType = const Value.absent(),
    this.tankNumber = const Value.absent(),
    this.excludeDistance = const Value.absent(),
    this.receiptPath = const Value.absent(),
    this.externalId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FillUpsCompanion.insert({
    this.id = const Value.absent(),
    required int vehicleId,
    required DateTime date,
    required double odometer,
    required double liters,
    this.pricePerLiter = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.isFull = const Value.absent(),
    this.isMissed = const Value.absent(),
    this.stationName = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.note = const Value.absent(),
    this.fuelType = const Value.absent(),
    this.tankNumber = const Value.absent(),
    this.excludeDistance = const Value.absent(),
    this.receiptPath = const Value.absent(),
    this.externalId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : vehicleId = Value(vehicleId),
       date = Value(date),
       odometer = Value(odometer),
       liters = Value(liters);
  static Insertable<FillUp> custom({
    Expression<int>? id,
    Expression<int>? vehicleId,
    Expression<DateTime>? date,
    Expression<double>? odometer,
    Expression<double>? liters,
    Expression<double>? pricePerLiter,
    Expression<double>? totalPrice,
    Expression<bool>? isFull,
    Expression<bool>? isMissed,
    Expression<String>? stationName,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? note,
    Expression<String>? fuelType,
    Expression<int>? tankNumber,
    Expression<bool>? excludeDistance,
    Expression<String>? receiptPath,
    Expression<String>? externalId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (date != null) 'date': date,
      if (odometer != null) 'odometer': odometer,
      if (liters != null) 'liters': liters,
      if (pricePerLiter != null) 'price_per_liter': pricePerLiter,
      if (totalPrice != null) 'total_price': totalPrice,
      if (isFull != null) 'is_full': isFull,
      if (isMissed != null) 'is_missed': isMissed,
      if (stationName != null) 'station_name': stationName,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (note != null) 'note': note,
      if (fuelType != null) 'fuel_type': fuelType,
      if (tankNumber != null) 'tank_number': tankNumber,
      if (excludeDistance != null) 'exclude_distance': excludeDistance,
      if (receiptPath != null) 'receipt_path': receiptPath,
      if (externalId != null) 'external_id': externalId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FillUpsCompanion copyWith({
    Value<int>? id,
    Value<int>? vehicleId,
    Value<DateTime>? date,
    Value<double>? odometer,
    Value<double>? liters,
    Value<double>? pricePerLiter,
    Value<double>? totalPrice,
    Value<bool>? isFull,
    Value<bool>? isMissed,
    Value<String>? stationName,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<String>? note,
    Value<String?>? fuelType,
    Value<int>? tankNumber,
    Value<bool>? excludeDistance,
    Value<String?>? receiptPath,
    Value<String?>? externalId,
    Value<DateTime>? createdAt,
  }) {
    return FillUpsCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      date: date ?? this.date,
      odometer: odometer ?? this.odometer,
      liters: liters ?? this.liters,
      pricePerLiter: pricePerLiter ?? this.pricePerLiter,
      totalPrice: totalPrice ?? this.totalPrice,
      isFull: isFull ?? this.isFull,
      isMissed: isMissed ?? this.isMissed,
      stationName: stationName ?? this.stationName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      note: note ?? this.note,
      fuelType: fuelType ?? this.fuelType,
      tankNumber: tankNumber ?? this.tankNumber,
      excludeDistance: excludeDistance ?? this.excludeDistance,
      receiptPath: receiptPath ?? this.receiptPath,
      externalId: externalId ?? this.externalId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<int>(vehicleId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (odometer.present) {
      map['odometer'] = Variable<double>(odometer.value);
    }
    if (liters.present) {
      map['liters'] = Variable<double>(liters.value);
    }
    if (pricePerLiter.present) {
      map['price_per_liter'] = Variable<double>(pricePerLiter.value);
    }
    if (totalPrice.present) {
      map['total_price'] = Variable<double>(totalPrice.value);
    }
    if (isFull.present) {
      map['is_full'] = Variable<bool>(isFull.value);
    }
    if (isMissed.present) {
      map['is_missed'] = Variable<bool>(isMissed.value);
    }
    if (stationName.present) {
      map['station_name'] = Variable<String>(stationName.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (fuelType.present) {
      map['fuel_type'] = Variable<String>(fuelType.value);
    }
    if (tankNumber.present) {
      map['tank_number'] = Variable<int>(tankNumber.value);
    }
    if (excludeDistance.present) {
      map['exclude_distance'] = Variable<bool>(excludeDistance.value);
    }
    if (receiptPath.present) {
      map['receipt_path'] = Variable<String>(receiptPath.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FillUpsCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('date: $date, ')
          ..write('odometer: $odometer, ')
          ..write('liters: $liters, ')
          ..write('pricePerLiter: $pricePerLiter, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('isFull: $isFull, ')
          ..write('isMissed: $isMissed, ')
          ..write('stationName: $stationName, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('note: $note, ')
          ..write('fuelType: $fuelType, ')
          ..write('tankNumber: $tankNumber, ')
          ..write('excludeDistance: $excludeDistance, ')
          ..write('receiptPath: $receiptPath, ')
          ..write('externalId: $externalId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<int> vehicleId = GeneratedColumn<int>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _odometerMeta = const VerificationMeta(
    'odometer',
  );
  @override
  late final GeneratedColumn<double> odometer = GeneratedColumn<double>(
    'odometer',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryKeyMeta = const VerificationMeta(
    'categoryKey',
  );
  @override
  late final GeneratedColumn<String> categoryKey = GeneratedColumn<String>(
    'category_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('other'),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isIncomeMeta = const VerificationMeta(
    'isIncome',
  );
  @override
  late final GeneratedColumn<bool> isIncome = GeneratedColumn<bool>(
    'is_income',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_income" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _receiptPathMeta = const VerificationMeta(
    'receiptPath',
  );
  @override
  late final GeneratedColumn<String> receiptPath = GeneratedColumn<String>(
    'receipt_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    title,
    date,
    odometer,
    categoryKey,
    amount,
    note,
    isIncome,
    receiptPath,
    externalId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Expense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('odometer')) {
      context.handle(
        _odometerMeta,
        odometer.isAcceptableOrUnknown(data['odometer']!, _odometerMeta),
      );
    }
    if (data.containsKey('category_key')) {
      context.handle(
        _categoryKeyMeta,
        categoryKey.isAcceptableOrUnknown(
          data['category_key']!,
          _categoryKeyMeta,
        ),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('is_income')) {
      context.handle(
        _isIncomeMeta,
        isIncome.isAcceptableOrUnknown(data['is_income']!, _isIncomeMeta),
      );
    }
    if (data.containsKey('receipt_path')) {
      context.handle(
        _receiptPathMeta,
        receiptPath.isAcceptableOrUnknown(
          data['receipt_path']!,
          _receiptPathMeta,
        ),
      );
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vehicle_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      odometer: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}odometer'],
      ),
      categoryKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_key'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      isIncome: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_income'],
      )!,
      receiptPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_path'],
      ),
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final int vehicleId;
  final String title;
  final DateTime date;
  final double? odometer;
  final String categoryKey;
  final double amount;
  final String note;
  final bool isIncome;
  final String? receiptPath;
  final String? externalId;
  final DateTime createdAt;
  const Expense({
    required this.id,
    required this.vehicleId,
    required this.title,
    required this.date,
    this.odometer,
    required this.categoryKey,
    required this.amount,
    required this.note,
    required this.isIncome,
    this.receiptPath,
    this.externalId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vehicle_id'] = Variable<int>(vehicleId);
    map['title'] = Variable<String>(title);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || odometer != null) {
      map['odometer'] = Variable<double>(odometer);
    }
    map['category_key'] = Variable<String>(categoryKey);
    map['amount'] = Variable<double>(amount);
    map['note'] = Variable<String>(note);
    map['is_income'] = Variable<bool>(isIncome);
    if (!nullToAbsent || receiptPath != null) {
      map['receipt_path'] = Variable<String>(receiptPath);
    }
    if (!nullToAbsent || externalId != null) {
      map['external_id'] = Variable<String>(externalId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      title: Value(title),
      date: Value(date),
      odometer: odometer == null && nullToAbsent
          ? const Value.absent()
          : Value(odometer),
      categoryKey: Value(categoryKey),
      amount: Value(amount),
      note: Value(note),
      isIncome: Value(isIncome),
      receiptPath: receiptPath == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptPath),
      externalId: externalId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalId),
      createdAt: Value(createdAt),
    );
  }

  factory Expense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      vehicleId: serializer.fromJson<int>(json['vehicleId']),
      title: serializer.fromJson<String>(json['title']),
      date: serializer.fromJson<DateTime>(json['date']),
      odometer: serializer.fromJson<double?>(json['odometer']),
      categoryKey: serializer.fromJson<String>(json['categoryKey']),
      amount: serializer.fromJson<double>(json['amount']),
      note: serializer.fromJson<String>(json['note']),
      isIncome: serializer.fromJson<bool>(json['isIncome']),
      receiptPath: serializer.fromJson<String?>(json['receiptPath']),
      externalId: serializer.fromJson<String?>(json['externalId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vehicleId': serializer.toJson<int>(vehicleId),
      'title': serializer.toJson<String>(title),
      'date': serializer.toJson<DateTime>(date),
      'odometer': serializer.toJson<double?>(odometer),
      'categoryKey': serializer.toJson<String>(categoryKey),
      'amount': serializer.toJson<double>(amount),
      'note': serializer.toJson<String>(note),
      'isIncome': serializer.toJson<bool>(isIncome),
      'receiptPath': serializer.toJson<String?>(receiptPath),
      'externalId': serializer.toJson<String?>(externalId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Expense copyWith({
    int? id,
    int? vehicleId,
    String? title,
    DateTime? date,
    Value<double?> odometer = const Value.absent(),
    String? categoryKey,
    double? amount,
    String? note,
    bool? isIncome,
    Value<String?> receiptPath = const Value.absent(),
    Value<String?> externalId = const Value.absent(),
    DateTime? createdAt,
  }) => Expense(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    title: title ?? this.title,
    date: date ?? this.date,
    odometer: odometer.present ? odometer.value : this.odometer,
    categoryKey: categoryKey ?? this.categoryKey,
    amount: amount ?? this.amount,
    note: note ?? this.note,
    isIncome: isIncome ?? this.isIncome,
    receiptPath: receiptPath.present ? receiptPath.value : this.receiptPath,
    externalId: externalId.present ? externalId.value : this.externalId,
    createdAt: createdAt ?? this.createdAt,
  );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      title: data.title.present ? data.title.value : this.title,
      date: data.date.present ? data.date.value : this.date,
      odometer: data.odometer.present ? data.odometer.value : this.odometer,
      categoryKey: data.categoryKey.present
          ? data.categoryKey.value
          : this.categoryKey,
      amount: data.amount.present ? data.amount.value : this.amount,
      note: data.note.present ? data.note.value : this.note,
      isIncome: data.isIncome.present ? data.isIncome.value : this.isIncome,
      receiptPath: data.receiptPath.present
          ? data.receiptPath.value
          : this.receiptPath,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('title: $title, ')
          ..write('date: $date, ')
          ..write('odometer: $odometer, ')
          ..write('categoryKey: $categoryKey, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('isIncome: $isIncome, ')
          ..write('receiptPath: $receiptPath, ')
          ..write('externalId: $externalId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    title,
    date,
    odometer,
    categoryKey,
    amount,
    note,
    isIncome,
    receiptPath,
    externalId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.title == this.title &&
          other.date == this.date &&
          other.odometer == this.odometer &&
          other.categoryKey == this.categoryKey &&
          other.amount == this.amount &&
          other.note == this.note &&
          other.isIncome == this.isIncome &&
          other.receiptPath == this.receiptPath &&
          other.externalId == this.externalId &&
          other.createdAt == this.createdAt);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<int> vehicleId;
  final Value<String> title;
  final Value<DateTime> date;
  final Value<double?> odometer;
  final Value<String> categoryKey;
  final Value<double> amount;
  final Value<String> note;
  final Value<bool> isIncome;
  final Value<String?> receiptPath;
  final Value<String?> externalId;
  final Value<DateTime> createdAt;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.title = const Value.absent(),
    this.date = const Value.absent(),
    this.odometer = const Value.absent(),
    this.categoryKey = const Value.absent(),
    this.amount = const Value.absent(),
    this.note = const Value.absent(),
    this.isIncome = const Value.absent(),
    this.receiptPath = const Value.absent(),
    this.externalId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required int vehicleId,
    required String title,
    required DateTime date,
    this.odometer = const Value.absent(),
    this.categoryKey = const Value.absent(),
    this.amount = const Value.absent(),
    this.note = const Value.absent(),
    this.isIncome = const Value.absent(),
    this.receiptPath = const Value.absent(),
    this.externalId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : vehicleId = Value(vehicleId),
       title = Value(title),
       date = Value(date);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<int>? vehicleId,
    Expression<String>? title,
    Expression<DateTime>? date,
    Expression<double>? odometer,
    Expression<String>? categoryKey,
    Expression<double>? amount,
    Expression<String>? note,
    Expression<bool>? isIncome,
    Expression<String>? receiptPath,
    Expression<String>? externalId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (title != null) 'title': title,
      if (date != null) 'date': date,
      if (odometer != null) 'odometer': odometer,
      if (categoryKey != null) 'category_key': categoryKey,
      if (amount != null) 'amount': amount,
      if (note != null) 'note': note,
      if (isIncome != null) 'is_income': isIncome,
      if (receiptPath != null) 'receipt_path': receiptPath,
      if (externalId != null) 'external_id': externalId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ExpensesCompanion copyWith({
    Value<int>? id,
    Value<int>? vehicleId,
    Value<String>? title,
    Value<DateTime>? date,
    Value<double?>? odometer,
    Value<String>? categoryKey,
    Value<double>? amount,
    Value<String>? note,
    Value<bool>? isIncome,
    Value<String?>? receiptPath,
    Value<String?>? externalId,
    Value<DateTime>? createdAt,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      title: title ?? this.title,
      date: date ?? this.date,
      odometer: odometer ?? this.odometer,
      categoryKey: categoryKey ?? this.categoryKey,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      isIncome: isIncome ?? this.isIncome,
      receiptPath: receiptPath ?? this.receiptPath,
      externalId: externalId ?? this.externalId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<int>(vehicleId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (odometer.present) {
      map['odometer'] = Variable<double>(odometer.value);
    }
    if (categoryKey.present) {
      map['category_key'] = Variable<String>(categoryKey.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isIncome.present) {
      map['is_income'] = Variable<bool>(isIncome.value);
    }
    if (receiptPath.present) {
      map['receipt_path'] = Variable<String>(receiptPath.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('title: $title, ')
          ..write('date: $date, ')
          ..write('odometer: $odometer, ')
          ..write('categoryKey: $categoryKey, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('isIncome: $isIncome, ')
          ..write('receiptPath: $receiptPath, ')
          ..write('externalId: $externalId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ExpenseCategoriesTable extends ExpenseCategories
    with TableInfo<$ExpenseCategoriesTable, ExpenseCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFF607D8B),
  );
  static const VerificationMeta _isBuiltinMeta = const VerificationMeta(
    'isBuiltin',
  );
  @override
  late final GeneratedColumn<bool> isBuiltin = GeneratedColumn<bool>(
    'is_builtin',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_builtin" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, key, label, color, isBuiltin];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('is_builtin')) {
      context.handle(
        _isBuiltinMeta,
        isBuiltin.isAcceptableOrUnknown(data['is_builtin']!, _isBuiltinMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      isBuiltin: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_builtin'],
      )!,
    );
  }

  @override
  $ExpenseCategoriesTable createAlias(String alias) {
    return $ExpenseCategoriesTable(attachedDatabase, alias);
  }
}

class ExpenseCategory extends DataClass implements Insertable<ExpenseCategory> {
  final int id;
  final String key;
  final String label;
  final int color;
  final bool isBuiltin;
  const ExpenseCategory({
    required this.id,
    required this.key,
    required this.label,
    required this.color,
    required this.isBuiltin,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    map['label'] = Variable<String>(label);
    map['color'] = Variable<int>(color);
    map['is_builtin'] = Variable<bool>(isBuiltin);
    return map;
  }

  ExpenseCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ExpenseCategoriesCompanion(
      id: Value(id),
      key: Value(key),
      label: Value(label),
      color: Value(color),
      isBuiltin: Value(isBuiltin),
    );
  }

  factory ExpenseCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseCategory(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      label: serializer.fromJson<String>(json['label']),
      color: serializer.fromJson<int>(json['color']),
      isBuiltin: serializer.fromJson<bool>(json['isBuiltin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'label': serializer.toJson<String>(label),
      'color': serializer.toJson<int>(color),
      'isBuiltin': serializer.toJson<bool>(isBuiltin),
    };
  }

  ExpenseCategory copyWith({
    int? id,
    String? key,
    String? label,
    int? color,
    bool? isBuiltin,
  }) => ExpenseCategory(
    id: id ?? this.id,
    key: key ?? this.key,
    label: label ?? this.label,
    color: color ?? this.color,
    isBuiltin: isBuiltin ?? this.isBuiltin,
  );
  ExpenseCategory copyWithCompanion(ExpenseCategoriesCompanion data) {
    return ExpenseCategory(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      label: data.label.present ? data.label.value : this.label,
      color: data.color.present ? data.color.value : this.color,
      isBuiltin: data.isBuiltin.present ? data.isBuiltin.value : this.isBuiltin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategory(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('label: $label, ')
          ..write('color: $color, ')
          ..write('isBuiltin: $isBuiltin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, label, color, isBuiltin);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseCategory &&
          other.id == this.id &&
          other.key == this.key &&
          other.label == this.label &&
          other.color == this.color &&
          other.isBuiltin == this.isBuiltin);
}

class ExpenseCategoriesCompanion extends UpdateCompanion<ExpenseCategory> {
  final Value<int> id;
  final Value<String> key;
  final Value<String> label;
  final Value<int> color;
  final Value<bool> isBuiltin;
  const ExpenseCategoriesCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.label = const Value.absent(),
    this.color = const Value.absent(),
    this.isBuiltin = const Value.absent(),
  });
  ExpenseCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    required String label,
    this.color = const Value.absent(),
    this.isBuiltin = const Value.absent(),
  }) : key = Value(key),
       label = Value(label);
  static Insertable<ExpenseCategory> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? label,
    Expression<int>? color,
    Expression<bool>? isBuiltin,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (label != null) 'label': label,
      if (color != null) 'color': color,
      if (isBuiltin != null) 'is_builtin': isBuiltin,
    });
  }

  ExpenseCategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? key,
    Value<String>? label,
    Value<int>? color,
    Value<bool>? isBuiltin,
  }) {
    return ExpenseCategoriesCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      label: label ?? this.label,
      color: color ?? this.color,
      isBuiltin: isBuiltin ?? this.isBuiltin,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (isBuiltin.present) {
      map['is_builtin'] = Variable<bool>(isBuiltin.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('label: $label, ')
          ..write('color: $color, ')
          ..write('isBuiltin: $isBuiltin')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<int> vehicleId = GeneratedColumn<int>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryKeyMeta = const VerificationMeta(
    'categoryKey',
  );
  @override
  late final GeneratedColumn<String> categoryKey = GeneratedColumn<String>(
    'category_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('service'),
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueOdometerMeta = const VerificationMeta(
    'dueOdometer',
  );
  @override
  late final GeneratedColumn<double> dueOdometer = GeneratedColumn<double>(
    'due_odometer',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repeatMonthsMeta = const VerificationMeta(
    'repeatMonths',
  );
  @override
  late final GeneratedColumn<int> repeatMonths = GeneratedColumn<int>(
    'repeat_months',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repeatKmMeta = const VerificationMeta(
    'repeatKm',
  );
  @override
  late final GeneratedColumn<double> repeatKm = GeneratedColumn<double>(
    'repeat_km',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _advanceDaysMeta = const VerificationMeta(
    'advanceDays',
  );
  @override
  late final GeneratedColumn<int> advanceDays = GeneratedColumn<int>(
    'advance_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(14),
  );
  static const VerificationMeta _advanceKmMeta = const VerificationMeta(
    'advanceKm',
  );
  @override
  late final GeneratedColumn<double> advanceKm = GeneratedColumn<double>(
    'advance_km',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(500),
  );
  static const VerificationMeta _lastDoneDateMeta = const VerificationMeta(
    'lastDoneDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastDoneDate = GeneratedColumn<DateTime>(
    'last_done_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastDoneOdometerMeta = const VerificationMeta(
    'lastDoneOdometer',
  );
  @override
  late final GeneratedColumn<double> lastDoneOdometer = GeneratedColumn<double>(
    'last_done_odometer',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    title,
    categoryKey,
    dueDate,
    dueOdometer,
    repeatMonths,
    repeatKm,
    advanceDays,
    advanceKm,
    lastDoneDate,
    lastDoneOdometer,
    note,
    isActive,
    externalId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('category_key')) {
      context.handle(
        _categoryKeyMeta,
        categoryKey.isAcceptableOrUnknown(
          data['category_key']!,
          _categoryKeyMeta,
        ),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('due_odometer')) {
      context.handle(
        _dueOdometerMeta,
        dueOdometer.isAcceptableOrUnknown(
          data['due_odometer']!,
          _dueOdometerMeta,
        ),
      );
    }
    if (data.containsKey('repeat_months')) {
      context.handle(
        _repeatMonthsMeta,
        repeatMonths.isAcceptableOrUnknown(
          data['repeat_months']!,
          _repeatMonthsMeta,
        ),
      );
    }
    if (data.containsKey('repeat_km')) {
      context.handle(
        _repeatKmMeta,
        repeatKm.isAcceptableOrUnknown(data['repeat_km']!, _repeatKmMeta),
      );
    }
    if (data.containsKey('advance_days')) {
      context.handle(
        _advanceDaysMeta,
        advanceDays.isAcceptableOrUnknown(
          data['advance_days']!,
          _advanceDaysMeta,
        ),
      );
    }
    if (data.containsKey('advance_km')) {
      context.handle(
        _advanceKmMeta,
        advanceKm.isAcceptableOrUnknown(data['advance_km']!, _advanceKmMeta),
      );
    }
    if (data.containsKey('last_done_date')) {
      context.handle(
        _lastDoneDateMeta,
        lastDoneDate.isAcceptableOrUnknown(
          data['last_done_date']!,
          _lastDoneDateMeta,
        ),
      );
    }
    if (data.containsKey('last_done_odometer')) {
      context.handle(
        _lastDoneOdometerMeta,
        lastDoneOdometer.isAcceptableOrUnknown(
          data['last_done_odometer']!,
          _lastDoneOdometerMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vehicle_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      categoryKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_key'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      dueOdometer: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}due_odometer'],
      ),
      repeatMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repeat_months'],
      ),
      repeatKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}repeat_km'],
      ),
      advanceDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}advance_days'],
      )!,
      advanceKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}advance_km'],
      )!,
      lastDoneDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_done_date'],
      ),
      lastDoneOdometer: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}last_done_odometer'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final int id;
  final int vehicleId;
  final String title;
  final String categoryKey;
  final DateTime? dueDate;
  final double? dueOdometer;
  final int? repeatMonths;
  final double? repeatKm;
  final int advanceDays;
  final double advanceKm;
  final DateTime? lastDoneDate;
  final double? lastDoneOdometer;
  final String note;
  final bool isActive;
  final String? externalId;
  final DateTime createdAt;
  const Reminder({
    required this.id,
    required this.vehicleId,
    required this.title,
    required this.categoryKey,
    this.dueDate,
    this.dueOdometer,
    this.repeatMonths,
    this.repeatKm,
    required this.advanceDays,
    required this.advanceKm,
    this.lastDoneDate,
    this.lastDoneOdometer,
    required this.note,
    required this.isActive,
    this.externalId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vehicle_id'] = Variable<int>(vehicleId);
    map['title'] = Variable<String>(title);
    map['category_key'] = Variable<String>(categoryKey);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    if (!nullToAbsent || dueOdometer != null) {
      map['due_odometer'] = Variable<double>(dueOdometer);
    }
    if (!nullToAbsent || repeatMonths != null) {
      map['repeat_months'] = Variable<int>(repeatMonths);
    }
    if (!nullToAbsent || repeatKm != null) {
      map['repeat_km'] = Variable<double>(repeatKm);
    }
    map['advance_days'] = Variable<int>(advanceDays);
    map['advance_km'] = Variable<double>(advanceKm);
    if (!nullToAbsent || lastDoneDate != null) {
      map['last_done_date'] = Variable<DateTime>(lastDoneDate);
    }
    if (!nullToAbsent || lastDoneOdometer != null) {
      map['last_done_odometer'] = Variable<double>(lastDoneOdometer);
    }
    map['note'] = Variable<String>(note);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || externalId != null) {
      map['external_id'] = Variable<String>(externalId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      title: Value(title),
      categoryKey: Value(categoryKey),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      dueOdometer: dueOdometer == null && nullToAbsent
          ? const Value.absent()
          : Value(dueOdometer),
      repeatMonths: repeatMonths == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatMonths),
      repeatKm: repeatKm == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatKm),
      advanceDays: Value(advanceDays),
      advanceKm: Value(advanceKm),
      lastDoneDate: lastDoneDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastDoneDate),
      lastDoneOdometer: lastDoneOdometer == null && nullToAbsent
          ? const Value.absent()
          : Value(lastDoneOdometer),
      note: Value(note),
      isActive: Value(isActive),
      externalId: externalId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalId),
      createdAt: Value(createdAt),
    );
  }

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<int>(json['id']),
      vehicleId: serializer.fromJson<int>(json['vehicleId']),
      title: serializer.fromJson<String>(json['title']),
      categoryKey: serializer.fromJson<String>(json['categoryKey']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      dueOdometer: serializer.fromJson<double?>(json['dueOdometer']),
      repeatMonths: serializer.fromJson<int?>(json['repeatMonths']),
      repeatKm: serializer.fromJson<double?>(json['repeatKm']),
      advanceDays: serializer.fromJson<int>(json['advanceDays']),
      advanceKm: serializer.fromJson<double>(json['advanceKm']),
      lastDoneDate: serializer.fromJson<DateTime?>(json['lastDoneDate']),
      lastDoneOdometer: serializer.fromJson<double?>(json['lastDoneOdometer']),
      note: serializer.fromJson<String>(json['note']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      externalId: serializer.fromJson<String?>(json['externalId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vehicleId': serializer.toJson<int>(vehicleId),
      'title': serializer.toJson<String>(title),
      'categoryKey': serializer.toJson<String>(categoryKey),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'dueOdometer': serializer.toJson<double?>(dueOdometer),
      'repeatMonths': serializer.toJson<int?>(repeatMonths),
      'repeatKm': serializer.toJson<double?>(repeatKm),
      'advanceDays': serializer.toJson<int>(advanceDays),
      'advanceKm': serializer.toJson<double>(advanceKm),
      'lastDoneDate': serializer.toJson<DateTime?>(lastDoneDate),
      'lastDoneOdometer': serializer.toJson<double?>(lastDoneOdometer),
      'note': serializer.toJson<String>(note),
      'isActive': serializer.toJson<bool>(isActive),
      'externalId': serializer.toJson<String?>(externalId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Reminder copyWith({
    int? id,
    int? vehicleId,
    String? title,
    String? categoryKey,
    Value<DateTime?> dueDate = const Value.absent(),
    Value<double?> dueOdometer = const Value.absent(),
    Value<int?> repeatMonths = const Value.absent(),
    Value<double?> repeatKm = const Value.absent(),
    int? advanceDays,
    double? advanceKm,
    Value<DateTime?> lastDoneDate = const Value.absent(),
    Value<double?> lastDoneOdometer = const Value.absent(),
    String? note,
    bool? isActive,
    Value<String?> externalId = const Value.absent(),
    DateTime? createdAt,
  }) => Reminder(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    title: title ?? this.title,
    categoryKey: categoryKey ?? this.categoryKey,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    dueOdometer: dueOdometer.present ? dueOdometer.value : this.dueOdometer,
    repeatMonths: repeatMonths.present ? repeatMonths.value : this.repeatMonths,
    repeatKm: repeatKm.present ? repeatKm.value : this.repeatKm,
    advanceDays: advanceDays ?? this.advanceDays,
    advanceKm: advanceKm ?? this.advanceKm,
    lastDoneDate: lastDoneDate.present ? lastDoneDate.value : this.lastDoneDate,
    lastDoneOdometer: lastDoneOdometer.present
        ? lastDoneOdometer.value
        : this.lastDoneOdometer,
    note: note ?? this.note,
    isActive: isActive ?? this.isActive,
    externalId: externalId.present ? externalId.value : this.externalId,
    createdAt: createdAt ?? this.createdAt,
  );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      title: data.title.present ? data.title.value : this.title,
      categoryKey: data.categoryKey.present
          ? data.categoryKey.value
          : this.categoryKey,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      dueOdometer: data.dueOdometer.present
          ? data.dueOdometer.value
          : this.dueOdometer,
      repeatMonths: data.repeatMonths.present
          ? data.repeatMonths.value
          : this.repeatMonths,
      repeatKm: data.repeatKm.present ? data.repeatKm.value : this.repeatKm,
      advanceDays: data.advanceDays.present
          ? data.advanceDays.value
          : this.advanceDays,
      advanceKm: data.advanceKm.present ? data.advanceKm.value : this.advanceKm,
      lastDoneDate: data.lastDoneDate.present
          ? data.lastDoneDate.value
          : this.lastDoneDate,
      lastDoneOdometer: data.lastDoneOdometer.present
          ? data.lastDoneOdometer.value
          : this.lastDoneOdometer,
      note: data.note.present ? data.note.value : this.note,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('title: $title, ')
          ..write('categoryKey: $categoryKey, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueOdometer: $dueOdometer, ')
          ..write('repeatMonths: $repeatMonths, ')
          ..write('repeatKm: $repeatKm, ')
          ..write('advanceDays: $advanceDays, ')
          ..write('advanceKm: $advanceKm, ')
          ..write('lastDoneDate: $lastDoneDate, ')
          ..write('lastDoneOdometer: $lastDoneOdometer, ')
          ..write('note: $note, ')
          ..write('isActive: $isActive, ')
          ..write('externalId: $externalId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    title,
    categoryKey,
    dueDate,
    dueOdometer,
    repeatMonths,
    repeatKm,
    advanceDays,
    advanceKm,
    lastDoneDate,
    lastDoneOdometer,
    note,
    isActive,
    externalId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.title == this.title &&
          other.categoryKey == this.categoryKey &&
          other.dueDate == this.dueDate &&
          other.dueOdometer == this.dueOdometer &&
          other.repeatMonths == this.repeatMonths &&
          other.repeatKm == this.repeatKm &&
          other.advanceDays == this.advanceDays &&
          other.advanceKm == this.advanceKm &&
          other.lastDoneDate == this.lastDoneDate &&
          other.lastDoneOdometer == this.lastDoneOdometer &&
          other.note == this.note &&
          other.isActive == this.isActive &&
          other.externalId == this.externalId &&
          other.createdAt == this.createdAt);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<int> id;
  final Value<int> vehicleId;
  final Value<String> title;
  final Value<String> categoryKey;
  final Value<DateTime?> dueDate;
  final Value<double?> dueOdometer;
  final Value<int?> repeatMonths;
  final Value<double?> repeatKm;
  final Value<int> advanceDays;
  final Value<double> advanceKm;
  final Value<DateTime?> lastDoneDate;
  final Value<double?> lastDoneOdometer;
  final Value<String> note;
  final Value<bool> isActive;
  final Value<String?> externalId;
  final Value<DateTime> createdAt;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.title = const Value.absent(),
    this.categoryKey = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueOdometer = const Value.absent(),
    this.repeatMonths = const Value.absent(),
    this.repeatKm = const Value.absent(),
    this.advanceDays = const Value.absent(),
    this.advanceKm = const Value.absent(),
    this.lastDoneDate = const Value.absent(),
    this.lastDoneOdometer = const Value.absent(),
    this.note = const Value.absent(),
    this.isActive = const Value.absent(),
    this.externalId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RemindersCompanion.insert({
    this.id = const Value.absent(),
    required int vehicleId,
    required String title,
    this.categoryKey = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueOdometer = const Value.absent(),
    this.repeatMonths = const Value.absent(),
    this.repeatKm = const Value.absent(),
    this.advanceDays = const Value.absent(),
    this.advanceKm = const Value.absent(),
    this.lastDoneDate = const Value.absent(),
    this.lastDoneOdometer = const Value.absent(),
    this.note = const Value.absent(),
    this.isActive = const Value.absent(),
    this.externalId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : vehicleId = Value(vehicleId),
       title = Value(title);
  static Insertable<Reminder> custom({
    Expression<int>? id,
    Expression<int>? vehicleId,
    Expression<String>? title,
    Expression<String>? categoryKey,
    Expression<DateTime>? dueDate,
    Expression<double>? dueOdometer,
    Expression<int>? repeatMonths,
    Expression<double>? repeatKm,
    Expression<int>? advanceDays,
    Expression<double>? advanceKm,
    Expression<DateTime>? lastDoneDate,
    Expression<double>? lastDoneOdometer,
    Expression<String>? note,
    Expression<bool>? isActive,
    Expression<String>? externalId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (title != null) 'title': title,
      if (categoryKey != null) 'category_key': categoryKey,
      if (dueDate != null) 'due_date': dueDate,
      if (dueOdometer != null) 'due_odometer': dueOdometer,
      if (repeatMonths != null) 'repeat_months': repeatMonths,
      if (repeatKm != null) 'repeat_km': repeatKm,
      if (advanceDays != null) 'advance_days': advanceDays,
      if (advanceKm != null) 'advance_km': advanceKm,
      if (lastDoneDate != null) 'last_done_date': lastDoneDate,
      if (lastDoneOdometer != null) 'last_done_odometer': lastDoneOdometer,
      if (note != null) 'note': note,
      if (isActive != null) 'is_active': isActive,
      if (externalId != null) 'external_id': externalId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RemindersCompanion copyWith({
    Value<int>? id,
    Value<int>? vehicleId,
    Value<String>? title,
    Value<String>? categoryKey,
    Value<DateTime?>? dueDate,
    Value<double?>? dueOdometer,
    Value<int?>? repeatMonths,
    Value<double?>? repeatKm,
    Value<int>? advanceDays,
    Value<double>? advanceKm,
    Value<DateTime?>? lastDoneDate,
    Value<double?>? lastDoneOdometer,
    Value<String>? note,
    Value<bool>? isActive,
    Value<String?>? externalId,
    Value<DateTime>? createdAt,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      title: title ?? this.title,
      categoryKey: categoryKey ?? this.categoryKey,
      dueDate: dueDate ?? this.dueDate,
      dueOdometer: dueOdometer ?? this.dueOdometer,
      repeatMonths: repeatMonths ?? this.repeatMonths,
      repeatKm: repeatKm ?? this.repeatKm,
      advanceDays: advanceDays ?? this.advanceDays,
      advanceKm: advanceKm ?? this.advanceKm,
      lastDoneDate: lastDoneDate ?? this.lastDoneDate,
      lastDoneOdometer: lastDoneOdometer ?? this.lastDoneOdometer,
      note: note ?? this.note,
      isActive: isActive ?? this.isActive,
      externalId: externalId ?? this.externalId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<int>(vehicleId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (categoryKey.present) {
      map['category_key'] = Variable<String>(categoryKey.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (dueOdometer.present) {
      map['due_odometer'] = Variable<double>(dueOdometer.value);
    }
    if (repeatMonths.present) {
      map['repeat_months'] = Variable<int>(repeatMonths.value);
    }
    if (repeatKm.present) {
      map['repeat_km'] = Variable<double>(repeatKm.value);
    }
    if (advanceDays.present) {
      map['advance_days'] = Variable<int>(advanceDays.value);
    }
    if (advanceKm.present) {
      map['advance_km'] = Variable<double>(advanceKm.value);
    }
    if (lastDoneDate.present) {
      map['last_done_date'] = Variable<DateTime>(lastDoneDate.value);
    }
    if (lastDoneOdometer.present) {
      map['last_done_odometer'] = Variable<double>(lastDoneOdometer.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('title: $title, ')
          ..write('categoryKey: $categoryKey, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueOdometer: $dueOdometer, ')
          ..write('repeatMonths: $repeatMonths, ')
          ..write('repeatKm: $repeatKm, ')
          ..write('advanceDays: $advanceDays, ')
          ..write('advanceKm: $advanceKm, ')
          ..write('lastDoneDate: $lastDoneDate, ')
          ..write('lastDoneOdometer: $lastDoneOdometer, ')
          ..write('note: $note, ')
          ..write('isActive: $isActive, ')
          ..write('externalId: $externalId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $StationsTable extends Stations with TableInfo<$StationsTable, Station> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastUsedAtMeta = const VerificationMeta(
    'lastUsedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
    'last_used_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    brand,
    latitude,
    longitude,
    externalId,
    isFavorite,
    lastUsedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Station> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
        _lastUsedAtMeta,
        lastUsedAt.isAcceptableOrUnknown(
          data['last_used_at']!,
          _lastUsedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Station map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Station(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      lastUsedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_used_at'],
      ),
    );
  }

  @override
  $StationsTable createAlias(String alias) {
    return $StationsTable(attachedDatabase, alias);
  }
}

class Station extends DataClass implements Insertable<Station> {
  final int id;
  final String name;
  final String brand;
  final double? latitude;
  final double? longitude;
  final String? externalId;
  final bool isFavorite;
  final DateTime? lastUsedAt;
  const Station({
    required this.id,
    required this.name,
    required this.brand,
    this.latitude,
    this.longitude,
    this.externalId,
    required this.isFavorite,
    this.lastUsedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['brand'] = Variable<String>(brand);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || externalId != null) {
      map['external_id'] = Variable<String>(externalId);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || lastUsedAt != null) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    }
    return map;
  }

  StationsCompanion toCompanion(bool nullToAbsent) {
    return StationsCompanion(
      id: Value(id),
      name: Value(name),
      brand: Value(brand),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      externalId: externalId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalId),
      isFavorite: Value(isFavorite),
      lastUsedAt: lastUsedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedAt),
    );
  }

  factory Station.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Station(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String>(json['brand']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      externalId: serializer.fromJson<String?>(json['externalId']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      lastUsedAt: serializer.fromJson<DateTime?>(json['lastUsedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String>(brand),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'externalId': serializer.toJson<String?>(externalId),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'lastUsedAt': serializer.toJson<DateTime?>(lastUsedAt),
    };
  }

  Station copyWith({
    int? id,
    String? name,
    String? brand,
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    Value<String?> externalId = const Value.absent(),
    bool? isFavorite,
    Value<DateTime?> lastUsedAt = const Value.absent(),
  }) => Station(
    id: id ?? this.id,
    name: name ?? this.name,
    brand: brand ?? this.brand,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    externalId: externalId.present ? externalId.value : this.externalId,
    isFavorite: isFavorite ?? this.isFavorite,
    lastUsedAt: lastUsedAt.present ? lastUsedAt.value : this.lastUsedAt,
  );
  Station copyWithCompanion(StationsCompanion data) {
    return Station(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      lastUsedAt: data.lastUsedAt.present
          ? data.lastUsedAt.value
          : this.lastUsedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Station(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('externalId: $externalId, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('lastUsedAt: $lastUsedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    brand,
    latitude,
    longitude,
    externalId,
    isFavorite,
    lastUsedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Station &&
          other.id == this.id &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.externalId == this.externalId &&
          other.isFavorite == this.isFavorite &&
          other.lastUsedAt == this.lastUsedAt);
}

class StationsCompanion extends UpdateCompanion<Station> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> brand;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String?> externalId;
  final Value<bool> isFavorite;
  final Value<DateTime?> lastUsedAt;
  const StationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.externalId = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
  });
  StationsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.brand = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.externalId = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Station> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? externalId,
    Expression<bool>? isFavorite,
    Expression<DateTime>? lastUsedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (externalId != null) 'external_id': externalId,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
    });
  }

  StationsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? brand,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<String?>? externalId,
    Value<bool>? isFavorite,
    Value<DateTime?>? lastUsedAt,
  }) {
    return StationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      externalId: externalId ?? this.externalId,
      isFavorite: isFavorite ?? this.isFavorite,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('externalId: $externalId, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('lastUsedAt: $lastUsedAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VehiclesTable vehicles = $VehiclesTable(this);
  late final $FillUpsTable fillUps = $FillUpsTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $ExpenseCategoriesTable expenseCategories =
      $ExpenseCategoriesTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $StationsTable stations = $StationsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    vehicles,
    fillUps,
    expenses,
    expenseCategories,
    reminders,
    stations,
    appSettings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vehicles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('fill_ups', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vehicles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('expenses', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vehicles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reminders', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$VehiclesTableCreateCompanionBuilder = VehiclesCompanion Function({
  Value<int> id,
  required String name,
  Value<String> make,
  Value<String> model,
  Value<String> plate,
  Value<int?> year,
  Value<String> fuelType,
  Value<double?> tankCapacity,
  Value<double> initialOdometer,
  Value<String> currency,
  Value<String> notes,
  Value<String?> externalId,
  Value<bool> isArchived,
  Value<bool> isFavorite,
  Value<DateTime> createdAt,
});
typedef $$VehiclesTableUpdateCompanionBuilder = VehiclesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> make,
  Value<String> model,
  Value<String> plate,
  Value<int?> year,
  Value<String> fuelType,
  Value<double?> tankCapacity,
  Value<double> initialOdometer,
  Value<String> currency,
  Value<String> notes,
  Value<String?> externalId,
  Value<bool> isArchived,
  Value<bool> isFavorite,
  Value<DateTime> createdAt,
});

final class $$VehiclesTableReferences
    extends BaseReferences<_$AppDatabase, $VehiclesTable, Vehicle> {
  $$VehiclesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FillUpsTable, List<FillUp>> _fillUpsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.fillUps,
    aliasName: 'vehicles__id__fill_ups__vehicle_id',
  );

  $$FillUpsTableProcessedTableManager get fillUpsRefs {
    final manager = $$FillUpsTableTableManager(
      $_db,
      $_db.fillUps,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_fillUpsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExpensesTable, List<Expense>> _expensesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: 'vehicles__id__expenses__vehicle_id',
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RemindersTable, List<Reminder>>
  _remindersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reminders,
    aliasName: 'vehicles__id__reminders__vehicle_id',
  );

  $$RemindersTableProcessedTableManager get remindersRefs {
    final manager = $$RemindersTableTableManager(
      $_db,
      $_db.reminders,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_remindersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VehiclesTableFilterComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get make => $composableBuilder(
    column: $table.make,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plate => $composableBuilder(
    column: $table.plate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fuelType => $composableBuilder(
    column: $table.fuelType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tankCapacity => $composableBuilder(
    column: $table.tankCapacity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get initialOdometer => $composableBuilder(
    column: $table.initialOdometer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> fillUpsRefs(
    Expression<bool> Function($$FillUpsTableFilterComposer f) f,
  ) {
    final $$FillUpsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fillUps,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FillUpsTableFilterComposer(
            $db: $db,
            $table: $db.fillUps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> remindersRefs(
    Expression<bool> Function($$RemindersTableFilterComposer f) f,
  ) {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableFilterComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VehiclesTableOrderingComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get make => $composableBuilder(
    column: $table.make,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plate => $composableBuilder(
    column: $table.plate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fuelType => $composableBuilder(
    column: $table.fuelType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tankCapacity => $composableBuilder(
    column: $table.tankCapacity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get initialOdometer => $composableBuilder(
    column: $table.initialOdometer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VehiclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get make =>
      $composableBuilder(column: $table.make, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get plate =>
      $composableBuilder(column: $table.plate, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get fuelType =>
      $composableBuilder(column: $table.fuelType, builder: (column) => column);

  GeneratedColumn<double> get tankCapacity => $composableBuilder(
    column: $table.tankCapacity,
    builder: (column) => column,
  );

  GeneratedColumn<double> get initialOdometer => $composableBuilder(
    column: $table.initialOdometer,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> fillUpsRefs<T extends Object>(
    Expression<T> Function($$FillUpsTableAnnotationComposer a) f,
  ) {
    final $$FillUpsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fillUps,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FillUpsTableAnnotationComposer(
            $db: $db,
            $table: $db.fillUps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> remindersRefs<T extends Object>(
    Expression<T> Function($$RemindersTableAnnotationComposer a) f,
  ) {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableAnnotationComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VehiclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VehiclesTable,
          Vehicle,
          $$VehiclesTableFilterComposer,
          $$VehiclesTableOrderingComposer,
          $$VehiclesTableAnnotationComposer,
          $$VehiclesTableCreateCompanionBuilder,
          $$VehiclesTableUpdateCompanionBuilder,
          (Vehicle, $$VehiclesTableReferences),
          Vehicle,
          PrefetchHooks Function({
            bool fillUpsRefs,
            bool expensesRefs,
            bool remindersRefs,
          })
        > {
  $$VehiclesTableTableManager(_$AppDatabase db, $VehiclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehiclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehiclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehiclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> make = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<String> plate = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String> fuelType = const Value.absent(),
                Value<double?> tankCapacity = const Value.absent(),
                Value<double> initialOdometer = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => VehiclesCompanion(
                id: id,
                name: name,
                make: make,
                model: model,
                plate: plate,
                year: year,
                fuelType: fuelType,
                tankCapacity: tankCapacity,
                initialOdometer: initialOdometer,
                currency: currency,
                notes: notes,
                externalId: externalId,
                isArchived: isArchived,
                isFavorite: isFavorite,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> make = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<String> plate = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String> fuelType = const Value.absent(),
                Value<double?> tankCapacity = const Value.absent(),
                Value<double> initialOdometer = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => VehiclesCompanion.insert(
                id: id,
                name: name,
                make: make,
                model: model,
                plate: plate,
                year: year,
                fuelType: fuelType,
                tankCapacity: tankCapacity,
                initialOdometer: initialOdometer,
                currency: currency,
                notes: notes,
                externalId: externalId,
                isArchived: isArchived,
                isFavorite: isFavorite,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VehiclesTable, Vehicle>(table),
                  $$VehiclesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                fillUpsRefs = false,
                expensesRefs = false,
                remindersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (fillUpsRefs) db.fillUps,
                    if (expensesRefs) db.expenses,
                    if (remindersRefs) db.reminders,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (fillUpsRefs)
                        await $_getPrefetchedDataByColumns<
                          Vehicle,
                          $VehiclesTable,
                          FillUp,
                          $FillUpsTable
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._fillUpsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).fillUpsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'vehicle_id',
                          typedResults: items,
                        ),
                      if (expensesRefs)
                        await $_getPrefetchedDataByColumns<
                          Vehicle,
                          $VehiclesTable,
                          Expense,
                          $ExpensesTable
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._expensesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).expensesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'vehicle_id',
                          typedResults: items,
                        ),
                      if (remindersRefs)
                        await $_getPrefetchedDataByColumns<
                          Vehicle,
                          $VehiclesTable,
                          Reminder,
                          $RemindersTable
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._remindersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).remindersRefs,
                          currentColumn: 'id',
                          referencedColumn: 'vehicle_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$VehiclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VehiclesTable,
      Vehicle,
      $$VehiclesTableFilterComposer,
      $$VehiclesTableOrderingComposer,
      $$VehiclesTableAnnotationComposer,
      $$VehiclesTableCreateCompanionBuilder,
      $$VehiclesTableUpdateCompanionBuilder,
      (Vehicle, $$VehiclesTableReferences),
      Vehicle,
      PrefetchHooks Function({
        bool fillUpsRefs,
        bool expensesRefs,
        bool remindersRefs,
      })
    >;
typedef $$FillUpsTableCreateCompanionBuilder = FillUpsCompanion Function({
  Value<int> id,
  required int vehicleId,
  required DateTime date,
  required double odometer,
  required double liters,
  Value<double> pricePerLiter,
  Value<double> totalPrice,
  Value<bool> isFull,
  Value<bool> isMissed,
  Value<String> stationName,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<String> note,
  Value<String?> fuelType,
  Value<int> tankNumber,
  Value<bool> excludeDistance,
  Value<String?> receiptPath,
  Value<String?> externalId,
  Value<DateTime> createdAt,
});
typedef $$FillUpsTableUpdateCompanionBuilder = FillUpsCompanion Function({
  Value<int> id,
  Value<int> vehicleId,
  Value<DateTime> date,
  Value<double> odometer,
  Value<double> liters,
  Value<double> pricePerLiter,
  Value<double> totalPrice,
  Value<bool> isFull,
  Value<bool> isMissed,
  Value<String> stationName,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<String> note,
  Value<String?> fuelType,
  Value<int> tankNumber,
  Value<bool> excludeDistance,
  Value<String?> receiptPath,
  Value<String?> externalId,
  Value<DateTime> createdAt,
});

final class $$FillUpsTableReferences
    extends BaseReferences<_$AppDatabase, $FillUpsTable, FillUp> {
  $$FillUpsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias('fill_ups__vehicle_id__vehicles__id');

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<int>('vehicle_id')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FillUpsTableFilterComposer
    extends Composer<_$AppDatabase, $FillUpsTable> {
  $$FillUpsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get odometer => $composableBuilder(
    column: $table.odometer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get liters => $composableBuilder(
    column: $table.liters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pricePerLiter => $composableBuilder(
    column: $table.pricePerLiter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFull => $composableBuilder(
    column: $table.isFull,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isMissed => $composableBuilder(
    column: $table.isMissed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stationName => $composableBuilder(
    column: $table.stationName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fuelType => $composableBuilder(
    column: $table.fuelType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tankNumber => $composableBuilder(
    column: $table.tankNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get excludeDistance => $composableBuilder(
    column: $table.excludeDistance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FillUpsTableOrderingComposer
    extends Composer<_$AppDatabase, $FillUpsTable> {
  $$FillUpsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get odometer => $composableBuilder(
    column: $table.odometer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get liters => $composableBuilder(
    column: $table.liters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pricePerLiter => $composableBuilder(
    column: $table.pricePerLiter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFull => $composableBuilder(
    column: $table.isFull,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMissed => $composableBuilder(
    column: $table.isMissed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stationName => $composableBuilder(
    column: $table.stationName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fuelType => $composableBuilder(
    column: $table.fuelType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tankNumber => $composableBuilder(
    column: $table.tankNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get excludeDistance => $composableBuilder(
    column: $table.excludeDistance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FillUpsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FillUpsTable> {
  $$FillUpsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get odometer =>
      $composableBuilder(column: $table.odometer, builder: (column) => column);

  GeneratedColumn<double> get liters =>
      $composableBuilder(column: $table.liters, builder: (column) => column);

  GeneratedColumn<double> get pricePerLiter => $composableBuilder(
    column: $table.pricePerLiter,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFull =>
      $composableBuilder(column: $table.isFull, builder: (column) => column);

  GeneratedColumn<bool> get isMissed =>
      $composableBuilder(column: $table.isMissed, builder: (column) => column);

  GeneratedColumn<String> get stationName => $composableBuilder(
    column: $table.stationName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get fuelType =>
      $composableBuilder(column: $table.fuelType, builder: (column) => column);

  GeneratedColumn<int> get tankNumber => $composableBuilder(
    column: $table.tankNumber,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get excludeDistance => $composableBuilder(
    column: $table.excludeDistance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FillUpsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FillUpsTable,
          FillUp,
          $$FillUpsTableFilterComposer,
          $$FillUpsTableOrderingComposer,
          $$FillUpsTableAnnotationComposer,
          $$FillUpsTableCreateCompanionBuilder,
          $$FillUpsTableUpdateCompanionBuilder,
          (FillUp, $$FillUpsTableReferences),
          FillUp,
          PrefetchHooks Function({bool vehicleId})
        > {
  $$FillUpsTableTableManager(_$AppDatabase db, $FillUpsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FillUpsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FillUpsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FillUpsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> vehicleId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double> odometer = const Value.absent(),
                Value<double> liters = const Value.absent(),
                Value<double> pricePerLiter = const Value.absent(),
                Value<double> totalPrice = const Value.absent(),
                Value<bool> isFull = const Value.absent(),
                Value<bool> isMissed = const Value.absent(),
                Value<String> stationName = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String?> fuelType = const Value.absent(),
                Value<int> tankNumber = const Value.absent(),
                Value<bool> excludeDistance = const Value.absent(),
                Value<String?> receiptPath = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FillUpsCompanion(
                id: id,
                vehicleId: vehicleId,
                date: date,
                odometer: odometer,
                liters: liters,
                pricePerLiter: pricePerLiter,
                totalPrice: totalPrice,
                isFull: isFull,
                isMissed: isMissed,
                stationName: stationName,
                latitude: latitude,
                longitude: longitude,
                note: note,
                fuelType: fuelType,
                tankNumber: tankNumber,
                excludeDistance: excludeDistance,
                receiptPath: receiptPath,
                externalId: externalId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int vehicleId,
                required DateTime date,
                required double odometer,
                required double liters,
                Value<double> pricePerLiter = const Value.absent(),
                Value<double> totalPrice = const Value.absent(),
                Value<bool> isFull = const Value.absent(),
                Value<bool> isMissed = const Value.absent(),
                Value<String> stationName = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String?> fuelType = const Value.absent(),
                Value<int> tankNumber = const Value.absent(),
                Value<bool> excludeDistance = const Value.absent(),
                Value<String?> receiptPath = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FillUpsCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                date: date,
                odometer: odometer,
                liters: liters,
                pricePerLiter: pricePerLiter,
                totalPrice: totalPrice,
                isFull: isFull,
                isMissed: isMissed,
                stationName: stationName,
                latitude: latitude,
                longitude: longitude,
                note: note,
                fuelType: fuelType,
                tankNumber: tankNumber,
                excludeDistance: excludeDistance,
                receiptPath: receiptPath,
                externalId: externalId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FillUpsTable, FillUp>(table),
                  $$FillUpsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vehicleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (vehicleId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.vehicleId,
                        referencedTable: $$FillUpsTableReferences
                            ._vehicleIdTable(db),
                        referencedColumn: $$FillUpsTableReferences
                            ._vehicleIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FillUpsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FillUpsTable,
      FillUp,
      $$FillUpsTableFilterComposer,
      $$FillUpsTableOrderingComposer,
      $$FillUpsTableAnnotationComposer,
      $$FillUpsTableCreateCompanionBuilder,
      $$FillUpsTableUpdateCompanionBuilder,
      (FillUp, $$FillUpsTableReferences),
      FillUp,
      PrefetchHooks Function({bool vehicleId})
    >;
typedef $$ExpensesTableCreateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  required int vehicleId,
  required String title,
  required DateTime date,
  Value<double?> odometer,
  Value<String> categoryKey,
  Value<double> amount,
  Value<String> note,
  Value<bool> isIncome,
  Value<String?> receiptPath,
  Value<String?> externalId,
  Value<DateTime> createdAt,
});
typedef $$ExpensesTableUpdateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  Value<int> vehicleId,
  Value<String> title,
  Value<DateTime> date,
  Value<double?> odometer,
  Value<String> categoryKey,
  Value<double> amount,
  Value<String> note,
  Value<bool> isIncome,
  Value<String?> receiptPath,
  Value<String?> externalId,
  Value<DateTime> createdAt,
});

final class $$ExpensesTableReferences
    extends BaseReferences<_$AppDatabase, $ExpensesTable, Expense> {
  $$ExpensesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias('expenses__vehicle_id__vehicles__id');

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<int>('vehicle_id')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get odometer => $composableBuilder(
    column: $table.odometer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryKey => $composableBuilder(
    column: $table.categoryKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isIncome => $composableBuilder(
    column: $table.isIncome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get odometer => $composableBuilder(
    column: $table.odometer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryKey => $composableBuilder(
    column: $table.categoryKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isIncome => $composableBuilder(
    column: $table.isIncome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get odometer =>
      $composableBuilder(column: $table.odometer, builder: (column) => column);

  GeneratedColumn<String> get categoryKey => $composableBuilder(
    column: $table.categoryKey,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get isIncome =>
      $composableBuilder(column: $table.isIncome, builder: (column) => column);

  GeneratedColumn<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          Expense,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (Expense, $$ExpensesTableReferences),
          Expense,
          PrefetchHooks Function({bool vehicleId})
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> vehicleId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double?> odometer = const Value.absent(),
                Value<String> categoryKey = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<bool> isIncome = const Value.absent(),
                Value<String?> receiptPath = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                vehicleId: vehicleId,
                title: title,
                date: date,
                odometer: odometer,
                categoryKey: categoryKey,
                amount: amount,
                note: note,
                isIncome: isIncome,
                receiptPath: receiptPath,
                externalId: externalId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int vehicleId,
                required String title,
                required DateTime date,
                Value<double?> odometer = const Value.absent(),
                Value<String> categoryKey = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<bool> isIncome = const Value.absent(),
                Value<String?> receiptPath = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ExpensesCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                title: title,
                date: date,
                odometer: odometer,
                categoryKey: categoryKey,
                amount: amount,
                note: note,
                isIncome: isIncome,
                receiptPath: receiptPath,
                externalId: externalId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExpensesTable, Expense>(table),
                  $$ExpensesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vehicleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (vehicleId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.vehicleId,
                        referencedTable: $$ExpensesTableReferences
                            ._vehicleIdTable(db),
                        referencedColumn: $$ExpensesTableReferences
                            ._vehicleIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      Expense,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (Expense, $$ExpensesTableReferences),
      Expense,
      PrefetchHooks Function({bool vehicleId})
    >;
typedef $$ExpenseCategoriesTableCreateCompanionBuilder =
    ExpenseCategoriesCompanion Function({
      Value<int> id,
      required String key,
      required String label,
      Value<int> color,
      Value<bool> isBuiltin,
    });
typedef $$ExpenseCategoriesTableUpdateCompanionBuilder =
    ExpenseCategoriesCompanion Function({
      Value<int> id,
      Value<String> key,
      Value<String> label,
      Value<int> color,
      Value<bool> isBuiltin,
    });

class $$ExpenseCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBuiltin => $composableBuilder(
    column: $table.isBuiltin,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExpenseCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBuiltin => $composableBuilder(
    column: $table.isBuiltin,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpenseCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get isBuiltin =>
      $composableBuilder(column: $table.isBuiltin, builder: (column) => column);
}

class $$ExpenseCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpenseCategoriesTable,
          ExpenseCategory,
          $$ExpenseCategoriesTableFilterComposer,
          $$ExpenseCategoriesTableOrderingComposer,
          $$ExpenseCategoriesTableAnnotationComposer,
          $$ExpenseCategoriesTableCreateCompanionBuilder,
          $$ExpenseCategoriesTableUpdateCompanionBuilder,
          (
            ExpenseCategory,
            BaseReferences<
              _$AppDatabase,
              $ExpenseCategoriesTable,
              ExpenseCategory
            >,
          ),
          ExpenseCategory,
          PrefetchHooks Function()
        > {
  $$ExpenseCategoriesTableTableManager(
    _$AppDatabase db,
    $ExpenseCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseCategoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<bool> isBuiltin = const Value.absent(),
              }) => ExpenseCategoriesCompanion(
                id: id,
                key: key,
                label: label,
                color: color,
                isBuiltin: isBuiltin,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String key,
                required String label,
                Value<int> color = const Value.absent(),
                Value<bool> isBuiltin = const Value.absent(),
              }) => ExpenseCategoriesCompanion.insert(
                id: id,
                key: key,
                label: label,
                color: color,
                isBuiltin: isBuiltin,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExpenseCategoriesTable, ExpenseCategory>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ExpenseCategoriesTable,
                    ExpenseCategory
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExpenseCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpenseCategoriesTable,
      ExpenseCategory,
      $$ExpenseCategoriesTableFilterComposer,
      $$ExpenseCategoriesTableOrderingComposer,
      $$ExpenseCategoriesTableAnnotationComposer,
      $$ExpenseCategoriesTableCreateCompanionBuilder,
      $$ExpenseCategoriesTableUpdateCompanionBuilder,
      (
        ExpenseCategory,
        BaseReferences<_$AppDatabase, $ExpenseCategoriesTable, ExpenseCategory>,
      ),
      ExpenseCategory,
      PrefetchHooks Function()
    >;
typedef $$RemindersTableCreateCompanionBuilder = RemindersCompanion Function({
  Value<int> id,
  required int vehicleId,
  required String title,
  Value<String> categoryKey,
  Value<DateTime?> dueDate,
  Value<double?> dueOdometer,
  Value<int?> repeatMonths,
  Value<double?> repeatKm,
  Value<int> advanceDays,
  Value<double> advanceKm,
  Value<DateTime?> lastDoneDate,
  Value<double?> lastDoneOdometer,
  Value<String> note,
  Value<bool> isActive,
  Value<String?> externalId,
  Value<DateTime> createdAt,
});
typedef $$RemindersTableUpdateCompanionBuilder = RemindersCompanion Function({
  Value<int> id,
  Value<int> vehicleId,
  Value<String> title,
  Value<String> categoryKey,
  Value<DateTime?> dueDate,
  Value<double?> dueOdometer,
  Value<int?> repeatMonths,
  Value<double?> repeatKm,
  Value<int> advanceDays,
  Value<double> advanceKm,
  Value<DateTime?> lastDoneDate,
  Value<double?> lastDoneOdometer,
  Value<String> note,
  Value<bool> isActive,
  Value<String?> externalId,
  Value<DateTime> createdAt,
});

final class $$RemindersTableReferences
    extends BaseReferences<_$AppDatabase, $RemindersTable, Reminder> {
  $$RemindersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias('reminders__vehicle_id__vehicles__id');

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<int>('vehicle_id')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryKey => $composableBuilder(
    column: $table.categoryKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get dueOdometer => $composableBuilder(
    column: $table.dueOdometer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repeatMonths => $composableBuilder(
    column: $table.repeatMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get repeatKm => $composableBuilder(
    column: $table.repeatKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get advanceDays => $composableBuilder(
    column: $table.advanceDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get advanceKm => $composableBuilder(
    column: $table.advanceKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastDoneDate => $composableBuilder(
    column: $table.lastDoneDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lastDoneOdometer => $composableBuilder(
    column: $table.lastDoneOdometer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryKey => $composableBuilder(
    column: $table.categoryKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dueOdometer => $composableBuilder(
    column: $table.dueOdometer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repeatMonths => $composableBuilder(
    column: $table.repeatMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get repeatKm => $composableBuilder(
    column: $table.repeatKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get advanceDays => $composableBuilder(
    column: $table.advanceDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get advanceKm => $composableBuilder(
    column: $table.advanceKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastDoneDate => $composableBuilder(
    column: $table.lastDoneDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lastDoneOdometer => $composableBuilder(
    column: $table.lastDoneOdometer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get categoryKey => $composableBuilder(
    column: $table.categoryKey,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<double> get dueOdometer => $composableBuilder(
    column: $table.dueOdometer,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repeatMonths => $composableBuilder(
    column: $table.repeatMonths,
    builder: (column) => column,
  );

  GeneratedColumn<double> get repeatKm =>
      $composableBuilder(column: $table.repeatKm, builder: (column) => column);

  GeneratedColumn<int> get advanceDays => $composableBuilder(
    column: $table.advanceDays,
    builder: (column) => column,
  );

  GeneratedColumn<double> get advanceKm =>
      $composableBuilder(column: $table.advanceKm, builder: (column) => column);

  GeneratedColumn<DateTime> get lastDoneDate => $composableBuilder(
    column: $table.lastDoneDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lastDoneOdometer => $composableBuilder(
    column: $table.lastDoneOdometer,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          Reminder,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (Reminder, $$RemindersTableReferences),
          Reminder,
          PrefetchHooks Function({bool vehicleId})
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> vehicleId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> categoryKey = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<double?> dueOdometer = const Value.absent(),
                Value<int?> repeatMonths = const Value.absent(),
                Value<double?> repeatKm = const Value.absent(),
                Value<int> advanceDays = const Value.absent(),
                Value<double> advanceKm = const Value.absent(),
                Value<DateTime?> lastDoneDate = const Value.absent(),
                Value<double?> lastDoneOdometer = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                vehicleId: vehicleId,
                title: title,
                categoryKey: categoryKey,
                dueDate: dueDate,
                dueOdometer: dueOdometer,
                repeatMonths: repeatMonths,
                repeatKm: repeatKm,
                advanceDays: advanceDays,
                advanceKm: advanceKm,
                lastDoneDate: lastDoneDate,
                lastDoneOdometer: lastDoneOdometer,
                note: note,
                isActive: isActive,
                externalId: externalId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int vehicleId,
                required String title,
                Value<String> categoryKey = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<double?> dueOdometer = const Value.absent(),
                Value<int?> repeatMonths = const Value.absent(),
                Value<double?> repeatKm = const Value.absent(),
                Value<int> advanceDays = const Value.absent(),
                Value<double> advanceKm = const Value.absent(),
                Value<DateTime?> lastDoneDate = const Value.absent(),
                Value<double?> lastDoneOdometer = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RemindersCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                title: title,
                categoryKey: categoryKey,
                dueDate: dueDate,
                dueOdometer: dueOdometer,
                repeatMonths: repeatMonths,
                repeatKm: repeatKm,
                advanceDays: advanceDays,
                advanceKm: advanceKm,
                lastDoneDate: lastDoneDate,
                lastDoneOdometer: lastDoneOdometer,
                note: note,
                isActive: isActive,
                externalId: externalId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RemindersTable, Reminder>(table),
                  $$RemindersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vehicleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (vehicleId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.vehicleId,
                        referencedTable: $$RemindersTableReferences
                            ._vehicleIdTable(db),
                        referencedColumn: $$RemindersTableReferences
                            ._vehicleIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      Reminder,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (Reminder, $$RemindersTableReferences),
      Reminder,
      PrefetchHooks Function({bool vehicleId})
    >;
typedef $$StationsTableCreateCompanionBuilder = StationsCompanion Function({
  Value<int> id,
  required String name,
  Value<String> brand,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<String?> externalId,
  Value<bool> isFavorite,
  Value<DateTime?> lastUsedAt,
});
typedef $$StationsTableUpdateCompanionBuilder = StationsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> brand,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<String?> externalId,
  Value<bool> isFavorite,
  Value<DateTime?> lastUsedAt,
});

class $$StationsTableFilterComposer
    extends Composer<_$AppDatabase, $StationsTable> {
  $$StationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StationsTableOrderingComposer
    extends Composer<_$AppDatabase, $StationsTable> {
  $$StationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StationsTable> {
  $$StationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => column,
  );
}

class $$StationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StationsTable,
          Station,
          $$StationsTableFilterComposer,
          $$StationsTableOrderingComposer,
          $$StationsTableAnnotationComposer,
          $$StationsTableCreateCompanionBuilder,
          $$StationsTableUpdateCompanionBuilder,
          (Station, BaseReferences<_$AppDatabase, $StationsTable, Station>),
          Station,
          PrefetchHooks Function()
        > {
  $$StationsTableTableManager(_$AppDatabase db, $StationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> brand = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime?> lastUsedAt = const Value.absent(),
              }) => StationsCompanion(
                id: id,
                name: name,
                brand: brand,
                latitude: latitude,
                longitude: longitude,
                externalId: externalId,
                isFavorite: isFavorite,
                lastUsedAt: lastUsedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> brand = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime?> lastUsedAt = const Value.absent(),
              }) => StationsCompanion.insert(
                id: id,
                name: name,
                brand: brand,
                latitude: latitude,
                longitude: longitude,
                externalId: externalId,
                isFavorite: isFavorite,
                lastUsedAt: lastUsedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StationsTable, Station>(table),
                  BaseReferences<_$AppDatabase, $StationsTable, Station>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StationsTable,
      Station,
      $$StationsTableFilterComposer,
      $$StationsTableOrderingComposer,
      $$StationsTableAnnotationComposer,
      $$StationsTableCreateCompanionBuilder,
      $$StationsTableUpdateCompanionBuilder,
      (Station, BaseReferences<_$AppDatabase, $StationsTable, Station>),
      Station,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSetting>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db, _db.vehicles);
  $$FillUpsTableTableManager get fillUps =>
      $$FillUpsTableTableManager(_db, _db.fillUps);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$ExpenseCategoriesTableTableManager get expenseCategories =>
      $$ExpenseCategoriesTableTableManager(_db, _db.expenseCategories);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$StationsTableTableManager get stations =>
      $$StationsTableTableManager(_db, _db.stations);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
