import '../../domain/entities/historical_rate.dart';

class HistoricalRateModel extends HistoricalRate {
  const HistoricalRateModel({
    required super.date,
    required super.rate,
  });

  factory HistoricalRateModel.fromJson(Map<String, dynamic> json) {
    return HistoricalRateModel(
      date: DateTime.parse(json['date']),
      rate: (json['value'] as num).toDouble(),
    );
  }
}

