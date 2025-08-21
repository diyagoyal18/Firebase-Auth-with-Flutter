import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(8, (i) => i);
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final isPayment = i.isOdd;
          final title = isPayment ? 'Payment successful' : 'Top-up received';
          final body = isPayment ? '₹ ${50 * (i + 1)} paid at Cafe' : '₹ ${100 * (i + 1)} added to wallet';
          return Card(
            child: ListTile(
              leading: Icon(isPayment ? Icons.check_circle : Icons.account_balance_wallet),
              title: Text(title),
              subtitle: Text(body),
              trailing: const Text('Just now'),
            ),
          );
        },
      ),
    );
  }
}