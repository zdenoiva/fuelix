import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_state.dart';
import 'features/garage/garage_screen.dart';
import 'features/stats/stats_screen.dart';
import 'l10n/strings.dart';
import 'services/notifications.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppState.instance.init();
  unawaited(NotificationService.instance.init());
  runApp(const FuelixApp());
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
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [GarageScreen(), StatsScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
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
        ],
      ),
    );
  }
}
