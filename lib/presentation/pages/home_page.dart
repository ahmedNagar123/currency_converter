import 'package:flutter/material.dart';
import 'currency_list_page.dart';
import 'currency_converter_page.dart';
import 'historical_rates_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;

  final List<Widget> _pages = [
    const CurrencyListPage(),
    const CurrencyConverterPage(),
    const HistoricalRatesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'Currencies',
          ),
          NavigationDestination(
            icon: Icon(Icons.swap_horiz),
            label: 'Converter',
          ),
          NavigationDestination(
            icon: Icon(Icons.timeline),
            label: 'History',
          ),
        ],
      ),
    );
  }
}

