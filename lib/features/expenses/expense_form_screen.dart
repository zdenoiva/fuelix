import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_state.dart';
import '../../data/database.dart';
import '../../l10n/strings.dart';
import '../../services/receipt_scanner.dart';
import '../../util/context_format.dart';
import '../../widgets/common.dart';
import '../fillups/receipt_scanner_screen.dart';

class ExpenseFormScreen extends StatefulWidget {
  const ExpenseFormScreen({
    super.key,
    required this.vehicleId,
    this.expense,
    this.initialCategory,
    this.initialTitle,
  });

  final int vehicleId;
  final Expense? expense;
  final String? initialCategory;
  final String? initialTitle;

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repo = AppState.instance.repo;

  late final TextEditingController _title;
  late final TextEditingController _amount;
  late final TextEditingController _odometer;
  late final TextEditingController _note;

  late DateTime _date;
  late String _category;
  bool _isIncome = false;
  List<ExpenseCategory> _categories = const [];

  @override
  void initState() {
    super.initState();
    final e = widget.expense;
    _title = TextEditingController(
      text: e?.title ?? widget.initialTitle ?? '',
    );
    _amount = TextEditingController(
      text: e == null ? '' : _trim(e.amount),
    );
    _odometer = TextEditingController(
      text: e?.odometer == null ? '' : _trim(e!.odometer!),
    );
    _note = TextEditingController(text: e?.note ?? '');
    _date = e?.date ?? DateTime.now();
    _category = e?.categoryKey ?? widget.initialCategory ?? 'service';
    _isIncome = e?.isIncome ?? false;
    _loadCategories();
  }

  String _trim(double value) =>
      value == value.roundToDouble() ? value.toInt().toString() : '$value';

  Future<void> _loadCategories() async {
    final categories = await _repo.categories();
    if (!mounted) return;
    setState(() => _categories = categories);
  }

  @override
  void dispose() {
    for (final controller in [_title, _amount, _odometer, _note]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _scanReceipt() async {
    final data = await Navigator.of(context).push<ReceiptData>(
      MaterialPageRoute<ReceiptData>(
        builder: (_) =>
            const ReceiptScannerScreen(mode: ReceiptScanMode.expense),
      ),
    );
    if (data == null || !mounted) return;

    setState(() {
      final merchant = data.merchant?.trim();
      if (merchant != null && merchant.isNotEmpty) {
        _title.text = merchant;
      } else if (data.items.isNotEmpty) {
        _title.text = data.items.first.name;
      }
      if (data.total != null && data.total! > 0) {
        _amount.text = data.total!.toStringAsFixed(2);
      }
      if (data.date != null) _date = data.date!;
      if (data.items.isNotEmpty && _note.text.trim().isEmpty) {
        _note.text = data.items.map(_itemLine).join('\n');
      }
    });
    if (!_categories.any((category) => category.key == _category) &&
        _categories.isNotEmpty) {
      _category = _categories.first.key;
    }
    showSnack(context, context.t('qr.scanned'));
  }

  String _itemLine(ReceiptLine item) {
    final quantity = item.quantity == item.quantity.roundToDouble()
        ? item.quantity.toStringAsFixed(0)
        : context.num1(item.quantity);
    return '${item.name}  $quantity×  ${context.money(item.unitPrice)}'
        '  = ${context.money(item.total)}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1990),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked == null) return;
    setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.tryParse(_amount.text.replaceAll(',', '.')) ?? 0;
    final odometer = double.tryParse(_odometer.text.replaceAll(',', '.'));
    final values = ExpensesCompanion(
      id: widget.expense == null
          ? const Value.absent()
          : Value(widget.expense!.id),
      vehicleId: Value(widget.vehicleId),
      title: Value(_title.text.trim()),
      date: Value(_date),
      odometer: Value(odometer),
      categoryKey: Value(_category),
      amount: Value(amount),
      note: Value(_note.text.trim()),
      isIncome: Value(_isIncome),
    );

    if (widget.expense == null) {
      await _repo.insertExpense(values);
    } else {
      await _repo.updateExpense(values);
    }
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.t(widget.expense == null ? 'expense.add' : 'expense.edit'),
        ),
        actions: [
          IconButton(
            tooltip: context.t('expense.scan'),
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
            TextFormField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: context.t('expense.name'),
                hintText: context.t('expense.nameHint'),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? context.t('reminder.nameRequired')
                  : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _amount,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    decoration: InputDecoration(
                      labelText: context.t('expense.amount'),
                      suffixText: '${AppState.instance.currency} ',
                    ),
                    validator: (value) {
                      final parsed = double.tryParse(
                        (value ?? '').replaceAll(',', '.'),
                      );
                      return parsed == null
                          ? context.t('expense.amountRequired')
                          : null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
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
                      labelText: context.t('common.odometer'),
                      hintText: context.t('common.optional'),
                      suffixText: 'km',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              context.t('expense.category'),
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final category in _categories)
                  FilterChip(
                    selected: _category == category.key,
                    avatar: CategoryDot(color: category.color, size: 9),
                    label: Text(categoryName(context, category)),
                    onSelected: (_) =>
                        setState(() => _category = category.key),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.t('expense.income')),
              value: _isIncome,
              onChanged: (value) => setState(() => _isIncome = value),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event_outlined),
              title: Text(context.t('fillup.date')),
              subtitle: Text(context.date(_date)),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickDate,
            ),
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
            if (widget.expense != null) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () async {
                  final ok = await confirmDialog(
                    context,
                    title: context.t('common.deleteConfirm'),
                    message: context.t('expense.deleteConfirm'),
                  );
                  if (!ok || !mounted) return;
                  await _repo.deleteExpense(widget.expense!.id);
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

