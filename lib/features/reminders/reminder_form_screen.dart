import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_state.dart';
import '../../data/database.dart';
import '../../domain/presets.dart';
import '../../l10n/strings.dart';
import '../../util/context_format.dart';
import '../../widgets/common.dart';
import '../expenses/expense_form_screen.dart';

class ReminderFormScreen extends StatefulWidget {
  const ReminderFormScreen({
    super.key,
    required this.vehicleId,
    this.reminder,
    this.preset,
  });

  final int vehicleId;
  final Reminder? reminder;
  final ServicePreset? preset;

  @override
  State<ReminderFormScreen> createState() => _ReminderFormScreenState();
}

class _ReminderFormScreenState extends State<ReminderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repo = AppState.instance.repo;

  late final TextEditingController _title;
  late final TextEditingController _odometer;
  late final TextEditingController _repeatMonths;
  late final TextEditingController _repeatKm;
  late final TextEditingController _advanceDays;
  late final TextEditingController _note;

  DateTime? _dueDate;
  late String _category;

  @override
  void initState() {
    super.initState();
    final r = widget.reminder;
    final preset = widget.preset;
    _title = TextEditingController(
      text: r?.title ?? (preset == null ? '' : context.t(preset.labelKey)),
    );
    _odometer = TextEditingController(
      text: r?.dueOdometer == null ? '' : _trim(r!.dueOdometer!),
    );
    _repeatMonths = TextEditingController(
      text: (r?.repeatMonths ?? preset?.repeatMonths)?.toString() ?? '',
    );
    _repeatKm = TextEditingController(
      text: r?.repeatKm == null
          ? (preset?.repeatKm == null ? '' : _trim(preset!.repeatKm!))
          : _trim(r!.repeatKm!),
    );
    _advanceDays = TextEditingController(
      text: (r?.advanceDays ?? 14).toString(),
    );
    _note = TextEditingController(text: r?.note ?? '');
    _dueDate = r?.dueDate;
    _category = r?.categoryKey ?? preset?.category ?? 'maintenance';
    if (_dueDate == null && r == null) {
      final months = preset?.repeatMonths;
      _dueDate = months == null
          ? DateTime.now().add(const Duration(days: 30))
          : _addMonths(DateTime.now(), months);
    }
  }

  String _trim(double value) =>
      value == value.roundToDouble() ? value.toInt().toString() : '$value';

  DateTime _addMonths(DateTime date, int months) {
    final targetMonth = date.month + months;
    return DateTime(date.year, targetMonth, date.day);
  }

  @override
  void dispose() {
    for (final controller in [
      _title,
      _odometer,
      _repeatMonths,
      _repeatKm,
      _advanceDays,
      _note,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() => _dueDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final values = RemindersCompanion(
      id: widget.reminder == null
          ? const Value.absent()
          : Value(widget.reminder!.id),
      vehicleId: Value(widget.vehicleId),
      title: Value(_title.text.trim()),
      categoryKey: Value(_category),
      dueDate: Value(_dueDate),
      dueOdometer: Value(
        double.tryParse(_odometer.text.replaceAll(',', '.')),
      ),
      repeatMonths: Value(int.tryParse(_repeatMonths.text.trim())),
      repeatKm: Value(double.tryParse(_repeatKm.text.replaceAll(',', '.'))),
      advanceDays: Value(int.tryParse(_advanceDays.text.trim()) ?? 14),
      note: Value(_note.text.trim()),
    );

    if (widget.reminder == null) {
      await _repo.insertReminder(values);
    } else {
      await _repo.updateReminder(values);
    }
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  Future<void> _complete() async {
    final reminder = widget.reminder!;
    final fills = await _repo.fillUps(widget.vehicleId);
    final currentOdometer = fills.isEmpty ? 0.0 : fills.last.odometer;

    if (!mounted) return;
    final logCost = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.t('reminder.completeTitle')),
        content: Text(context.t('reminder.logCost')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.t('common.no')),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.t('common.yes')),
          ),
        ],
      ),
    );

    if (logCost == true && mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ExpenseFormScreen(
            vehicleId: widget.vehicleId,
            initialCategory: reminder.categoryKey,
            initialTitle: reminder.title,
          ),
        ),
      );
    }

    final now = DateTime.now();
    final nextDate = reminder.repeatMonths == null
        ? null
        : _addMonths(now, reminder.repeatMonths!);
    final nextOdometer = reminder.repeatKm == null
        ? null
        : currentOdometer + reminder.repeatKm!;
    final hasRepeat = nextDate != null || nextOdometer != null;

    await _repo.updateReminder(
      RemindersCompanion(
        id: Value(reminder.id),
        lastDoneDate: Value(now),
        lastDoneOdometer: Value(currentOdometer),
        dueDate: Value(nextDate),
        dueOdometer: Value(nextOdometer),
        isActive: Value(hasRepeat),
      ),
    );

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.reminder != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.t(isEdit ? 'reminder.edit' : 'reminder.add'),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            TextFormField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: context.t('reminder.name'),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? context.t('reminder.nameRequired')
                  : null,
            ),
            const SizedBox(height: 4),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event_outlined),
              title: Text(context.t('reminder.dueDate')),
              subtitle: Text(
                _dueDate == null
                    ? context.t('reminder.noDue')
                    : context.date(_dueDate!),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_dueDate != null)
                    IconButton(
                      onPressed: () => setState(() => _dueDate = null),
                      icon: const Icon(Icons.close),
                    ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              onTap: _pickDate,
            ),
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
                    decoration: InputDecoration(
                      labelText: context.t('reminder.dueOdometer'),
                      suffixText: 'km',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _advanceDays,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      labelText: context.t('reminder.advanceDays'),
                      suffixText: 'd',
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
                    controller: _repeatMonths,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      labelText: context.t('reminder.repeatMonths'),
                      suffixText: 'm',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _repeatKm,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    decoration: InputDecoration(
                      labelText: context.t('reminder.repeatKm'),
                      suffixText: 'km',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _note,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: context.t('common.notes'),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _save,
              child: Text(context.t('common.save')),
            ),
            if (isEdit) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _complete,
                icon: const Icon(Icons.check),
                label: Text(context.t('reminder.done')),
              ),
              TextButton.icon(
                onPressed: () async {
                  final ok = await confirmDialog(
                    context,
                    title: context.t('common.deleteConfirm'),
                  );
                  if (!ok || !mounted) return;
                  await _repo.deleteReminder(widget.reminder!.id);
                  if (!context.mounted) return;
                  Navigator.of(context).pop(true);
                },
                icon: const Icon(Icons.delete_outline),
                label: Text(context.t('common.delete')),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

