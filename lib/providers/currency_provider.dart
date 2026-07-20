import 'package:flutter/foundation.dart';

import '../services/currency_api_service.dart';

/// Lightweight provider that fetches the USD→BRL exchange rate once.
///
/// Silently returns `null` when offline — the UI simply hides the
/// currency widget, keeping the app fully functional without network.
class CurrencyProvider extends ChangeNotifier {
  CurrencyProvider({CurrencyApiService? api}) : _api = api ?? CurrencyApiService();

  final CurrencyApiService _api;

  double? _usdBrlRate;
  bool _loaded = false;

  double? get usdBrlRate => _usdBrlRate;

  bool get getLoaded => _loaded;

  Future<void> fetchRate() async {
    _usdBrlRate = await _api.fetchUsdBrlRate();
    _loaded = true;
    notifyListeners();
  }
}
