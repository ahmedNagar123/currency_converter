import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/currency_converter/currency_converter_bloc.dart';
import '../bloc/currency_converter/currency_converter_event.dart';
import '../bloc/currency_converter/currency_converter_state.dart';
import '../widgets/converted_result.dart';
import '../widgets/currency_picker.dart';
import '../widgets/error_box.dart';
import '../widgets/hive_box.dart';

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
                          selectedCurrency: state.fromCurrency,
                          onCurrencySelected: (currency) {
                            _convertCurrency(
                              currency,
                              state.toCurrency,
                              double.tryParse(_amountController.text) ?? state.amount,
                            );
                          },
                        ),
                        const SizedBox(height: 16.0),
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
                            final amount = double.tryParse(value) ?? state.amount;
                            _convertCurrency(state.fromCurrency, state.toCurrency, amount);
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
                          selectedCurrency: state.toCurrency,
                          onCurrencySelected: (currency) {
                            _convertCurrency(
                              state.fromCurrency,
                              currency,
                              double.tryParse(_amountController.text) ?? state.amount,
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        if (state.status == CurrencyStatus.loading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (state.status == CurrencyStatus.loaded && state.exchangeRate != null)
                          ConvertedResult(
                            value: state.exchangeRate!.rate,
                            currency: state.toCurrency,
                          )
                        else if (state.status == CurrencyStatus.error)
                            ErrorBox(message: state.errorMessage ?? 'Something went wrong')
                          else
                            HintBox(),

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

