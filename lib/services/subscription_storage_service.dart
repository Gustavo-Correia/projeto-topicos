import 'dart:convert';

import 'package:hive/hive.dart';

import '../models/subscription.dart';
import 'subscription_storage.dart';

class SubscriptionStorageService implements SubscriptionStorage {
  static const String _subscriptionsKey = 'subscriptions';
  static const String _initializedKey = 'subscriptions_initialized';
  static const String _boxName = 'subscriptions_box';

  @override
  Future<bool> hasStoredSubscriptions() async {
    try {
      final box = Hive.box<String>(_boxName);
      return box.get(_initializedKey) == 'true';
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<Subscription>> loadSubscriptions() async {
    try {
      final box = Hive.box<String>(_boxName);
      final raw = box.get(_subscriptionsKey);

      if (raw == null || raw.isEmpty) {
        return [];
      }

      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((item) => Subscription.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      try {
        final box = Hive.box<String>(_boxName);
        await box.put(_subscriptionsKey, '[]');
      } catch (_) {}
      return [];
    }
  }

  @override
  Future<void> saveSubscriptions(List<Subscription> subscriptions) async {
    try {
      final box = Hive.box<String>(_boxName);
      final encoded = jsonEncode(subscriptions.map((item) => item.toMap()).toList());
      await box.put(_subscriptionsKey, encoded);
      await box.put(_initializedKey, 'true');
    } catch (_) {
      rethrow;
    }
  }
}
