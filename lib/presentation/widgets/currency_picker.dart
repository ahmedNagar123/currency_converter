import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/currency.dart';
import '../bloc/currency_list/currency_list_bloc.dart';
import '../bloc/currency_list/currency_list_event.dart';
import '../bloc/currency_list/currency_list_state.dart';

class CurrencyPicker extends StatelessWidget {
  final String selectedCurrency;
  final Function(String) onCurrencySelected;

  const CurrencyPicker({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencySelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrencyListBloc, CurrencyListState>(
      builder: (context, state) {
        List<Currency> currencies = [];

        if (state is CurrencyListLoaded) {
          currencies = state.currencies;
        } else if (state is! CurrencyListLoading) {
          // Load currencies if not already loaded
          context.read<CurrencyListBloc>().add(LoadCurrenciesEvent());
        }

        if (currencies.isEmpty) {
          return DropdownButton<String>(
            items: [],
            onChanged: null,
            hint: Text('Loading...'),
          );
        }

        return DropdownButton<String>(
          value: selectedCurrency,
          isExpanded: true,
          items: currencies.map((currency) {
            return DropdownMenuItem<String>(
              value: currency.code,
              child: Row(
                children: [
                  Text(
                    currency.code,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    currency.name,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onCurrencySelected(value);
            }
          },
        );
      },
    );
  }
}
