import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../data/database.dart';
import '../../domain/consumption.dart';
import '../../l10n/strings.dart';
import '../../theme.dart';
import '../../util/context_format.dart';
import '../../util/format.dart';
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
  int? _year;
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
    final id = _vehicleId ?? (vehicles.isEmpty ? null : vehicles.first.id);
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
      _year = null;
      _loading = true;
    });
    await _load();
  }

  List<DateTime> _months() {
    if (_year != null) {
      return [for (var month = 1; month <= 12; month++) DateTime(_year!, month)];
    }
    final now = DateTime.now();
    return [
      for (var i = 11; i >= 0; i--) DateTime(now.year, now.month - i),
    ];
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

    final segments = consumptionSegments(_fills.map(_point));
    final periodSegments = segments
        .where((segment) => _year == null || segment.date.year == _year)
        .toList();
    final periodFills = _fills
        .where((fill) => _year == null || fill.date.year == _year)
        .toList();
    final periodExpenses = _expenses
        .where((expense) => _year == null || expense.date.year == _year)
        .toList();

    final average = averageConsumption(periodSegments);
    final fuelCost = periodFills.fold<double>(0, (sum, f) => sum + f.totalPrice);
    final extraCost = periodExpenses.fold<double>(
      0,
      (sum, e) => sum + (e.isIncome ? -e.amount : e.amount),
    );
    final distance = periodSegments.fold<double>(
      0,
      (sum, segment) => sum + segment.distanceKm,
    );
    final totalCost = fuelCost + extraCost;
    final categoryRows = _categoryRows(periodExpenses);
    final months = _months();
    final monthlyCost = _monthlyCost(months, periodFills, periodExpenses);
    final monthlyKm = _monthlyKm(months, periodSegments);
    final years = _availableYears();

    return Scaffold(
      appBar: AppBar(title: Text(context.t('stats.title'))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          if (_vehicles.length > 1) ...[
            DropdownButtonFormField<int>(
              initialValue: _vehicleId,
              decoration: InputDecoration(
                labelText: context.t('stats.vehicle'),
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
            const SizedBox(height: 10),
          ],
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ChoiceChip(
                  label: Text(context.t('stats.allYears')),
                  selected: _year == null,
                  onSelected: (_) => setState(() => _year = null),
                ),
                for (final year in years) ...[
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: Text('$year'),
                    selected: _year == year,
                    onSelected: (_) => setState(() => _year = year),
                  ),
                ],
              ],
            ),
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
                  value: context.roundMoney(totalCost),
                  unit: '',
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
                  unit: '',
                  icon: Icons.water_drop_outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricCard(
                  label: context.t('stats.costPerKm'),
                  value: distance <= 0
                      ? '–'
                      : context.num2(totalCost / distance),
                  unit: distance <= 0
                      ? '/ km'
                      : '${currencySymbol(AppState.instance.currency)} / km',
                  icon: Icons.speed_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (periodSegments.isEmpty)
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
                child: _ConsumptionChart(segments: periodSegments),
              ),
            ),
            const SizedBox(height: 18),
            _SectionTitle(context.t('stats.monthly')),
            SectionCard(
              child: SizedBox(
                height: 180,
                child: _BarChart(
                  months: months,
                  values: monthlyCost,
                  suffix: AppState.instance.currency,
                ),
              ),
            ),
            const SizedBox(height: 18),
            _SectionTitle(context.t('stats.kmMonthly')),
            SectionCard(
              child: SizedBox(
                height: 180,
                child: _BarChart(
                  months: months,
                  values: monthlyKm,
                  suffix: 'km',
                  color: const Color(0xFF3B82F6),
                ),
              ),
            ),
          ],
          if (categoryRows.isNotEmpty) ...[
            const SizedBox(height: 18),
            _SectionTitle(context.t('stats.byCategory')),
            SectionCard(
              child: Column(
                children: [
                  for (final row in categoryRows)
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
        ],
      ),
    );
  }

  FillUpPoint _point(FillUp fill) => FillUpPoint(
    id: fill.id,
    date: fill.date,
    odometer: fill.odometer,
    liters: fill.liters,
    isFull: fill.isFull,
    isMissed: fill.isMissed,
    excludeDistance: fill.excludeDistance,
  );

  List<int> _availableYears() {
    final years = <int>{
      for (final fill in _fills) fill.date.year,
      for (final expense in _expenses) expense.date.year,
    }.toList()
      ..sort((a, b) => b.compareTo(a));
    return years;
  }

  List<double> _monthlyCost(
    List<DateTime> months,
    List<FillUp> fills,
    List<Expense> expenses,
  ) {
    return [
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
  }

  List<double> _monthlyKm(
    List<DateTime> months,
    List<ConsumptionSegment> segments,
  ) {
    return [
      for (final month in months)
        segments
            .where(
              (s) => s.date.year == month.year && s.date.month == month.month,
            )
            .fold<double>(0, (sum, s) => sum + s.distanceKm),
    ];
  }

  List<({String label, int color, double amount})> _categoryRows(
    List<Expense> expenses,
  ) {
    final totals = <String, double>{};
    for (final expense in expenses) {
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
          label: () {
            for (final category in _categories) {
              if (category.key == entry.key) {
                return categoryName(context, category);
              }
            }
            return context.t('category.other');
          }(),
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
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
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

class _BarChart extends StatelessWidget {
  const _BarChart({
    required this.months,
    required this.values,
    required this.suffix,
    this.color = brandGreen,
  });

  final List<DateTime> months;
  final List<double> values;
  final String suffix;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final maxValue = values.fold<double>(1, (a, b) => a > b ? a : b);
    final step = months.length > 12 ? 3 : 2;

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
                if (index % step != 0 && index != months.length - 1) {
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
                  '${months[group.x].month}. ${rod.toY.toStringAsFixed(0)} $suffix',
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
                  color: values[i] == 0
                      ? color.withValues(alpha: 0.15)
                      : color.withValues(alpha: 0.85),
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
