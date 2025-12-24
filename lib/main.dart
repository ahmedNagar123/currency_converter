import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'presentation/bloc/currency_list/currency_list_bloc.dart';
import 'presentation/bloc/currency_list/currency_list_event.dart';
import 'presentation/bloc/currency_converter/currency_converter_bloc.dart';
import 'presentation/bloc/historical_rates/historical_rates_bloc.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CurrencyListBloc>(
          create: (context) => getIt<CurrencyListBloc>()..add(LoadCurrenciesEvent()),
        ),
        BlocProvider<CurrencyConverterBloc>(
          create: (context) => getIt<CurrencyConverterBloc>(),
        ),
        BlocProvider<HistoricalRatesBloc>(
          create: (context) => getIt<HistoricalRatesBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Currency Converter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}
