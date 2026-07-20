import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:assinaturas_ninja/features/subscriptions/provider/subscription_provider.dart';
import 'package:assinaturas_ninja/features/settings/provider/settings_provider.dart';
import 'package:assinaturas_ninja/routes.dart';
import 'package:assinaturas_ninja/core/theme/app_colors.dart';
import 'package:assinaturas_ninja/core/widgets/brand_mark.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    final settings = context.read<SettingsProvider>();
    await Future.wait([
      settings.loadSettings(),
      context.read<SubscriptionProvider>().loadSubscriptions(),
    ]);
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushReplacementNamed(
      settings.settings.onboardingCompleted
          ? AppRoutes.home
          : AppRoutes.onboarding,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BrandMark(size: 72),
            const SizedBox(height: 20),
            const Text(
              'Assinaturas Ninja',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              'Controle seus gastos recorrentes',
              style: TextStyle(color: theme.muted),
            ),
            const SizedBox(height: 28),
            CircularProgressIndicator(color: theme.green),
          ],
        ),
      ),
    );
  }
}
