import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_currencies_usecase.dart';
import 'currency_list_event.dart';
import 'currency_list_state.dart';

class CurrencyListBloc extends Bloc<CurrencyListEvent, CurrencyListState> {
  final GetCurrenciesUseCase getCurrenciesUseCase;

  CurrencyListBloc(this.getCurrenciesUseCase) : super(CurrencyListInitial()) {
    on<LoadCurrenciesEvent>(_onLoadCurrencies);
  }

  Future<void> _onLoadCurrencies(
    LoadCurrenciesEvent event,
    Emitter<CurrencyListState> emit,
  ) async {
    emit(CurrencyListLoading());
    try {
      final currencies = await getCurrenciesUseCase();
      emit(CurrencyListLoaded(currencies));
    } catch (e) {
      emit(CurrencyListError(e.toString()));
    }
  }
}

