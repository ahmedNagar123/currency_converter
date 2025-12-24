import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:currency_converter/domain/entities/currency.dart';
import 'package:currency_converter/domain/repositories/currency_repository.dart';
import 'package:currency_converter/domain/usecases/get_currencies_usecase.dart';

class MockCurrencyRepository extends Mock implements CurrencyRepository {}

void main() {
  late GetCurrenciesUseCase useCase;
  late MockCurrencyRepository mockRepository;

  setUp(() {
    mockRepository = MockCurrencyRepository();
    useCase = GetCurrenciesUseCase(mockRepository);
  });

  test('should get currencies from repository', () async {
    // Arrange
    final currencies = [
      const Currency(code: 'USD', name: 'US Dollar', countryCode: 'US'),
      const Currency(code: 'EUR', name: 'Euro', countryCode: 'EU'),
    ];

    when(() => mockRepository.getCurrencies())
        .thenAnswer((_) async => currencies);

    // Act
    final result = await useCase();

    // Assert
    expect(result, currencies);
    verify(() => mockRepository.getCurrencies()).called(1);
  });
}

