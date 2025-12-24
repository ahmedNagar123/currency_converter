import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/convert_currency_usecase.dart';
import 'currency_converter_event.dart';
import 'currency_converter_state.dart';

class CurrencyConverterBloc
    extends Bloc<CurrencyConverterEvent, CurrencyConverterState> {
  final ConvertCurrencyUseCase convertCurrencyUseCase;

  CurrencyConverterBloc(this.convertCurrencyUseCase)
      : super(const CurrencyConverterState()) {
    on<ConvertCurrencyEvent>(_onConvertCurrency);
    on<SwapCurrenciesEvent>(_onSwapCurrencies);
  }

  Future<void> _onConvertCurrency(
      ConvertCurrencyEvent event,
      Emitter<CurrencyConverterState> emit,
      ) async {
    emit(state.copyWith(
      status: CurrencyStatus.loading,
      fromCurrency: event.fromCurrency,
      toCurrency: event.toCurrency,
      amount: event.amount,
    ));

    try {
      // 🔹 Delayed result (UX + debounce simulation)
      await Future.delayed(const Duration(milliseconds: 400));

      final exchangeRate = await convertCurrencyUseCase(
        fromCurrency: event.fromCurrency,
        toCurrency: event.toCurrency,
        amount: event.amount,
      );

      emit(state.copyWith(
        status: CurrencyStatus.loaded,
        exchangeRate: exchangeRate,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CurrencyStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onSwapCurrencies(
      SwapCurrenciesEvent event,
      Emitter<CurrencyConverterState> emit,
      ) {
    emit(state.copyWith(
      fromCurrency: state.toCurrency,
      toCurrency: state.fromCurrency,
    ));

    add(ConvertCurrencyEvent(
      fromCurrency: state.toCurrency,
      toCurrency: state.fromCurrency,
      amount: state.amount,
    ));
  }
}
