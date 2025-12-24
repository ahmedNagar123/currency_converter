import 'package:equatable/equatable.dart';

abstract class CurrencyConverterEvent extends Equatable {
  const CurrencyConverterEvent();

  @override
  List<Object?> get props => [];
}

class ConvertCurrencyEvent extends CurrencyConverterEvent {
  final String fromCurrency;
  final String toCurrency;
  final double amount;

  const ConvertCurrencyEvent({
    required this.fromCurrency,
    required this.toCurrency,
    required this.amount,
  });

  @override
  List<Object?> get props => [fromCurrency, toCurrency, amount];
}

class SwapCurrenciesEvent extends CurrencyConverterEvent {
  const SwapCurrenciesEvent();
}

