import 'package:flutter/material.dart';
import 'package:trading/utils/devise_icon.dart';

class DeviseDetailPage extends StatelessWidget {
  final String symbol;
  final double lastPrice;
  final double dailyChange;

  const DeviseDetailPage({
    super.key,
    required this.symbol,
    required this.lastPrice,
    required this.dailyChange,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 9, 126, 126),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          symbol,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              getDeviseIcon(symbol), // Icon devise
              color: Colors.black,
              size: 100.0,
            ),
            const SizedBox(width: 16),
            Text(
              'Symbol: $symbol',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Last Price: \$${lastPrice.toStringAsFixed(2)}'
            ),
            const SizedBox(height: 16),
            Text(
              'Daily Change: ${dailyChange.toStringAsFixed(2)}%',
              style: TextStyle(
                color: dailyChange >= 0 ? Colors.green : Colors.red,
                fontSize: 18
              ),
            ),
          ],
        ),
      ),
    );
  }
}
