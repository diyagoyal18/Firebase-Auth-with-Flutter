import 'package:flutter/material.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({super.key});

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final _form = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  String _method = 'UPI';

  @override
  Widget build(BuildContext context) {
    final methods = ['UPI', 'Card', 'Net Banking'];
    return Scaffold(
      appBar: AppBar(title: const Text('Add Money')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount', prefixText: '₹ '),
                validator: (v) => (v == null || v.isEmpty) ? 'Enter amount' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _method,
                decoration: const InputDecoration(labelText: 'Payment method'),
                items: methods.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                onChanged: (v) => setState(() => _method = v ?? _method),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    if (_form.currentState?.validate() ?? false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Top-up initiated: ₹${_amountCtrl.text} via $_method (UI only)')),
                      );
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Money'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}