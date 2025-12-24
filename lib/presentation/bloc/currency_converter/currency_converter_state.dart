import 'package:equatable/equatable.dart';
import '../../../domain/entities/exchange_rate.dart';

enum CurrencyStatus { initial, loading, loaded, error }

class CurrencyConverterState extends Equatable {
  final CurrencyStatus status;
  final String fromCurrency;
  final String toCurrency;
  final double amount;
  final ExchangeRate? exchangeRate;
  final String? errorMessage;

  const CurrencyConverterState({
    this.status = CurrencyStatus.initial,
    this.fromCurrency = 'USD',
    this.toCurrency = 'EUR',
    this.amount = 1.0,
    this.exchangeRate,
    this.errorMessage,
  });

  CurrencyConverterState copyWith({
    CurrencyStatus? status,
    String? fromCurrency,
    String? toCurrency,
    double? amount,
    ExchangeRate? exchangeRate,
    String? errorMessage,
  }) {
    return CurrencyConverterState(
      status: status ?? this.status,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      amount: amount ?? this.amount,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    fromCurrency,
    toCurrency,
    amount,
    exchangeRate,
    errorMessage,
  ];
}
