import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:currency_converter/domain/entities/exchange_rate.dart';
import 'package:currency_converter/domain/repositories/currency_repository.dart';
import 'package:currency_converter/domain/usecases/convert_currency_usecase.dart';

class MockCurrencyRepository extends Mock implements CurrencyRepository {}

void main() {
  late ConvertCurrencyUseCase useCase;
  late MockCurrencyRepository mockRepository;

  setUp(() {
    mockRepository = MockCurrencyRepository();
    useCase = ConvertCurrencyUseCase(mockRepository);
  });

  test('should convert currency from repository', () async {
    // Arrange
    const exchangeRate = ExchangeRate(
      fromCurrency: 'USD',
      toCurrency: 'EUR',
      rate: 85.0,
    );

    when(() => mockRepository.convertCurrency(
          fromCurrency: any(named: 'fromCurrency'),
          toCurrency: any(named: 'toCurrency'),
          amount: any(named: 'amount'),
        )).thenAnswer((_) async => exchangeRate);

    // Act
    final result = await useCase(
      fromCurrency: 'USD',
      toCurrency: 'EUR',
      amount: 100.0,
    );

    // Assert
    expect(result, exchangeRate);
    verify(() => mockRepository.convertCurrency(
          fromCurrency: 'USD',
          toCurrency: 'EUR',
          amount: 100.0,
        )).called(1);
  });
}

