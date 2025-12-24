import '../entities/currency.dart';
import '../entities/exchange_rate.dart';
import '../entities/historical_rate.dart';

abstract class CurrencyRepository {
  Future<List<Currency>> getCurrencies();
  Future<ExchangeRate> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  });
  Future<List<HistoricalRate>> getHistoricalRates({
    required String fromCurrency,
    required String toCurrency,
    required int days,
  });
}

