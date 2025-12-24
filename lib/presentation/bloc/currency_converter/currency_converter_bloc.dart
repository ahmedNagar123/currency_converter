import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/convert_currency_usecase.dart';
import 'currency_converter_event.dart';
import 'currency_converter_state.dart';

class CurrencyConverterBloc
    extends Bloc<CurrencyConverterEvent, CurrencyConverterState> {
  final ConvertCurrencyUseCase convertCurrencyUseCase;

  CurrencyConverterBloc(this.convertCurrencyUseCase)
      : super(const CurrencyConverterInitial()) {
    on<ConvertCurrencyEvent>(_onConvertCurrency);
    on<SwapCurrenciesEvent>(_onSwapCurrencies);
  }

  Future<void> _onConvertCurrency(
    ConvertCurrencyEvent event,
    Emitter<CurrencyConverterState> emit,
  ) async {
    emit(CurrencyConverterLoading(
      fromCurrency: event.fromCurrency,
      toCurrency: event.toCurrency,
      amount: event.amount,
    ));

    try {
      final exchangeRate = await convertCurrencyUseCase(
        fromCurrency: event.fromCurrency,
        toCurrency: event.toCurrency,
        amount: event.amount,
      );

      emit(CurrencyConverterLoaded(
        exchangeRate: exchangeRate,
        fromCurrency: event.fromCurrency,
        toCurrency: event.toCurrency,
        amount: event.amount,
      ));
    } catch (e) {
      emit(CurrencyConverterError(
        message: e.toString(),
        fromCurrency: event.fromCurrency,
        toCurrency: event.toCurrency,
        amount: event.amount,
      ));
    }
  }

  void _onSwapCurrencies(
    SwapCurrenciesEvent event,
    Emitter<CurrencyConverterState> emit,
  ) {
    final currentState = state;
    if (currentState is CurrencyConverterInitial ||
        currentState is CurrencyConverterLoaded ||
        currentState is CurrencyConverterError) {
      final fromCurrency = currentState.toCurrency;
      final toCurrency = currentState.fromCurrency;
      final amount = currentState.amount;

      add(ConvertCurrencyEvent(
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
        amount: amount,
      ));
    }
  }
}

