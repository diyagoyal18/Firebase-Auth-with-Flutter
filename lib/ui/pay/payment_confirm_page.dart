import 'package:flutter/material.dart';
import 'payment_result_page.dart';

class PaymentConfirmPage extends StatelessWidget {
  final int amountCents;
  const PaymentConfirmPage({super.key, required this.amountCents});

  @override
  Widget build(BuildContext context) {
    final amount = (amountCents / 100).toStringAsFixed(2);
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text('Amount'),
                trailing: Text('₹ $amount', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
            ),
            const SizedBox(height: 12),
            const Card(
              child: ListTile(
                title: Text('To'),
                subtitle: Text('RFID Bracelet'),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (_) => PaymentResultPage(success: true, amountCents: amountCents),
                  ));
                },
                icon: const Icon(Icons.lock),
                label: const Text('Verify & Pay'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}