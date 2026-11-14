import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../data/database.dart';
import '../../data/repository.dart';
import '../../l10n/strings.dart';
import '../../theme.dart';
import '../../util/context_format.dart';
import '../../util/format.dart';
import '../../widgets/common.dart';
import '../expenses/expense_form_screen.dart';
import '../expenses/expenses_tab.dart';
import '../fillups/fillup_form_screen.dart';
import '../fillups/fillup_list_tab.dart';
import '../reminders/reminder_form_screen.dart';
import '../reminders/reminders_tab.dart';
import 'vehicle_form_screen.dart';

class VehicleDetailScreen extends StatefulWidget {
  const VehicleDetailScreen({super.key, required this.vehicleId});

  final int vehicleId;

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen>
    with SingleTickerProviderStateMixin {
  final _repo = AppState.instance.repo;
  late final TabController _tabs = TabController(length: 4, vsync: this)
    ..addListener(_onTabChanged);
  Vehicle? _vehicle;

  @override
  void initState() {
    super.initState();
    _loadVehicle();
  }

  void _onTabChanged() {
    if (!_tabs.indexIsChanging) setState(() {});
  }

  Future<void> _loadVehicle() async {
    final vehicle = await _repo.vehicle(widget.vehicleId);
    if (!mounted) return;
    setState(() => _vehicle = vehicle);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _edit() async {
    final vehicle = _vehicle;
    if (vehicle == null) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => VehicleFormScreen(vehicle: vehicle),
      ),
    );
    await _loadVehicle();
  }

