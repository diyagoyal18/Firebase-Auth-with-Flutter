import 'package:flutter/material.dart';
import '../common/amount_keypad.dart';
import 'payment_confirm_page.dart';

class AmountPage extends StatefulWidget {
  const AmountPage({super.key});

  @override
  State<AmountPage> createState() => _AmountPageState();
}

class _AmountPageState extends State<AmountPage> {
  int _amountCents = 0;

  @override
  Widget build(BuildContext context) {
    final amount = (_amountCents / 100).toStringAsFixed(2);
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Amount')),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Text('₹ $amount', style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold)),
          const Spacer(),
          AmountKeypad(
            onChanged: (cents) => setState(() => _amountCents = cents),
            onSubmit: () {
              if (_amountCents > 0) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => PaymentConfirmPage(amountCents: _amountCents),
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}