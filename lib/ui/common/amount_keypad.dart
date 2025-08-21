import 'package:flutter/material.dart';

class AmountKeypad extends StatefulWidget {
  final void Function(int cents) onChanged;
  final VoidCallback onSubmit;
  const AmountKeypad({super.key, required this.onChanged, required this.onSubmit});

  @override
  State<AmountKeypad> createState() => _AmountKeypadState();
}

class _AmountKeypadState extends State<AmountKeypad> {
  String _digits = '';

  void _tap(String d) {
    setState(() {
      if (d == 'del') {
        if (_digits.isNotEmpty) _digits = _digits.substring(0, _digits.length - 1);
      } else if (_digits.length < 9) {
        _digits += d;
      }
      final cents = int.tryParse(_digits.isEmpty ? '0' : _digits) ?? 0;
      widget.onChanged(cents);
    });
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['00', '0', 'del'],
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        children: [
          for (final row in buttons)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  for (final label in row)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: ElevatedButton(
                          onPressed: () => label == 'del' ? _tap('del') : _tap(label),
                          child: label == 'del' ? const Icon(Icons.backspace_outlined) : Text(label),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: widget.onSubmit,
              icon: const Icon(Icons.check),
              label: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }
}