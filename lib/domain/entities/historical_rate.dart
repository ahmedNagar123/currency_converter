import 'package:equatable/equatable.dart';

class HistoricalRate extends Equatable {
  final DateTime date;
  final double rate;

  const HistoricalRate({
    required this.date,
    required this.rate,
  });

  @override
  List<Object?> get props => [date, rate];
}

