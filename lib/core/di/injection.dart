import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/datasources/currency_local_datasource.dart';
import '../../data/datasources/currency_remote_datasource.dart';
import '../../data/models/currency_model.dart';
import '../../data/repositories/currency_repository_impl.dart';
import '../../domain/repositories/currency_repository.dart';
import '../../domain/usecases/get_currencies_usecase.dart';
import '../../domain/usecases/convert_currency_usecase.dart';
import '../../domain/usecases/get_historical_rates_usecase.dart';
import '../../presentation/bloc/currency_list/currency_list_bloc.dart';
import '../../presentation/bloc/currency_converter/currency_converter_bloc.dart';
import '../../presentation/bloc/historical_rates/historical_rates_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies({String? testPath}) async {
  // Initialize Hive
  if (testPath != null) {
    // For testing environment
    Hive.init(testPath);
  } else {
    // For production environment
    await Hive.initFlutter();
  }
  
  // Register Hive adapters
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(CurrencyModelAdapter());
  }

  // Register Dio
  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: 'https://api.freecurrencyapi.com/v1',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    ),
  );

  // Register Data Sources
  getIt.registerLazySingleton<CurrencyRemoteDataSource>(
    () => CurrencyRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<CurrencyLocalDataSource>(
    () => CurrencyLocalDataSourceImpl(),
  );

  // Register Repository
  getIt.registerLazySingleton<CurrencyRepository>(
    () => CurrencyRepositoryImpl(
      remoteDataSource: getIt<CurrencyRemoteDataSource>(),
      localDataSource: getIt<CurrencyLocalDataSource>(),
    ),
  );

  // Register Use Cases
  getIt.registerLazySingleton<GetCurrenciesUseCase>(
    () => GetCurrenciesUseCase(getIt<CurrencyRepository>()),
  );
  getIt.registerLazySingleton<ConvertCurrencyUseCase>(
    () => ConvertCurrencyUseCase(getIt<CurrencyRepository>()),
  );
  getIt.registerLazySingleton<GetHistoricalRatesUseCase>(
    () => GetHistoricalRatesUseCase(getIt<CurrencyRepository>()),
  );

  // Register BLoCs
  getIt.registerFactory<CurrencyListBloc>(
    () => CurrencyListBloc(getIt<GetCurrenciesUseCase>()),
  );
  getIt.registerFactory<CurrencyConverterBloc>(
    () => CurrencyConverterBloc(getIt<ConvertCurrencyUseCase>()),
  );
  getIt.registerFactory<HistoricalRatesBloc>(
    () => HistoricalRatesBloc(getIt<GetHistoricalRatesUseCase>()),
  );
}

