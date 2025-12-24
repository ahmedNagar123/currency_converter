import 'package:equatable/equatable.dart';
import '../../../domain/entities/historical_rate.dart';

abstract class HistoricalRatesState extends Equatable {
  const HistoricalRatesState();

  @override
  List<Object?> get props => [];
}

class HistoricalRatesInitial extends HistoricalRatesState {}

class HistoricalRatesLoading extends HistoricalRatesState {}

class HistoricalRatesLoaded extends HistoricalRatesState {
  final List<HistoricalRate> rates;
  final String fromCurrency;
  final String toCurrency;

  const HistoricalRatesLoaded({
    required this.rates,
    required this.fromCurrency,
    required this.toCurrency,
  });

  @override
  List<Object?> get props => [rates, fromCurrency, toCurrency];
}

class HistoricalRatesError extends HistoricalRatesState {
  final String message;

  const HistoricalRatesError(this.message);

  @override
  List<Object?> get props => [message];
}

