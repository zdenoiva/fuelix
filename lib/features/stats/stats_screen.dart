import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../data/database.dart';
import '../../domain/consumption.dart';
import '../../l10n/strings.dart';
import '../../theme.dart';
import '../../util/context_format.dart';
import '../../widgets/common.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final _repo = AppState.instance.repo;
  List<Vehicle> _vehicles = const [];
  int? _vehicleId;
  List<FillUp> _fills = const [];
  List<Expense> _expenses = const [];
  List<ExpenseCategory> _categories = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final vehicles = await _repo.vehicles();
    final id = _vehicleId ??
        (vehicles.isEmpty ? null : vehicles.first.id);
    if (id == null) {
      if (!mounted) return;
      setState(() {
        _vehicles = vehicles;
        _loading = false;
      });
      return;
    }
    final fills = await _repo.fillUps(id);
    final expenses = await _repo.expenses(id);
    final categories = await _repo.categories();
    if (!mounted) return;
    setState(() {
      _vehicles = vehicles;
      _vehicleId = id;
      _fills = fills;
      _expenses = expenses;
      _categories = categories;
      _loading = false;
    });
  }

  Future<void> _selectVehicle(int id) async {
    setState(() {
      _vehicleId = id;
      _loading = true;
    });
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_vehicles.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(context.t('stats.title'))),
        body: EmptyState(
          icon: Icons.insights_outlined,
          title: context.t('stats.noData'),
          body: context.t('garage.emptyBody'),
        ),
      );
    }

    final segments = consumptionSegments(
      _fills.map(
        (f) => FillUpPoint(
          id: f.id,
          date: f.date,
          odometer: f.odometer,
          liters: f.liters,
          isFull: f.isFull,
          isMissed: f.isMissed,
          excludeDistance: f.excludeDistance,
        ),
      ),
    );
    final average = averageConsumption(segments);
    final fuelCost = _fills.fold<double>(0, (sum, f) => sum + f.totalPrice);
    final extraCost = _expenses.fold<double>(
      0,
      (sum, e) => sum + (e.isIncome ? -e.amount : e.amount),
    );
    final distance = drivenDistance(
      odometers: _fills.map((f) => f.odometer),
      initialOdometer:
          _vehicles.firstWhere((v) => v.id == _vehicleId).initialOdometer,
    );

    return Scaffold(
      appBar: AppBar(title: Text(context.t('stats.title'))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          if (_vehicles.length > 1)
            DropdownButtonFormField<int>(
              initialValue: _vehicleId,
              decoration: InputDecoration(
                labelText: context.t('garage.addVehicle'),
              ),
              items: [
                for (final vehicle in _vehicles)
                  DropdownMenuItem(
                    value: vehicle.id,
                    child: Text(vehicle.name),
                  ),
              ],
              onChanged: (value) {
                if (value != null) _selectVehicle(value);
              },
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  label: context.t('stats.avgConsumption'),
                  value: average == null ? '–' : context.num1(average),
                  unit: context.t('stats.l100'),
                  icon: Icons.local_gas_station_outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricCard(
                  label: context.t('stats.totalCost'),
                  value: context.roundMoney(fuelCost + extraCost),
                  unit: AppState.instance.currency,
                  icon: Icons.payments_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  label: context.t('stats.totalFuel'),
                  value: context.roundMoney(fuelCost),
                  unit: AppState.instance.currency,
                  icon: Icons.water_drop_outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricCard(
                  label: context.t('stats.costPerKm'),
                  value: distance <= 0
                      ? '–'
                      : context.num2((fuelCost + extraCost) / distance),
                  unit: '/ km',
                  icon: Icons.speed_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (segments.isEmpty)
            SectionCard(
              child: Text(
                context.t('stats.noData'),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else ...[
            _SectionTitle(context.t('stats.consumption')),
            SectionCard(
              child: SizedBox(
                height: 190,
                child: _ConsumptionChart(segments: segments),
              ),
            ),
            const SizedBox(height: 18),
            _SectionTitle(context.t('stats.monthly')),
            SectionCard(
              child: SizedBox(
                height: 180,
                child: _MonthlyChart(
                  fills: _fills,
                  expenses: _expenses,
                ),
              ),
            ),
          ],
          const SizedBox(height: 18),
          _SectionTitle(context.t('stats.byCategory')),
          SectionCard(
            child: Column(
              children: [
                for (final row in _categoryRows())
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        CategoryDot(color: row.color),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            row.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Text(
                          context.money(row.amount),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<({String label, int color, double amount})> _categoryRows() {
    final totals = <String, double>{};
    for (final expense in _expenses) {
      if (expense.isIncome) continue;
      totals.update(
        expense.categoryKey,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }
    final entries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return [
      for (final entry in entries)
        (
          label: (() {
            for (final category in _categories) {
              if (category.key == entry.key) {
                return categoryName(context, category);
              }
            }
            return context.t('category.other');
          })(),
          color: categoryColor(_categories, entry.key),
          amount: entry.value,
        ),
    ];
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
    ),
  );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
  });

  final String label;
  final String value;
  final String unit;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SectionCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: scheme.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConsumptionChart extends StatelessWidget {
  const _ConsumptionChart({required this.segments});

  final List<ConsumptionSegment> segments;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final data = segments.length > 20
        ? segments.sublist(segments.length - 20)
        : segments;
    final spots = <FlSpot>[
      for (var i = 0; i < data.length; i++)
        FlSpot(i.toDouble(), data[i].consumption),
    ];
    final maxValue = data
        .map((s) => s.consumption)
        .fold<double>(1, (a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: (maxValue * 1.25).ceilToDouble(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxValue > 10 ? 5 : 2,
          getDrawingHorizontalLine: (_) => FlLine(
            color: scheme.outlineVariant.withValues(alpha: 0.5),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: maxValue > 10 ? 5 : 2,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => scheme.inverseSurface,
            getTooltipItems: (spots) => [
              for (final spot in spots)
                LineTooltipItem(
                  '${spot.y.toStringAsFixed(1)} l/100 km',
                  TextStyle(color: scheme.onInverseSurface, fontSize: 12),
                ),
            ],
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.25,
            barWidth: 3,
            color: brandGreen,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: brandGreen.withValues(alpha: 0.12),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthlyChart extends StatelessWidget {
  const _MonthlyChart({required this.fills, required this.expenses});

  final List<FillUp> fills;
  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final months = <DateTime>[
      for (var i = 11; i >= 0; i--) DateTime(now.year, now.month - i),
    ];
    final values = <double>[
      for (final month in months)
        fills
                .where(
                  (f) => f.date.year == month.year && f.date.month == month.month,
                )
                .fold<double>(0, (sum, f) => sum + f.totalPrice) +
            expenses
                .where(
                  (e) =>
                      !e.isIncome &&
                      e.date.year == month.year &&
                      e.date.month == month.month,
                )
                .fold<double>(0, (sum, e) => sum + e.amount),
    ];
    final maxValue = values.fold<double>(1, (a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        maxY: maxValue * 1.2,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        alignment: BarChartAlignment.spaceAround,
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= months.length) {
                  return const SizedBox.shrink();
                }
                if (index % 3 != 0 && index != months.length - 1) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${months[index].month}.',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => scheme.inverseSurface,
            getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                BarTooltipItem(
                  '${months[group.x].month}. ${rod.toY.toStringAsFixed(0)}',
                  TextStyle(color: scheme.onInverseSurface, fontSize: 12),
                ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < months.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  color: i == months.length - 1
                      ? brandGreen
                      : brandGreen.withValues(alpha: 0.45),
                  width: 12,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
