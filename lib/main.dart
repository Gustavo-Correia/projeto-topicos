import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'providers/currency_provider.dart';
import 'providers/subscription_provider.dart';
import 'providers/settings_provider.dart';
import 'routes.dart';
import 'services/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<String>('subscriptions_box');
  await Hive.openBox<String>('settings_box');
  Intl.defaultLocale = 'pt_BR';
  runApp(const AssinaturasNinjaApp());
}

class AssinaturasNinjaApp extends StatelessWidget {
  const AssinaturasNinjaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SubscriptionProvider(
            storage: ServiceLocator.subscriptionStorage(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(
            storage: ServiceLocator.settingsStorage(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => CurrencyProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          final theme = settings.activeTheme;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Assinaturas Ninja',
            theme: theme.toThemeData(),
            initialRoute: AppRoutes.splash,
            onGenerateRoute: onGenerateRoute,
          );
        },
      ),
    );
  }
}
