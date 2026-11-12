import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../data/database.dart';
import '../../l10n/strings.dart';
import '../../util/context_format.dart';
import '../../widgets/common.dart';
import 'expense_form_screen.dart';

class ExpensesTab extends StatefulWidget {
  const ExpensesTab({super.key, required this.vehicleId, required this.onAdd});

  final int vehicleId;
  final VoidCallback onAdd;

  @override
  State<ExpensesTab> createState() => _ExpensesTabState();
}

class _ExpensesTabState extends State<ExpensesTab> {
  final _repo = AppState.instance.repo;
  List<ExpenseCategory> _categories = const [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await _repo.categories();
    if (!mounted) return;
    setState(() => _categories = categories);
  }

  ExpenseCategory? _category(String key) {
    for (final category in _categories) {
      if (category.key == key) return category;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Expense>>(
      stream: _repo.watchExpenses(widget.vehicleId),
      builder: (context, snapshot) {
        final expenses = snapshot.data;
        if (expenses == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (expenses.isEmpty) {
          return EmptyState(
            icon: Icons.receipt_long_outlined,
            title: context.t('expense.empty'),
            body: context.t('expense.nameHint'),
            action: FilledButton.icon(
              onPressed: widget.onAdd,
              icon: const Icon(Icons.add),
              label: Text(context.t('expense.add')),
            ),
          );
        }

        final rows = <Object>[];
        String? lastMonth;
        for (final expense in expenses) {
          final month =
              '${expense.date.year}-${expense.date.month.toString().padLeft(2, '0')}';
          if (month != lastMonth) {
            rows.add(expense.date);
            lastMonth = month;
          }
          rows.add(expense);
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          itemCount: rows.length,
          itemBuilder: (context, index) {
            final row = rows[index];
            if (row is DateTime) {
              final monthExpenses = expenses.where(
                (e) => e.date.year == row.year && e.date.month == row.month,
              );
              final total = monthExpenses.fold<double>(
                0,
                (sum, e) => sum + (e.isIncome ? -e.amount : e.amount),
              );
              return Padding(
                padding: EdgeInsets.only(
                  top: index == 0 ? 4 : 18,
                  bottom: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.month(row),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      context.money(total),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }

            final expense = row as Expense;
            final category = _category(expense.categoryKey);
            final color = category?.color ?? 0xFF607D8B;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SectionCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ExpenseFormScreen(
                      vehicleId: widget.vehicleId,
                      expense: expense,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Color(color),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expense.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            [
                              if (category != null)
                                categoryName(context, category),
                              context.date(expense.date),
                              if (expense.odometer != null)
                                '${context.num1(expense.odometer!)} km',
                            ].join(' · '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.money(
                        expense.isIncome ? -expense.amount : expense.amount,
                      ),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: expense.isIncome
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
