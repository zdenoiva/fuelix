import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../data/database.dart';
import '../../domain/consumption.dart';
import '../../l10n/strings.dart';
import '../../theme.dart';
import '../../util/context_format.dart';
import '../../widgets/common.dart';
import 'fillup_form_screen.dart';

class FillUpListTab extends StatelessWidget {
  const FillUpListTab({
    super.key,
    required this.vehicleId,
    required this.onAdd,
  });

  final int vehicleId;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final repo = AppState.instance.repo;
    return StreamBuilder<List<FillUp>>(
      stream: repo.watchFillUps(vehicleId),
      builder: (context, snapshot) {
        final fills = snapshot.data;
        if (fills == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (fills.isEmpty) {
          return EmptyState(
            icon: Icons.local_gas_station_outlined,
            title: context.t('garage.noData'),
            body: context.t('fillup.fullTankHelp'),
            action: FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: Text(context.t('fillup.add')),
            ),
          );
        }

        final segments = consumptionSegments(
          fills.map(
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
        final byId = {for (final s in segments) s.fillUpId: s};

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          itemCount: fills.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final fill = fills[index];
            final segment = byId[fill.id];
            return _FillUpTile(
              fill: fill,
              segment: segment,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => FillUpFormScreen(
                    vehicleId: vehicleId,
                    fillUp: fill,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _FillUpTile extends StatelessWidget {
  const _FillUpTile({
    required this.fill,
    required this.segment,
    required this.onTap,
  });

  final FillUp fill;
  final ConsumptionSegment? segment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${fill.date.day}.',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${fill.date.month}.',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 0.9,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fill.stationName.isEmpty
                      ? context.t('fillup.title')
                      : fill.stationName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${context.num1(fill.liters)} l · ${context.money(fill.totalPrice)} · '
                  '${context.num1(fill.odometer)} km',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (segment != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  context.num1(segment!.consumption),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: segment!.reliable ? brandGreen : scheme.error,
                    letterSpacing: -0.4,
                  ),
                ),
                Text(
                  context.t('stats.l100'),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            )
          else if (!fill.isFull)
            Text(
              context.t('fillup.notFull'),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}
