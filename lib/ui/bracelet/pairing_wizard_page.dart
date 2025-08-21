import 'package:flutter/material.dart';

class PairingWizardPage extends StatefulWidget {
  const PairingWizardPage({super.key});

  @override
  State<PairingWizardPage> createState() => _PairingWizardPageState();
}

class _PairingWizardPageState extends State<PairingWizardPage> {
  int _step = 0;

  void _next() => setState(() => _step = (_step + 1).clamp(0, 2));
  void _back() => setState(() => _step = (_step - 1).clamp(0, 2));

  @override
  Widget build(BuildContext context) {
    final steps = [
      _WizardStep(title: 'Connect Reader', body: 'Turn on the BLE reader and keep it nearby.'),
      _WizardStep(title: 'Scan Bracelet', body: 'Hold bracelet near the reader to capture UID.'),
      _WizardStep(title: 'Confirm Pairing', body: 'Confirm linking this bracelet to your account.'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Pair Bracelet')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stepper(
              currentStep: _step,
              onStepContinue: _step == 2 ? null : _next,
              onStepCancel: _step == 0 ? null : _back,
              steps: steps.map((s) => Step(title: Text(s.title), content: Text(s.body), isActive: true)).toList(),
              controlsBuilder: (_, details) {
                return Row(
                  children: [
                    FilledButton(onPressed: details.onStepContinue, child: Text(_step == 2 ? 'Done' : 'Next')),
                    const SizedBox(width: 8),
                    if (_step != 0) OutlinedButton(onPressed: details.onStepCancel, child: const Text('Back')),
                  ],
                );
              },
            ),
            const Spacer(),
            if (_step == 2)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.check),
                  label: const Text('Finish'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _WizardStep {
  final String title;
  final String body;
  _WizardStep({required this.title, required this.body});
}