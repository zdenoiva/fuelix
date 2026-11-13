import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../data/database.dart';
import '../../data/repository.dart';
import '../../l10n/strings.dart';
import '../../util/context_format.dart';
import '../../util/format.dart';
import '../../widgets/common.dart';
import '../settings/settings_screen.dart';
import '../vehicle/vehicle_detail_screen.dart';
import '../vehicle/vehicle_form_screen.dart';

class GarageScreen extends StatefulWidget {
  const GarageScreen({super.key});

  @override
  State<GarageScreen> createState() => _GarageScreenState();
}

class _GarageScreenState extends State<GarageScreen> {
  final _repo = AppState.instance.repo;

  Future<void> _addVehicle() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const VehicleFormScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuelix'),
        actions: [
          IconButton(
            tooltip: context.t('common.settings'),
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addVehicle,
        icon: const Icon(Icons.add),
        label: Text(context.t('garage.addVehicle')),
      ),
      body: StreamBuilder<List<Vehicle>>(
        stream: _repo.watchVehicles(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final vehicles = snapshot.data!;
          if (vehicles.isEmpty) {
            return EmptyState(
              icon: Icons.directions_car_outlined,
              title: context.t('garage.emptyTitle'),
              body: context.t('garage.emptyBody'),
              action: FilledButton.icon(
                onPressed: _addVehicle,
                icon: const Icon(Icons.add),
                label: Text(context.t('garage.addVehicle')),
              ),
            );
          }
          return StreamBuilder<List<FillUp>>(
            stream: _repo.watchAllFillUps(),
            builder: (context, fillSnapshot) {
              return StreamBuilder<List<Expense>>(
                stream: _repo.watchAllExpenses(),
                builder: (context, expenseSnapshot) {
                  final signature =
                      (fillSnapshot.data ?? const <FillUp>[]).fold<int>(
                        0,
                        (sum, fill) => sum + fill.id,
                      ) +
                      (expenseSnapshot.data ?? const <Expense>[]).fold<int>(
                        0,
                        (sum, expense) => sum + expense.id,
                      );
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: vehicles.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => _VehicleCard(
                      vehicle: vehicles[index],
                      repo: _repo,
                      refreshKey: signature,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  const _VehicleCard({
    required this.vehicle,
    required this.repo,
    required this.refreshKey,
  });

  final Vehicle vehicle;
  final FuelixRepository repo;
  final int refreshKey;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FutureBuilder<VehicleStats>(
      key: ValueKey('${vehicle.id}-$refreshKey'),
      future: repo.stats(vehicle.id),
      builder: (context, snapshot) {
        final stats = snapshot.data;
        return SectionCard(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => VehicleDetailScreen(vehicleId: vehicle.id),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      vehicle.fuelType == 'electric'
                          ? Icons.electric_car_outlined
                          : Icons.directions_car_filled_outlined,
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          [
                            if (vehicle.plate.isNotEmpty) vehicle.plate,
                            if (vehicle.make.isNotEmpty) vehicle.make,
                            if (vehicle.model.isNotEmpty) vehicle.model,
                          ].join(' · '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: StatBlock(
                      label: context.t('garage.lastConsumption'),
                      value: stats?.latestSegment == null
                          ? '–'
                          : '${context.num1(stats!.latestSegment!.consumption)} ${context.t('stats.l100')}',
                      sub: stats == null || stats.fillUpCount == 0
                          ? context.t('garage.noData')
                          : '${context.num1(stats.distanceKm)} ${context.t('common.km')}',
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    color: scheme.outlineVariant,
                  ),
                  Expanded(
                    child: StatBlock(
                      label: context.t('garage.totalCost'),
                      value: stats == null
                          ? '–'
                          : context.roundMoney(stats.totalCost),
                      sub: stats?.costPerKm == null
                          ? null
                          : '${context.num2(stats!.costPerKm!)} '
                                '${currencySymbol(AppState.instance.currency)} / ${context.t('common.km')}',
                    ),
                  ),
                ],
              ),
              if (stats?.nextReminder != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.notifications_active_outlined,
                      size: 15,
                      color: scheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${context.t('garage.nextService')}: ${stats!.nextReminder!.title}'
                        '${stats.nextReminder!.dueDate == null ? '' : ' · ${context.date(stats.nextReminder!.dueDate!)}'}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
