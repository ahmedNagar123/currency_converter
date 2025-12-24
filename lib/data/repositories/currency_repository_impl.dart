import '../../domain/entities/currency.dart';
import '../../domain/entities/exchange_rate.dart';
import '../../domain/entities/historical_rate.dart';
import '../../domain/repositories/currency_repository.dart';
import '../datasources/currency_local_datasource.dart';
import '../datasources/currency_remote_datasource.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource remoteDataSource;
  final CurrencyLocalDataSource localDataSource;

  CurrencyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Currency>> getCurrencies() async {
    try {
      // Try to get from cache first
      final hasCache = await localDataSource.hasCachedCurrencies();
      if (hasCache) {
        final cachedCurrencies = await localDataSource.getCachedCurrencies();
        if (cachedCurrencies.isNotEmpty) {
          return cachedCurrencies.map((model) => model.toEntity()).toList();
        }
      }

      // If no cache, fetch from API
      final currencies = await remoteDataSource.getCurrencies();
      
      // Cache the currencies
      await localDataSource.cacheCurrencies(currencies);
      
      return currencies.map((model) => model.toEntity()).toList();
    } catch (e) {
      // If API fails, try to return cached data
      final hasCache = await localDataSource.hasCachedCurrencies();
      if (hasCache) {
        final cachedCurrencies = await localDataSource.getCachedCurrencies();
        return cachedCurrencies.map((model) => model.toEntity()).toList();
      }
      rethrow;
    }
  }

  @override
  Future<ExchangeRate> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  }) async {
    final rate = await remoteDataSource.convertCurrency(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
    );
    
    return ExchangeRate(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      rate: rate.rate * amount,
      date: DateTime.now(),
    );
  }

  @override
  Future<List<HistoricalRate>> getHistoricalRates({
    required String fromCurrency,
    required String toCurrency,
    required int days,
  }) async {
    return await remoteDataSource.getHistoricalRates(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      days: days,
    );
  }
}

