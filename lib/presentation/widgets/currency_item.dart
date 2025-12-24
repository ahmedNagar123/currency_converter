import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/currency.dart';

class CurrencyItem extends StatelessWidget {
  final Currency currency;

  const CurrencyItem({
    super.key,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CachedNetworkImage(
          imageUrl: currency.flagUrl,
          width: 40,
          height: 40,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.flag),
        ),
        title: Text(
          currency.code,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(currency.name),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

