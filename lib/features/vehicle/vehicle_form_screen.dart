import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_state.dart';
import '../../data/database.dart';
import '../../l10n/strings.dart';
import '../../widgets/common.dart';

const _fuelTypes = [
  'petrol95',
  'petrol98',
  'diesel',
  'lpg',
  'cng',
  'e85',
  'electric',
  'other',
];

const _currencies = ['EUR', 'CZK', 'USD', 'PLN', 'HUF', 'GBP', 'CHF'];

class VehicleFormScreen extends StatefulWidget {
  const VehicleFormScreen({super.key, this.vehicle});

  final Vehicle? vehicle;

  @override
  State<VehicleFormScreen> createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends State<VehicleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repo = AppState.instance.repo;

  late final TextEditingController _name;
  late final TextEditingController _make;
  late final TextEditingController _model;
  late final TextEditingController _plate;
  late final TextEditingController _year;
  late final TextEditingController _tank;
  late final TextEditingController _odometer;
  late String _fuelType;
  late String _currency;

  @override
  void initState() {
    super.initState();
    final v = widget.vehicle;
    _name = TextEditingController(text: v?.name ?? '');
    _make = TextEditingController(text: v?.make ?? '');
    _model = TextEditingController(text: v?.model ?? '');
    _plate = TextEditingController(text: v?.plate ?? '');
    _year = TextEditingController(text: v?.year?.toString() ?? '');
    _tank = TextEditingController(
      text: v?.tankCapacity == null ? '' : _trim(v!.tankCapacity!),
    );
    _odometer = TextEditingController(
      text: v == null || v.initialOdometer == 0
          ? ''
          : _trim(v.initialOdometer),
    );
    _fuelType = v?.fuelType ?? 'petrol95';
    _currency = v?.currency ?? AppState.instance.currency;
  }

  String _trim(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toString();
  }

  @override
  void dispose() {
    for (final controller in [
      _name,
      _make,
      _model,
      _plate,
      _year,
      _tank,
      _odometer,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final name = _name.text.trim();
    final make = _make.text.trim();
    final model = _model.text.trim();
    final plate = _plate.text.trim().toUpperCase();
    final year = int.tryParse(_year.text.trim());
    final tank = double.tryParse(_tank.text.replaceAll(',', '.'));
    final odometer = double.tryParse(_odometer.text.replaceAll(',', '.'));

    if (widget.vehicle == null) {
      await _repo.insertVehicle(
        VehiclesCompanion.insert(
          name: name,
          make: Value(make),
          model: Value(model),
          plate: Value(plate),
          year: Value(year),
          fuelType: Value(_fuelType),
          tankCapacity: Value(tank),
          initialOdometer: Value(odometer ?? 0),
          currency: Value(_currency),
        ),
      );
      if (mounted) Navigator.of(context).pop();
    } else {
      await _repo.updateVehicle(
        VehiclesCompanion(
          id: Value(widget.vehicle!.id),
          name: Value(name),
          make: Value(make),
          model: Value(model),
          plate: Value(plate),
          year: Value(year),
          fuelType: Value(_fuelType),
          tankCapacity: Value(tank),
          initialOdometer: Value(odometer ?? 0),
          currency: Value(_currency),
        ),
      );
      if (mounted) Navigator.of(context).pop();
    }
  }

  Future<void> _delete() async {
    final ok = await confirmDialog(
      context,
      title: context.t('common.deleteConfirm'),
      message: context.t('vehicle.deleteConfirm'),
    );
    if (!ok || !mounted) return;
    await _repo.deleteVehicle(widget.vehicle!.id);
    if (!mounted) return;
    Navigator.of(context)
      ..pop()
      ..pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.vehicle != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.t(isEdit ? 'vehicle.edit' : 'vehicle.new'),
        ),
        actions: [
          if (isEdit)
            IconButton(
              onPressed: _delete,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: context.t('vehicle.name'),
                hintText: context.t('vehicle.nameHint'),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? context.t('vehicle.nameRequired')
                  : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _make,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: context.t('vehicle.make'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _model,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: context.t('vehicle.model'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _plate,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: context.t('vehicle.plate'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 110,
                  child: TextFormField(
                    controller: _year,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: context.t('vehicle.year'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _fuelType,
              decoration: InputDecoration(
                labelText: context.t('vehicle.fuelType'),
              ),
              items: [
                for (final type in _fuelTypes)
                  DropdownMenuItem(
                    value: type,
                    child: Text(context.t('fuel.$type')),
                  ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _fuelType = value);
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _tank,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: context.t('vehicle.tankCapacity'),
                      suffixText: 'l',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _currency,
                    decoration: InputDecoration(
                      labelText: context.t('vehicle.currency'),
                    ),
                    items: [
                      for (final code in _currencies)
                        DropdownMenuItem(value: code, child: Text(code)),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _currency = value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _odometer,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: context.t('vehicle.initialOdometer'),
                suffixText: 'km',
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _save,
              child: Text(context.t('common.save')),
            ),
          ],
        ),
      ),
    );
  }
}
