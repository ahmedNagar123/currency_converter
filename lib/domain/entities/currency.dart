import 'package:equatable/equatable.dart';

class Currency extends Equatable {
  final String code;
  final String name;
  final String countryCode;

  const Currency({
    required this.code,
    required this.name,
    required this.countryCode,
  });

  String get flagUrl => 'https://flagcdn.com/w40/${countryCode.toLowerCase()}.png';

  @override
  List<Object?> get props => [code, name, countryCode];
}

