import '../entities/currency.dart';
import '../repositories/currency_repository.dart';

class GetCurrenciesUseCase {
  final CurrencyRepository repository;

  GetCurrenciesUseCase(this.repository);

  Future<List<Currency>> call() => repository.getCurrencies();
}

