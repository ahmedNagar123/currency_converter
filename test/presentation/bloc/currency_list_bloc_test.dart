import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:currency_converter/domain/entities/currency.dart';
import 'package:currency_converter/domain/usecases/get_currencies_usecase.dart';
import 'package:currency_converter/presentation/bloc/currency_list/currency_list_bloc.dart';
import 'package:currency_converter/presentation/bloc/currency_list/currency_list_event.dart';
import 'package:currency_converter/presentation/bloc/currency_list/currency_list_state.dart';

class MockGetCurrenciesUseCase extends Mock implements GetCurrenciesUseCase {}

void main() {
  late CurrencyListBloc bloc;
  late MockGetCurrenciesUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetCurrenciesUseCase();
    bloc = CurrencyListBloc(mockUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be CurrencyListInitial', () {
    expect(bloc.state, isA<CurrencyListInitial>());
  });

  blocTest<CurrencyListBloc, CurrencyListState>(
    'emits [loading, loaded] when LoadCurrenciesEvent is added successfully',
    build: () {
      when(() => mockUseCase()).thenAnswer(
        (_) async => [
          const Currency(code: 'USD', name: 'US Dollar', countryCode: 'US'),
        ],
      );
      return bloc;
    },
    act: (bloc) => bloc.add(LoadCurrenciesEvent()),
    expect: () => [
      isA<CurrencyListLoading>(),
      isA<CurrencyListLoaded>(),
    ],
  );

  blocTest<CurrencyListBloc, CurrencyListState>(
    'emits [loading, error] when LoadCurrenciesEvent fails',
    build: () {
      when(() => mockUseCase()).thenThrow(Exception('Error'));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadCurrenciesEvent()),
    expect: () => [
      isA<CurrencyListLoading>(),
      isA<CurrencyListError>(),
    ],
  );
}