  Future<void> _addFillUp() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FillUpFormScreen(vehicleId: widget.vehicleId),
      ),
    );
  }

  Future<void> _addExpense() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ExpenseFormScreen(vehicleId: widget.vehicleId),
      ),
    );
  }

  Future<void> _addReminder() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ReminderFormScreen(vehicleId: widget.vehicleId),
      ),
    );
  }

  Future<void> _archive() async {
    final vehicle = _vehicle;
    if (vehicle == null) return;
    final ok = await confirmDialog(
      context,
      title: context.t('garage.archive'),
      confirmLabel: context.t('common.yes'),
    );
    if (!ok) return;
    await _repo.updateVehicle(
      VehiclesCompanion(id: Value(vehicle.id), isArchived: const Value(true)),
    );
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final vehicle = _vehicle;
    if (vehicle == null) return;
    final ok = await confirmDialog(
      context,
      title: context.t('common.deleteConfirm'),
      message: context.t('vehicle.deleteConfirm'),
    );
    if (!ok) return;
    await _repo.deleteVehicle(vehicle.id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = _vehicle;
    return Scaffold(
      appBar: AppBar(
        title: Text(vehicle?.name ?? ''),
        actions: [
          if (vehicle != null)
            IconButton(
              tooltip: context.t('garage.favorite'),
              onPressed: () async {
                if (vehicle.isFavorite) {
                  await _repo.clearFavoriteVehicle();
                } else {
                  await _repo.setFavoriteVehicle(vehicle.id);
                }
                await _loadVehicle();
              },
              icon: Icon(
                vehicle.isFavorite ? Icons.star : Icons.star_border,
              ),
            ),
          if (vehicle != null)
            IconButton(
              onPressed: _edit,
              icon: const Icon(Icons.edit_outlined),
            ),
          if (vehicle != null)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'archive') _archive();
                if (value == 'delete') _delete();
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'archive',
                  child: Text(context.t('garage.archive')),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text(context.t('common.delete')),
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: switch (_tabs.index) {
          2 => _addExpense,
          3 => _addReminder,
          _ => _addFillUp,
        },
        icon: Icon(switch (_tabs.index) {
          2 => Icons.receipt_long_outlined,
          3 => Icons.notifications_active_outlined,
          _ => Icons.local_gas_station_outlined,
        }),
        label: Text(
          switch (_tabs.index) {
            2 => context.t('expense.add'),
            3 => context.t('reminder.add'),
            _ => context.t('fillup.add'),
          },
        ),
      ),
      body: vehicle == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                TabBar(
                  controller: _tabs,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: context.t('tab.overview')),
                    Tab(text: context.t('fillup.title')),
                    Tab(text: context.t('expense.title')),
                    Tab(text: context.t('tab.service')),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabs,
                    children: [
                      _OverviewTab(
                        vehicle: vehicle,
                        repo: _repo,
                        onAddFillUp: _addFillUp,
                        onAddExpense: _addExpense,
                        onAddReminder: _addReminder,
                      ),
                      FillUpListTab(
                        vehicleId: vehicle.id,
                        onAdd: _addFillUp,
                      ),
                      ExpensesTab(
                        vehicleId: vehicle.id,
                        onAdd: _addExpense,
                      ),
                      RemindersTab(
                        vehicleId: vehicle.id,
                        onAdd: _addReminder,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({
    required this.vehicle,
    required this.repo,
    required this.onAddFillUp,
    required this.onAddExpense,
    required this.onAddReminder,
  });

  final Vehicle vehicle;
  final FuelixRepository repo;
  final VoidCallback onAddFillUp;
  final VoidCallback onAddExpense;
  final VoidCallback onAddReminder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FillUp>>(
      stream: repo.watchFillUps(vehicle.id),
      builder: (context, fillSnapshot) {
        final fills = fillSnapshot.data ?? const <FillUp>[];
        final signature = fills.fold<int>(0, (sum, fill) => sum + fill.id);
        return FutureBuilder<VehicleStats>(
          key: ValueKey('overview-$signature'),
          future: repo.stats(vehicle.id),
          builder: (context, statsSnapshot) {
            final stats = statsSnapshot.data;
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              children: [
                _SummaryCard(vehicle: vehicle, stats: stats),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _QuickAction(
                        icon: Icons.local_gas_station_outlined,
                        label: context.t('fillup.add'),
                        onTap: onAddFillUp,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _QuickAction(
                        icon: Icons.build_outlined,
                        label: context.t('tab.service'),
                        onTap: onAddReminder,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _QuickAction(
                        icon: Icons.receipt_long_outlined,
                        label: context.t('expense.add'),
                        onTap: onAddExpense,
                      ),
                    ),
                  ],
                ),
                if (stats?.nextReminder != null) ...[
                  const SizedBox(height: 12),
                  SectionCard(
                    onTap: onAddReminder,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.notifications_active_outlined,
                          color: Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stats!.nextReminder!.title,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                stats.nextReminder!.dueDate == null
                                    ? context.t('reminder.noDue')
                                    : context.date(
                                        stats.nextReminder!.dueDate!,
                                      ),
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
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.t('fillup.title'),
                        style: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    TextButton(
                      onPressed: onAddFillUp,
                      child: Text(context.t('common.add')),
                    ),
                  ],
                ),
                if (fills.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      context.t('garage.noData'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                for (final fill in fills.take(3))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SectionCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => FillUpFormScreen(
                            vehicleId: vehicle.id,
                            fillUp: fill,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fill.stationName.isEmpty
                                      ? context.t('fillup.single')
                                      : fill.stationName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${context.date(fill.date)} · '
                                  '${context.num1(fill.liters)} l',
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
                          Text(
                            context.money(fill.totalPrice),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.vehicle, required this.stats});

  final Vehicle vehicle;
  final VehicleStats? stats;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final latest = stats?.latestSegment;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primary, brandGreen.withValues(alpha: 0.75)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  [
                    if (vehicle.plate.isNotEmpty) vehicle.plate,
                    context.t('fuel.${vehicle.fuelType}'),
                  ].join(' · '),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: scheme.onPrimary.withValues(alpha: 0.85),
                  ),
                ),
              ),
              Text(
                '${context.num1(stats?.distanceKm ?? 0)} km',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: scheme.onPrimary.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            latest == null
                ? '–'
                : '${context.num1(latest.consumption)} ${context.t('stats.l100')}',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: scheme.onPrimary,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.2,
            ),
          ),
          Text(
            context.t('garage.lastConsumption'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: scheme.onPrimary.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: context.t('stats.avgConsumption'),
                  value: stats?.averageConsumption == null
                      ? '–'
                      : context.num1(stats!.averageConsumption!),
                ),
              ),
              Expanded(
                child: _MiniStat(
                  label: context.t('garage.totalCost'),
                  value: context.roundMoney(stats?.totalCost ?? 0),
                ),
              ),
              Expanded(
                child: _MiniStat(
                  label: context.t('stats.costPerKm'),
                  value: stats?.costPerKm == null
                      ? '–'
                      : '${context.num2(stats!.costPerKm!)} '
                            '${currencySymbol(AppState.instance.currency)}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: scheme.onPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: scheme.onPrimary.withValues(alpha: 0.75),
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: scheme.primary, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
