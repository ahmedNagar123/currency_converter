import 'package:equatable/equatable.dart';

import '../../../domain/entities/exchange_rate.dart';

abstract class CurrencyConverterState extends Equatable {
  final String fromCurrency;
  final String toCurrency;
  final double amount;

  const CurrencyConverterState({
    required this.fromCurrency,
    required this.toCurrency,
    required this.amount,
  });

  @override
  List<Object?> get props => [fromCurrency, toCurrency, amount];
}

class CurrencyConverterInitial extends CurrencyConverterState {
  const CurrencyConverterInitial({
    super.fromCurrency = 'USD',
    super.toCurrency = 'EUR',
    super.amount = 1.0,
  });

  @override
  List<Object?> get props => [fromCurrency, toCurrency, amount];
}

class CurrencyConverterLoading extends CurrencyConverterState {
  const CurrencyConverterLoading({
    required super.fromCurrency,
    required super.toCurrency,
    required super.amount,
  });

  @override
  List<Object?> get props => [fromCurrency, toCurrency, amount];
}

class CurrencyConverterLoaded extends CurrencyConverterState {
  final ExchangeRate exchangeRate;

  const CurrencyConverterLoaded({
    required this.exchangeRate,
    required super.fromCurrency,
    required super.toCurrency,
    required super.amount,
  });

  @override
  List<Object?> get props =>
      super.props..add(exchangeRate);
}

class CurrencyConverterError extends CurrencyConverterState {
  final String message;

  const CurrencyConverterError({
    required this.message,
    required super.fromCurrency,
    required super.toCurrency,
    required super.amount,
  });

  @override
  List<Object?> get props =>
      super.props..add(message);
}
