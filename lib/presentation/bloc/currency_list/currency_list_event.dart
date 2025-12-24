import 'package:equatable/equatable.dart';

abstract class CurrencyListEvent extends Equatable {
  const CurrencyListEvent();

  @override
  List<Object?> get props => [];
}

class LoadCurrenciesEvent extends CurrencyListEvent {
  const LoadCurrenciesEvent();
}

