import 'package:flutter/material.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final _pinCtrl = TextEditingController();
  bool _biometric = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _pinCtrl,
              maxLength: 6,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Set/Change PIN', counterText: ''),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Enable biometric (UI only)'),
              value: _biometric,
              onChanged: (v) => setState(() => _biometric = v),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Security settings saved (UI only)')));
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.check),
                label: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}