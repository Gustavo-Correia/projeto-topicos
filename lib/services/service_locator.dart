import 'settings_storage.dart';
import 'settings_storage_service.dart';
import 'subscription_storage.dart';
import 'subscription_storage_service.dart';

/// Central service locator — explicit dependency injection.
///
/// Wires abstract storage interfaces to their concrete implementations.
/// Providers receive these via constructor injection, allowing tests
/// to substitute fakes without touching production code.
abstract class ServiceLocator {
  static SubscriptionStorage subscriptionStorage() => SubscriptionStorageService();

  static SettingsStorage settingsStorage() => SettingsStorageService();
}
