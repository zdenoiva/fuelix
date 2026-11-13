import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_state.dart';
import '../../data/database.dart';
import '../../domain/consumption.dart';
import '../../l10n/strings.dart';
import '../../services/location_service.dart';
import '../../services/receipt_scanner.dart';
import '../../util/context_format.dart';
import '../../widgets/common.dart';
import 'receipt_scanner_screen.dart';

class FillUpFormScreen extends StatefulWidget {
  const FillUpFormScreen({
    super.key,
    required this.vehicleId,
    this.fillUp,
    this.draft,
    this.prefilledOdometer,
    this.initialStation,
    this.initialLatitude,
    this.initialLongitude,
  });

  final int vehicleId;
  final FillUp? fillUp;
  final ReceiptData? draft;
  final double? prefilledOdometer;
  final String? initialStation;
  final double? initialLatitude;
  final double? initialLongitude;

  @override
  State<FillUpFormScreen> createState() => _FillUpFormScreenState();
}

class _FillUpFormScreenState extends State<FillUpFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repo = AppState.instance.repo;

  late final TextEditingController _odometer;
  late final TextEditingController _liters;
  late final TextEditingController _total;
  late final TextEditingController _pricePerLiter;
  late final TextEditingController _station;
  late final TextEditingController _note;

  late DateTime _date;
  bool _fullTank = true;
  bool _missed = false;
  double? _latitude;
  double? _longitude;
  bool _locating = false;

  List<FillUp> _existing = const [];
  List<String> _recentStations = const [];
  FillUp? _last;

  @override
  void initState() {
    super.initState();
    final f = widget.fillUp;
    final draft = widget.draft;
    _date = f?.date ?? DateTime.now();
    _odometer = TextEditingController(
      text: f != null
          ? _trim(f.odometer)
          : (widget.prefilledOdometer == null
                ? ''
                : _trim(widget.prefilledOdometer!)),
    );
    _liters = TextEditingController(
      text: f != null ? _trim(f.liters) : (draft?.liters == null ? '' : _trim(draft!.liters!)),
    );
    _total = TextEditingController(
      text: f != null ? _trim(f.totalPrice) : (draft?.total == null ? '' : _trim(draft!.total!)),
    );
    _pricePerLiter = TextEditingController(
      text: f != null
          ? _trim(f.pricePerLiter)
          : (draft?.pricePerLiter == null ? '' : _trim(draft!.pricePerLiter!)),
    );
    _station = TextEditingController(
      text: f?.stationName ??
          draft?.stationName ??
          widget.initialStation ??
          '',
    );
    _note = TextEditingController(text: f?.note ?? '');
    _fullTank = f?.isFull ?? true;
    _missed = f?.isMissed ?? false;
    _latitude = f?.latitude ?? widget.initialLatitude;
    _longitude = f?.longitude ?? widget.initialLongitude;
    _loadContext();
  }

  String _trim(double value) {
    if (value == 0) return '';
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toString();
  }

  Future<void> _loadContext() async {
    final fills = await _repo.fillUps(widget.vehicleId);
    final last = await _repo.lastFillUp(widget.vehicleId);
    final recent = await _repo.recentStations(widget.vehicleId);
    if (!mounted) return;
    setState(() {
      _existing = fills;
      _last = last;
      _recentStations = recent;
      if (widget.fillUp == null && _odometer.text.isEmpty && last != null) {
        _odometer.text = _trim(last.odometer);
      }
      if (widget.fillUp == null && _pricePerLiter.text.isEmpty && last != null) {
        _pricePerLiter.text = _trim(last.pricePerLiter);
        _syncFromPrice();
      }
    });
  }

  @override
  void dispose() {
    for (final controller in [
      _odometer,
      _liters,
      _total,
      _pricePerLiter,
      _station,
      _note,
    ]) {
      controller.dispose();
    }
    _totalFocus.dispose();
    _priceFocus.dispose();
    super.dispose();
  }

  double? get _odometerValue =>
      double.tryParse(_odometer.text.replaceAll(',', '.'));

  double? get _litersValue =>
      double.tryParse(_liters.text.replaceAll(',', '.'));

  double? get _totalValue => double.tryParse(_total.text.replaceAll(',', '.'));

  final FocusNode _totalFocus = FocusNode();
  final FocusNode _priceFocus = FocusNode();

  /// Formats a derived value with the decimal separator of the app language so
  /// the auto-filled fields look like the numbers the user types.
  String _formatDecimal(double value, int decimals) {
    final text = value.toStringAsFixed(decimals);
    return context.lang == 'en' ? text : text.replaceAll('.', ',');
  }

  /// User edits the total → recompute the price per litre, but never touch the
  /// field that currently has focus.
  void _syncFromTotal() {
    final liters = _litersValue;
    final total = _totalValue;
    if (liters == null || liters <= 0 || total == null) return;
    if (!_priceFocus.hasFocus) {
      _pricePerLiter.text = _formatDecimal(total / liters, 3);
    }
    setState(() {});
  }

  /// User edits the price per litre → recompute the total.
  void _syncFromPrice() {
    final liters = _litersValue;
    final price = double.tryParse(_pricePerLiter.text.replaceAll(',', '.'));
    if (liters == null || liters <= 0 || price == null) return;
    if (!_totalFocus.hasFocus) {
      _total.text = _formatDecimal(price * liters, 2);
    }
    setState(() {});
  }

  /// Changing litres keeps the total and recalculates the unit price.
  void _syncAfterLitersChanged() {
    final liters = _litersValue;
    if (liters == null || liters <= 0) return;
    final total = _totalValue;
    if (total != null && total > 0) {
      if (!_priceFocus.hasFocus) {
        _pricePerLiter.text = _formatDecimal(total / liters, 3);
      }
    } else {
      final price = double.tryParse(
        _pricePerLiter.text.replaceAll(',', '.'),
      );
      if (price != null && !_totalFocus.hasFocus) {
        _total.text = _formatDecimal(price * liters, 2);
      }
    }
    setState(() {});
  }

  void _selectAll(TextEditingController controller) {
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: controller.text.length,
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1990),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked == null) return;
    setState(() {
      _date = DateTime(
        picked.year,
        picked.month,
        picked.day,
        _date.hour,
        _date.minute,
      );
    });
  }

  Future<void> _useLocation() async {
    setState(() => _locating = true);
    final result = await LocationService.instance.locate(
      vehicleId: widget.vehicleId,
    );
    if (!mounted) return;
    setState(() => _locating = false);
    if (result == null) {
      showSnack(context, context.t('fillup.locationDenied'));
      return;
    }
    setState(() {
      _latitude = result.latitude;
      _longitude = result.longitude;
      if (result.stationName != null && _station.text.isEmpty) {
        _station.text = result.stationName!;
      }
    });
    if (result.stationName != null) {
      showSnack(context, result.stationName!);
    }
  }

  Future<void> _scanReceipt() async {
    final draft = await Navigator.of(context).push<ReceiptData>(
      MaterialPageRoute(builder: (_) => const ReceiptScannerScreen()),
    );
    if (draft == null || !mounted) return;
    setState(() {
      if (draft.liters != null) _liters.text = _trim(draft.liters!);
      if (draft.total != null) _total.text = _trim(draft.total!);
      if (draft.pricePerLiter != null) {
        _pricePerLiter.text = _trim(draft.pricePerLiter!);
      }
      if (_total.text.isEmpty && _pricePerLiter.text.isNotEmpty) {
        _syncFromPrice();
      }
      if (draft.stationName != null && draft.stationName!.isNotEmpty) {
        _station.text = draft.stationName!;
      }
    });
    showSnack(context, context.t('qr.scanned'));
  }

  double? get _preview {
    final odometer = _odometerValue;
    final liters = _litersValue;
    if (odometer == null || liters == null || liters <= 0) return null;
    if (!_fullTank) return null;
    final points = _existing
        .where((f) => f.id != widget.fillUp?.id)
        .map(
          (f) => FillUpPoint(
            id: f.id,
            date: f.date,
            odometer: f.odometer,
            liters: f.liters,
            isFull: f.isFull,
            isMissed: f.isMissed,
            excludeDistance: f.excludeDistance,
          ),
        );
    return previewConsumption(
      existing: points,
      date: _date,
      odometer: odometer,
      liters: liters,
      isFull: _fullTank,
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final odometer = _odometerValue!;
    final liters = _litersValue!;
    final total = _totalValue ?? 0;
    final pricePerLiter = double.tryParse(
          _pricePerLiter.text.replaceAll(',', '.'),
        ) ??
        (liters > 0 ? total / liters : 0);

    final last = _last;
    if (widget.fillUp == null &&
        last != null &&
        odometer <= last.odometer) {
      final proceed = await confirmDialog(
        context,
        title: context.t('fillup.odometerLower'),
        confirmLabel: context.t('common.continue'),
      );
      if (!proceed || !mounted) return;
    }

    final values = FillUpsCompanion(
      id: widget.fillUp == null ? const Value.absent() : Value(widget.fillUp!.id),
      vehicleId: Value(widget.vehicleId),
      date: Value(_date),
      odometer: Value(odometer),
      liters: Value(liters),
      pricePerLiter: Value(pricePerLiter),
      totalPrice: Value(total),
      isFull: Value(_fullTank),
      isMissed: Value(_missed),
      stationName: Value(_station.text.trim()),
      latitude: Value(_latitude),
      longitude: Value(_longitude),
      note: Value(_note.text.trim()),
      fuelType: const Value.absent(),
    );

    if (widget.fillUp == null) {
      await _repo.insertFillUp(values);
    } else {
      await _repo.updateFillUp(values);
    }
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final preview = _preview;
    final distance = _last != null && _odometerValue != null
        ? _odometerValue! - _last!.odometer
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.t(widget.fillUp == null ? 'fillup.add' : 'fillup.edit'),
        ),
        actions: [
          IconButton(
            tooltip: context.t('fillup.scanQr'),
            onPressed: _scanReceipt,
            icon: const Icon(Icons.qr_code_scanner),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            SectionCard(
              child: Row(
                children: [
                  Expanded(
                    child: StatBlock(
                      label: context.t('fillup.consumption'),
                      value: preview == null
                          ? '–'
                          : '${context.num1(preview)} ${context.t('stats.l100')}',
                      sub: distance == null || distance <= 0
                          ? null
                          : context.t('fillup.distanceSinceLast', {
                              'km': context.num1(distance),
                            }),
                      accent: scheme.primary,
                    ),
                  ),
                  if (widget.fillUp == null && _last != null)
                    Text(
                      context.t('fillup.lastPrice', {
                        'price': context.money(_last!.pricePerLiter),
                      }),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _odometer,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    onTap: () => _selectAll(_odometer),
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: context.t('fillup.odometer'),
                      hintText: context.t('fillup.odometerHint'),
                      suffixText: 'km',
                    ),
                    validator: (value) {
                      final parsed = double.tryParse(
                        (value ?? '').replaceAll(',', '.'),
                      );
                      if (parsed == null || parsed <= 0) {
                        return context.t('fillup.fillRequired');
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _liters,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    onTap: () => _selectAll(_liters),
                    onChanged: (_) => _syncAfterLitersChanged(),
                    decoration: InputDecoration(
                      labelText: context.t('fillup.liters'),
                      hintText: context.t('fillup.litersHint'),
                      suffixText: 'l',
                    ),
                    validator: (value) {
                      final parsed = double.tryParse(
                        (value ?? '').replaceAll(',', '.'),
                      );
                      if (parsed == null || parsed <= 0) {
                        return context.t('fillup.fillRequired');
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _total,
                    focusNode: _totalFocus,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    onTap: () => _selectAll(_total),
                    onChanged: (_) => _syncFromTotal(),
                    decoration: InputDecoration(
                      labelText: context.t('fillup.totalPrice'),
                      prefixText: '${_currencySymbol()} ',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _pricePerLiter,
                    focusNode: _priceFocus,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    onTap: () => _selectAll(_pricePerLiter),
                    onChanged: (_) => _syncFromPrice(),
                    decoration: InputDecoration(
                      labelText: context.t('fillup.pricePerLiter'),
                      prefixText: '${_currencySymbol()} ',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SectionCard(
              child: Column(
                children: [
                  TextFormField(
                    controller: _station,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: context.t('fillup.station'),
                      hintText: context.t('fillup.stationHint'),
                      suffixIcon: _locating
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : IconButton(
                              tooltip: context.t('fillup.useLocation'),
                              icon: const Icon(Icons.my_location),
                              onPressed: _useLocation,
                            ),
                    ),
                  ),
                  if (_recentStations.isNotEmpty &&
                      _station.text.trim().isEmpty) ...[
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          for (final name in _recentStations)
                            ActionChip(
                              label: Text(name),
                              onPressed: () =>
                                  setState(() => _station.text = name),
                            ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _note,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: context.t('common.notes'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.t('fillup.fullTank')),
              subtitle: Text(context.t('fillup.fullTankHelp')),
              value: _fullTank,
              onChanged: (value) => setState(() => _fullTank = value),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.t('fillup.missed')),
              subtitle: Text(context.t('fillup.missedHelp')),
              value: _missed,
              onChanged: (value) => setState(() => _missed = value),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event_outlined),
              title: Text(context.t('fillup.date')),
              subtitle: Text(context.date(_date)),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickDate,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _save,
              child: Text(context.t('common.save')),
            ),
          ],
        ),
      ),
    );
  }

  String _currencySymbol() {
    switch (AppState.instance.currency) {
      case 'CZK':
        return 'Kč';
      case 'USD':
        return '\$';
      case 'GBP':
        return '£';
      case 'PLN':
        return 'zł';
      case 'HUF':
        return 'Ft';
      case 'CHF':
        return 'CHF';
      default:
        return '€';
    }
  }
}
