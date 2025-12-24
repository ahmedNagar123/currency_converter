import 'package:equatable/equatable.dart';
import '../../../domain/entities/currency.dart';

abstract class CurrencyListState extends Equatable {
  const CurrencyListState();

  @override
  List<Object?> get props => [];
}

class CurrencyListInitial extends CurrencyListState {}

class CurrencyListLoading extends CurrencyListState {}

class CurrencyListLoaded extends CurrencyListState {
  final List<Currency> currencies;

  const CurrencyListLoaded(this.currencies);

  @override
  List<Object?> get props => [currencies];
}

class CurrencyListError extends CurrencyListState {
  final String message;

  const CurrencyListError(this.message);

  @override
  List<Object?> get props => [message];
}

