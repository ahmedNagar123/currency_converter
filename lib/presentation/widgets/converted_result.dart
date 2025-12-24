
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConvertedResult extends StatelessWidget {
  final double value;
  final String currency;

  const ConvertedResult({super.key,
    required this.value,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Converted Amount',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            NumberFormat.currency(symbol: '', decimalDigits: 2).format(value),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          Text(
            currency,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
