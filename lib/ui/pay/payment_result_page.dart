import 'package:flutter/material.dart';

class PaymentResultPage extends StatelessWidget {
  final bool success;
  final int amountCents;
  const PaymentResultPage({super.key, required this.success, required this.amountCents});

  @override
  Widget build(BuildContext context) {
    final amount = (amountCents / 100).toStringAsFixed(2);
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Result')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(success ? Icons.check_circle : Icons.error, color: success ? Colors.green : Colors.red, size: 72),
            const SizedBox(height: 12),
            Text(success ? 'Payment Successful' : 'Payment Failed', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('₹ $amount'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}