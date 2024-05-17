import 'package:flutter/material.dart';
import 'package:trading/utils/devise_icon.dart';

class DeviseCard extends StatelessWidget {
  final String symbol;
  final double lastPrice;
  final double dailyChange;
  final VoidCallback onTap;

  const DeviseCard({
    super.key,
    required this.symbol,
    required this.lastPrice,
    required this.dailyChange,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Utilisation du gestionnaire de tap fourni
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: ListTile(
          //leading: const Icon(Icons.monetization_on, color: Colors.green),
          leading: Icon(
            getDeviseIcon(symbol),
            color: Colors.green,
            size: 36.0,
          ),
          title:
              Text(symbol, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('Last Price: \$${lastPrice.toStringAsFixed(2)}'),
          trailing: Text(
            '${dailyChange.toStringAsFixed(2)}%',
            style: TextStyle(
              color: dailyChange >= 0 ? Colors.green : Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
