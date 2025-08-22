import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'security_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifyPayments = true;
  bool _darkMode = AppTheme.isDark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark mode'),
            value: _darkMode,
            onChanged: (v) async {
              setState(() => _darkMode = v);
              await AppTheme.setDark(v);
            },
          ),
          SwitchListTile(
            title: const Text('Payment notifications'),
            value: _notifyPayments,
            onChanged: (v) => setState(() => _notifyPayments = v),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Security'),
            subtitle: const Text('PIN and biometric'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SecurityPage())),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms & Privacy'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: const Text('Version 1.0.0'),
          ),
        ],
      ),
    );
  }
}