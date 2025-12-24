import '../entities/historical_rate.dart';
import '../repositories/currency_repository.dart';

class GetHistoricalRatesUseCase {
  final CurrencyRepository repository;

  GetHistoricalRatesUseCase(this.repository);

  Future<List<HistoricalRate>> call({
    required String fromCurrency,
    required String toCurrency,
    required int days,
  }) =>
      repository.getHistoricalRates(
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
        days: days,
      );
}

