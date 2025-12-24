import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:currency_converter/data/datasources/currency_remote_datasource.dart';
import 'package:currency_converter/data/models/currency_model.dart';
import 'package:currency_converter/data/models/exchange_rate_model.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late CurrencyRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = CurrencyRemoteDataSourceImpl(mockDio);
  });

  group('getCurrencies', () {
    test('should return list of currencies when API call is successful', () async {
      // Arrange
      final responseData = {
        'data': {
          'USD': {
            'code': 'USD',
            'name': 'United States Dollar',
          },
          'EUR': {
            'code': 'EUR',
            'name': 'Euro',
          },
        }
      };

      when(() => mockDio.get(
        any(),
        queryParameters: any(named: 'queryParameters'),
      )).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // Act
      final result = await dataSource.getCurrencies();

      // Assert
      expect(result, isA<List<CurrencyModel>>());
      expect(result.length, 2);
      expect(result[0].code, 'USD');
      expect(result[1].code, 'EUR');
    });

    test('should throw exception when API call fails', () async {
      // Arrange
      when(() => mockDio.get(
        any(),
        queryParameters: any(named: 'queryParameters'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
      ));

      // Act & Assert
      expect(
        () => dataSource.getCurrencies(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('convertCurrency', () {
    test('should return exchange rate when API call is successful', () async {
      // Arrange
      final responseData = {
        'data': {
          'EUR': 0.85,
        }
      };

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // Act
      final result = await dataSource.convertCurrency(
        fromCurrency: 'USD',
        toCurrency: 'EUR',
      );

      // Assert
      expect(result, isA<ExchangeRateModel>());
      expect(result.fromCurrency, 'USD');
      expect(result.toCurrency, 'EUR');
      expect(result.rate, 0.85);
    });

    test('should throw exception when API call fails', () async {
      // Arrange
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
      ));

      // Act & Assert
      expect(
        () => dataSource.convertCurrency(
          fromCurrency: 'USD',
          toCurrency: 'EUR',
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}

