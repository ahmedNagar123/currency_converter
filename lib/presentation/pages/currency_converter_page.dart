import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/currency_converter/currency_converter_bloc.dart';
import '../bloc/currency_converter/currency_converter_event.dart';
import '../bloc/currency_converter/currency_converter_state.dart';
import '../widgets/currency_picker.dart';

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final TextEditingController _amountController = TextEditingController(text: '1.0');

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: () {
              context.read<CurrencyConverterBloc>().add(SwapCurrenciesEvent());
            },
            tooltip: 'Swap currencies',
          ),
        ],
      ),
      body: BlocBuilder<CurrencyConverterBloc, CurrencyConverterState>(
        builder: (context, state) {
          String fromCurrency = 'USD';
          String toCurrency = 'EUR';

          if (state is CurrencyConverterInitial ||
              state is CurrencyConverterLoading ||
              state is CurrencyConverterLoaded ||
              state is CurrencyConverterError) {
            fromCurrency = state.fromCurrency;
            toCurrency = state.toCurrency;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'From',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CurrencyPicker(
                          selectedCurrency: fromCurrency,
                          onCurrencySelected: (currency) {
                            _convertCurrency(
                              currency,
                              toCurrency,
                              double.tryParse(_amountController.text) ?? 1.0,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.attach_money),
                          ),
                          onChanged: (value) {
                            final amount = double.tryParse(value) ?? 1.0;
                            _convertCurrency(fromCurrency, toCurrency, amount);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Icon(
                  Icons.arrow_downward,
                  size: 32,
                  color: Colors.blue,
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'To',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CurrencyPicker(
                          selectedCurrency: toCurrency,
                          onCurrencySelected: (currency) {
                            _convertCurrency(
                              fromCurrency,
                              currency,
                              double.tryParse(_amountController.text) ?? 1.0,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        if (state is CurrencyConverterLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (state is CurrencyConverterLoaded)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Converted Amount',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  NumberFormat.currency(
                                    symbol: '',
                                    decimalDigits: 2,
                                  ).format(state.exchangeRate.rate),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  toCurrency,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else if (state is CurrencyConverterError)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline, color: Colors.red),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    state.message,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Enter amount to convert',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _convertCurrency(String from, String to, double amount) {
    context.read<CurrencyConverterBloc>().add(
          ConvertCurrencyEvent(
            fromCurrency: from,
            toCurrency: to,
            amount: amount,
          ),
        );
  }
}

