import '../models/currency_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class CurrencyLocalDataSource {
  Future<List<CurrencyModel>> getCachedCurrencies();
  Future<void> cacheCurrencies(List<CurrencyModel> currencies);
  Future<bool> hasCachedCurrencies();
}

class CurrencyLocalDataSourceImpl implements CurrencyLocalDataSource {
  static const String boxName = 'currencies_box';

  @override
  Future<List<CurrencyModel>> getCachedCurrencies() async {
    try {
      final box = await Hive.openBox<CurrencyModel>(boxName);
      return box.values.cast<CurrencyModel>().toList();
    } catch (e) {
      throw Exception('Error loading cached currencies: $e');
    }
  }

  @override
  Future<void> cacheCurrencies(List<CurrencyModel> currencies) async {
    try {
      final box = await Hive.openBox<CurrencyModel>(boxName);
      await box.clear();
      await box.addAll(currencies);
    } catch (e) {
      throw Exception('Error caching currencies: $e');
    }
  }

  @override
  Future<bool> hasCachedCurrencies() async {
    try {
      final box = await Hive.openBox<CurrencyModel>(boxName);
      return box.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}

