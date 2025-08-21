import 'package:flutter/material.dart';

class FingerprintEnrollPage extends StatefulWidget {
  const FingerprintEnrollPage({super.key});

  @override
  State<FingerprintEnrollPage> createState() => _FingerprintEnrollPageState();
}

class _FingerprintEnrollPageState extends State<FingerprintEnrollPage> {
  int _captureCount = 0;
  bool _done = false;

  void _capture() async {
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _captureCount++;
      if (_captureCount >= 3) _done = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final prompt = _done ? 'Enrollment complete' : 'Place finger on sensor (${_captureCount}/3)';

    return Scaffold(
      appBar: AppBar(title: const Text('Fingerprint Enrollment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Icon(_done ? Icons.fingerprint : Icons.fingerprint_outlined, size: 96),
            const SizedBox(height: 12),
            Text(prompt, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _done ? null : _capture,
                icon: const Icon(Icons.touch_app),
                label: const Text('Capture'),
              ),
            ),
            const SizedBox(height: 8),
            if (_done)
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Finish'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}