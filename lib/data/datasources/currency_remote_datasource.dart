import '../models/currency_model.dart';
import '../models/exchange_rate_model.dart';
import '../models/historical_rate_model.dart';
import 'package:dio/dio.dart';

abstract class CurrencyRemoteDataSource {
  Future<List<CurrencyModel>> getCurrencies();
  Future<ExchangeRateModel> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
  });
  Future<List<HistoricalRateModel>> getHistoricalRates({
    required String fromCurrency,
    required String toCurrency,
    required int days,
  });
}

class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  final Dio dio;
  static const String baseUrl = 'https://api.freecurrencyapi.com/v1';
  // Note: freecurrencyapi.com requires an API key for free tier (1k requests/month)
  // You can get a free API key from https://freecurrencyapi.com/
  // For now, we'll use it without key (may have limitations)
  static const String? apiKey = 'fca_live_LgAkyj4dkIWI0rFTZSfsMcyce1hXn9jKTAlQVsX8'; // Set your API key here: 'YOUR_API_KEY_HERE'

  CurrencyRemoteDataSourceImpl(this.dio);

  @override
  Future<List<CurrencyModel>> getCurrencies() async {
    try {
      final queryParams = <String, dynamic>{};
      if (apiKey != null) {
        queryParams['apikey'] = apiKey;
      }
      
      final response = await dio.get(
        '$baseUrl/currencies',
        queryParameters: queryParams,
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data['data'] ?? response.data;
        return data.entries
            .map((entry) => CurrencyModel.fromJson({
                  'id': entry.key,
                  'currencyName': entry.value is Map 
                      ? entry.value['name'] ?? entry.key 
                      : entry.key,
                }))
            .toList();
      }
      throw Exception('Failed to load currencies');
    } catch (e) {
      throw Exception('Error fetching currencies: $e');
    }
  }

  @override
  Future<ExchangeRateModel> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'base_currency': fromCurrency,
        'currencies': toCurrency,
      };
      if (apiKey != null) {
        queryParams['apikey'] = apiKey;
      }
      
      final response = await dio.get(
        '$baseUrl/latest',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        final rate = data[toCurrency] is Map
            ? (data[toCurrency]['value'] as num).toDouble()
            : (data[toCurrency] as num).toDouble();
        
        return ExchangeRateModel(
          fromCurrency: fromCurrency,
          toCurrency: toCurrency,
          rate: rate,
        );
      }
      throw Exception('Failed to convert currency');
    } catch (e) {
      throw Exception('Error converting currency: $e');
    }
  }

  @override
  Future<List<HistoricalRateModel>> getHistoricalRates({
    required String fromCurrency,
    required String toCurrency,
    required int days,
  }) async {
    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(Duration(days: days));
      final List<HistoricalRateModel> rates = [];
      
      // Freecurrencyapi.com requires individual date requests for historical data
      // We'll fetch each day individually
      for (int i = 0; i <= days; i++) {
        final date = startDate.add(Duration(days: i));
        final dateStr = date.toIso8601String().split('T')[0];
        
        final queryParams = <String, dynamic>{
          'base_currency': fromCurrency,
          'currencies': toCurrency,
          'date': dateStr,
        };
        if (apiKey != null) {
          queryParams['apikey'] = apiKey;
        }
        
        try {
          final response = await dio.get(
            '$baseUrl/historical',
            queryParameters: queryParams,
          );

          if (response.statusCode == 200) {
            final data = response.data['data'] ?? response.data;
            final rateData = data[dateStr] ?? data;
            final rate = rateData[toCurrency] is Map
                ? (rateData[toCurrency]['value'] as num).toDouble()
                : (rateData[toCurrency] as num).toDouble();
            
            rates.add(HistoricalRateModel(
              date: date,
              rate: rate,
            ));
          }
        } catch (e) {
          // Skip failed dates and continue
          continue;
        }
      }
      
      return rates..sort((a, b) => a.date.compareTo(b.date));
    } catch (e) {
      throw Exception('Error fetching historical rates: $e');
    }
  }
}

