import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/historical_rates/historical_rates_bloc.dart';
import '../bloc/historical_rates/historical_rates_event.dart';
import '../bloc/historical_rates/historical_rates_state.dart';
import '../widgets/currency_picker.dart';

class HistoricalRatesPage extends StatefulWidget {
  const HistoricalRatesPage({super.key});

  @override
  State<HistoricalRatesPage> createState() => _HistoricalRatesPageState();
}

class _HistoricalRatesPageState extends State<HistoricalRatesPage> {
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';

  @override
  void initState() {
    super.initState();
    _loadHistoricalRates();
  }

  void _loadHistoricalRates() {
    context.read<HistoricalRatesBloc>().add(
          LoadHistoricalRatesEvent(
            fromCurrency: _fromCurrency,
            toCurrency: _toCurrency,
            days: 7,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historical Rates'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'From',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            CurrencyPicker(
                              selectedCurrency: _fromCurrency,
                              onCurrencySelected: (currency) {
                                setState(() {
                                  _fromCurrency = currency;
                                });
                                _loadHistoricalRates();
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'To',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            CurrencyPicker(
                              selectedCurrency: _toCurrency,
                              onCurrencySelected: (currency) {
                                setState(() {
                                  _toCurrency = currency;
                                });
                                _loadHistoricalRates();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<HistoricalRatesBloc, HistoricalRatesState>(
              builder: (context, state) {
                if (state is HistoricalRatesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is HistoricalRatesError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${state.message}',
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadHistoricalRates,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is HistoricalRatesLoaded) {
                  if (state.rates.isEmpty) {
                    return const Center(
                      child: Text('No historical data available'),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.rates.length,
                    itemBuilder: (context, index) {
                      final rate = state.rates[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: Text(
                              DateFormat('dd').format(rate.date),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          title: Text(
                            DateFormat('EEEE, MMMM dd, yyyy').format(rate.date),
                          ),
                          subtitle: Text(
                            '${state.fromCurrency} to ${state.toCurrency}',
                          ),
                          trailing: Text(
                            NumberFormat.currency(
                              symbol: '',
                              decimalDigits: 4,
                            ).format(rate.rate),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                return const Center(
                  child: Text('Select currencies to view historical rates'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

