import 'dart:math';

import 'package:flutter/foundation.dart';

import '../services/currency_api_service.dart';

/// Provider that fetches financial rates (USD→BRL and Selic) once.
///
/// Silently returns `null` when offline — the UI simply hides the
/// related widgets, keeping the app fully functional without network.
class CurrencyProvider extends ChangeNotifier {
  CurrencyProvider({CurrencyApiService? api}) : _api = api ?? CurrencyApiService();

  final CurrencyApiService _api;

  double? _usdBrlRate;
  double? _selicRate;
  bool _loaded = false;

  double? get usdBrlRate => _usdBrlRate;
  double? get selicRate => _selicRate;
  bool get getLoaded => _loaded;

  /// Calculates the projected return of investing [monthlyAmount] at the
  /// current Selic rate for 12 months (monthly compound).
  double? projectedReturn12m(double monthlyAmount) {
    final selic = _selicRate;
    if (selic == null || monthlyAmount <= 0) return null;

    final monthlyRate = pow(1 + selic / 100, 1 / 12).toDouble() - 1;
    final futureValue = monthlyAmount * (pow(1 + monthlyRate, 12) - 1) / monthlyRate;
    return futureValue;
  }

  Future<void> fetchRate() async {
    final results = await Future.wait([
      _api.fetchUsdBrlRate(),
      _api.fetchSelicRate(),
    ]);
    _usdBrlRate = results[0];
    _selicRate = results[1];
    _loaded = true;
    notifyListeners();
  }
}
