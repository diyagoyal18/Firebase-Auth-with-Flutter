import 'package:flutter/material.dart';

class BraceletPage extends StatefulWidget {
  const BraceletPage({super.key});

  @override
  State<BraceletPage> createState() => _BraceletPageState();
}

class _BraceletPageState extends State<BraceletPage> {
  String? _rfidUid;
  bool _active = false;

  void _scan() async {
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() {
      _rfidUid = 'E20034120123456789ABCD';
    });
  }

  void _toggleActive(bool on) async {
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() => _active = on);
  }

  @override
  Widget build(BuildContext context) {
    final uid = _rfidUid ?? 'Not scanned';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: ListTile(
              title: const Text('RFID UID'),
              subtitle: Text(uid),
              trailing: IconButton(icon: const Icon(Icons.qr_code_scanner), onPressed: _scan),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: SwitchListTile(
              title: const Text('Bracelet Status'),
              subtitle: Text(_active ? 'Active' : 'Disabled'),
              value: _active,
              onChanged: _toggleActive,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.bluetooth_searching),
            label: const Text('Connect Reader (UI only)'),
          ),
          const Spacer(),
          Opacity(
            opacity: 0.7,
            child: Text(
              'Preview only. Hardware and backend integration comes later.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}