import '../entities/exchange_rate.dart';
import '../repositories/currency_repository.dart';

class ConvertCurrencyUseCase {
  final CurrencyRepository repository;

  ConvertCurrencyUseCase(this.repository);

  Future<ExchangeRate> call({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  }) =>
      repository.convertCurrency(
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
        amount: amount,
      );
}

