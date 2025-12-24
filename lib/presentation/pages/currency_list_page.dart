import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/currency_list/currency_list_bloc.dart';
import '../bloc/currency_list/currency_list_event.dart';
import '../bloc/currency_list/currency_list_state.dart';
import '../widgets/currency_item.dart';

class CurrencyListPage extends StatelessWidget {
  const CurrencyListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supported Currencies'),
        elevation: 0,
      ),
      body: BlocBuilder<CurrencyListBloc, CurrencyListState>(
        builder: (context, state) {
          if (state is CurrencyListLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is CurrencyListError) {
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
                    onPressed: () {
                      context.read<CurrencyListBloc>().add(LoadCurrenciesEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is CurrencyListLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<CurrencyListBloc>().add(LoadCurrenciesEvent());
              },
              child: ListView.builder(
                itemCount: state.currencies.length,
                itemBuilder: (context, index) {
                  final currency = state.currencies[index];
                  return CurrencyItem(currency: currency);
                },
              ),
            );
          }

          return const Center(
            child: Text('No currencies available'),
          );
        },
      ),
    );
  }
}

