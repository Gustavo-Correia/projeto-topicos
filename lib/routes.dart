import 'package:flutter/material.dart';

import 'package:assinaturas_ninja/features/subscriptions/model/subscription.dart';
import 'package:assinaturas_ninja/features/dashboard/presentation/home_screen.dart';
import 'package:assinaturas_ninja/features/onboarding/presentation/onboarding_screen.dart';
import 'package:assinaturas_ninja/features/onboarding/presentation/splash_screen.dart';
import 'package:assinaturas_ninja/features/subscriptions/presentation/subscription_detail_screen.dart';
import 'package:assinaturas_ninja/features/subscriptions/presentation/subscription_form_screen.dart';

/// Named route constants used across the app.
abstract class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const subscriptionDetail = '/subscription-detail';
  static const subscriptionForm = '/subscription-form';
}

/// Central route generator — makes navigation explicit and testable.
Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.splash:
      return MaterialPageRoute<void>(
        builder: (_) => const SplashScreen(),
        settings: settings,
      );

    case AppRoutes.onboarding:
      return MaterialPageRoute<void>(
        builder: (_) => const OnboardingScreen(),
        settings: settings,
      );

    case AppRoutes.home:
      return MaterialPageRoute<void>(
        builder: (_) => const HomeScreen(),
        settings: settings,
      );

    case AppRoutes.subscriptionDetail:
      final id = settings.arguments as String;
      return MaterialPageRoute<void>(
        builder: (_) => SubscriptionDetailScreen(subscriptionId: id),
        settings: settings,
      );

    case AppRoutes.subscriptionForm:
      final subscription = settings.arguments as Subscription?;
      return MaterialPageRoute<void>(
        builder: (_) => SubscriptionFormScreen(subscription: subscription),
        settings: settings,
      );

    default:
      return MaterialPageRoute<void>(
        builder: (_) => const SplashScreen(),
        settings: settings,
      );
  }
}
