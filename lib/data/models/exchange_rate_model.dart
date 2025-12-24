import '../../domain/entities/exchange_rate.dart';

class ExchangeRateModel extends ExchangeRate {
  const ExchangeRateModel({
    required super.fromCurrency,
    required super.toCurrency,
    required super.rate,
    super.date,
  });

  factory ExchangeRateModel.fromJson(
    Map<String, dynamic> json,
    String fromCurrency,
    String toCurrency,
  ) {
    final key = '${fromCurrency}_$toCurrency';
    final rate = json[key] ?? 0.0;

    return ExchangeRateModel(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      rate: rate is double ? rate : (rate as num).toDouble(),
    );
  }
}

