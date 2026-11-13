import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_state.dart';
import 'data/database.dart';
import 'features/fillups/fillup_form_screen.dart';
import 'features/fillups/receipt_scanner_screen.dart';
import 'features/garage/garage_screen.dart';
import 'features/stats/stats_screen.dart';
import 'features/vehicle/vehicle_detail_screen.dart';
import 'features/vehicle/vehicle_form_screen.dart';
import 'l10n/strings.dart';
import 'services/backup_service.dart';
import 'services/location_service.dart';
import 'services/notifications.dart';
import 'services/receipt_scanner.dart';
import 'services/shortcut_service.dart';
import 'theme.dart';
import 'widgets/glass.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppState.instance.init();
  unawaited(NotificationService.instance.init());
  unawaited(BackupService.dailyBackup());
  runApp(const FuelixApp());
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ShortcutService.init(startWidgetFillUp);
  });
}

/// Home screen widget flow: scan the receipt QR, resolve the current station by
/// GPS and open a prefilled fill-up form.
Future<void> startWidgetFillUp() async {
  final navigator = rootNavigatorKey.currentState;
  if (navigator == null) return;
  try {
    final repo = AppState.instance.repo;
    final vehicles = await repo.vehicles();
    if (vehicles.isEmpty) {
      await navigator.push(
        MaterialPageRoute<void>(builder: (_) => const VehicleFormScreen()),
      );
      return;
    }

    final favorite = await repo.favoriteVehicle();
    final vehicle = favorite ?? vehicles.first;
    final receipt = await navigator.push<ReceiptData>(
      MaterialPageRoute<ReceiptData>(
        builder: (_) => const ReceiptScannerScreen(),
      ),
    );
    if (receipt == null) return;

    final last = await repo.lastFillUp(vehicle.id);
    final location = await LocationService.instance.locate(
      vehicleId: vehicle.id,
    );
    final receiptStation = receipt.stationName;
    await navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => FillUpFormScreen(
          vehicleId: vehicle.id,
          draft: receipt,
          prefilledOdometer: last?.odometer ??
              (vehicle.initialOdometer > 0 ? vehicle.initialOdometer : null),
          initialStation:
              (receiptStation != null && receiptStation.isNotEmpty)
                  ? receiptStation
                  : location?.stationName,
          initialLatitude: location?.latitude,
          initialLongitude: location?.longitude,
        ),
      ),
    );
  } catch (_) {
    // A failed shortcut must never crash the running app.
  }
}

class FuelixApp extends StatelessWidget {
  const FuelixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        return MaterialApp(
          title: 'Fuelix',
          navigatorKey: rootNavigatorKey,
          debugShowCheckedModeBanner: false,
          locale: state.locale,
          supportedLocales: Strings.supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: buildTheme(Brightness.light),
          darkTheme: buildTheme(Brightness.dark),
          themeMode: state.themeMode,
          builder: (context, child) => AppBackground(
            child: child ?? const SizedBox.shrink(),
          ),
          home: const RootShell(),
        );
      },
    );
  }
}

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  final _repo = AppState.instance.repo;
  StreamSubscription<Vehicle?>? _favoriteSubscription;
  Vehicle? _favorite;
  int _index = 0;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _favoriteSubscription = _repo.watchFavoriteVehicle().listen((vehicle) {
      if (!mounted) return;
      setState(() {
        final changed = vehicle?.id != _favorite?.id;
        _favorite = vehicle;
        if (changed || !_loaded) _index = 0;
        _loaded = true;
      });
    });
  }

  @override
  void dispose() {
    _favoriteSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favorite = _favorite;
    final destinations = <Widget>[
      if (favorite != null)
        NavigationDestination(
          icon: const Icon(Icons.star_border),
          selectedIcon: const Icon(Icons.star),
          label: favorite.name,
        ),
      NavigationDestination(
        icon: const Icon(Icons.directions_car_outlined),
        selectedIcon: const Icon(Icons.directions_car_filled),
        label: context.t('nav.garage'),
      ),
      NavigationDestination(
        icon: const Icon(Icons.insights_outlined),
        selectedIcon: const Icon(Icons.insights),
        label: context.t('nav.stats'),
      ),
    ];

    final index = _index.clamp(0, destinations.length - 1);
    final screens = <Widget>[
      if (favorite != null)
        VehicleDetailScreen(
          key: ValueKey('favorite-${favorite.id}'),
          vehicleId: favorite.id,
        ),
      const GarageScreen(),
      const StatsScreen(),
    ];

    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: destinations,
      ),
    );
  }
}
