import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:assinaturas_ninja/features/dashboard/service/currency_api_service.dart';

/// Provider that fetches financial rates from public APIs.
///
/// The Selic rate powers the savings insight on the dashboard and is fetched
/// automatically. The USD→BRL rate is only fetched when the user explicitly
/// switches the display currency to USD in settings. Both return `null` when
/// offline, so the UI degrades gracefully without network.
class CurrencyProvider extends ChangeNotifier {
  CurrencyProvider({CurrencyApiService? api}) : _api = api ?? CurrencyApiService();

  final CurrencyApiService _api;

  double? _usdBrlRate;
  double? _selicRate;
  bool _selicLoaded = false;
  bool _usdLoaded = false;

  double? get usdBrlRate => _usdBrlRate;
  double? get selicRate => _selicRate;
  bool get selicLoaded => _selicLoaded;
  bool get usdLoaded => _usdLoaded;

  /// Calculates the projected return of investing [monthlyAmount] at the
  /// current Selic rate for 12 months (monthly compound).
  double? projectedReturn12m(double monthlyAmount) {
    final selic = _selicRate;
    if (selic == null || monthlyAmount <= 0) return null;

    final monthlyRate = pow(1 + selic / 100, 1 / 12).toDouble() - 1;
    final futureValue = monthlyAmount * (pow(1 + monthlyRate, 12) - 1) / monthlyRate;
    return futureValue;
  }

  /// Fetches the annual Selic rate (Banco Central). Called on dashboard load.
  Future<void> fetchSelic() async {
    _selicRate = await _api.fetchSelicRate();
    _selicLoaded = true;
    notifyListeners();
  }

  /// Fetches the USD→BRL rate (AwesomeAPI). Called only when the user
  /// switches the display currency to USD in settings.
  Future<void> fetchUsdRate() async {
    _usdBrlRate = await _api.fetchUsdBrlRate();
    _usdLoaded = true;
    notifyListeners();
  }
}
