import 'package:equatable/equatable.dart';

abstract class HistoricalRatesEvent extends Equatable {
  const HistoricalRatesEvent();

  @override
  List<Object?> get props => [];
}

class LoadHistoricalRatesEvent extends HistoricalRatesEvent {
  final String fromCurrency;
  final String toCurrency;
  final int days;

  const LoadHistoricalRatesEvent({
    required this.fromCurrency,
    required this.toCurrency,
    this.days = 7,
  });

  @override
  List<Object?> get props => [fromCurrency, toCurrency, days];
}

