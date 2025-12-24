import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_historical_rates_usecase.dart';
import 'historical_rates_event.dart';
import 'historical_rates_state.dart';

class HistoricalRatesBloc
    extends Bloc<HistoricalRatesEvent, HistoricalRatesState> {
  final GetHistoricalRatesUseCase getHistoricalRatesUseCase;

  HistoricalRatesBloc(this.getHistoricalRatesUseCase)
      : super(HistoricalRatesInitial()) {
    on<LoadHistoricalRatesEvent>(_onLoadHistoricalRates);
  }

  Future<void> _onLoadHistoricalRates(
    LoadHistoricalRatesEvent event,
    Emitter<HistoricalRatesState> emit,
  ) async {
    emit(HistoricalRatesLoading());
    try {
      final rates = await getHistoricalRatesUseCase(
        fromCurrency: event.fromCurrency,
        toCurrency: event.toCurrency,
        days: event.days,
      );
      emit(HistoricalRatesLoaded(
        rates: rates,
        fromCurrency: event.fromCurrency,
        toCurrency: event.toCurrency,
      ));
    } catch (e) {
      emit(HistoricalRatesError(e.toString()));
    }
  }
}

