import 'package:flutter/material.dart';

class HintBox extends StatelessWidget {
  const HintBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Enter amount to convert',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
