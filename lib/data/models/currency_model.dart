import '../../domain/entities/currency.dart';
import '../../core/utils/currency_country_mapper.dart';
import 'package:hive/hive.dart';

part 'currency_model.g.dart';

@HiveType(typeId: 0)
class CurrencyModel {
  @HiveField(0)
  final String code;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String countryCode;

  const CurrencyModel({
    required this.code,
    required this.name,
    required this.countryCode,
  });

  // Convert to domain entity
  Currency toEntity() {
    return Currency(
      code: code,
      name: name,
      countryCode: countryCode,
    );
  }

  // Create from domain entity
  factory CurrencyModel.fromEntity(Currency currency) {
    return CurrencyModel(
      code: currency.code,
      name: currency.name,
      countryCode: currency.countryCode,
    );
  }

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    final currencyCode = json['id'] ?? '';
    final countryCode = CurrencyCountryMapper.getCountryCode(currencyCode);
    
    return CurrencyModel(
      code: currencyCode,
      name: json['currencyName'] ?? '',
      countryCode: countryCode,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': code,
        'currencyName': name,
      };
}

