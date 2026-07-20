import 'package:assinaturas_ninja/features/subscriptions/model/subscription.dart';

abstract class SubscriptionStorage {
  Future<bool> hasStoredSubscriptions();

  Future<List<Subscription>> loadSubscriptions();

  Future<void> saveSubscriptions(List<Subscription> subscriptions);
}
