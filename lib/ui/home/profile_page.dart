import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged_in', false);
    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: CircleAvatar(backgroundColor: cs.primary, child: const Icon(Icons.person, color: Colors.white)),
            title: const Text('Alex Doe'),
            subtitle: const Text('alex@example.com\n+91 90000 00000'),
            isThreeLine: true,
          ),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text('Notifications'),
          value: true,
          onChanged: (value) {},
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: const Text('Privacy & Security'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('About'),
          subtitle: const Text('Version 1.0.0 (UI only)'),
          onTap: () {},
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () => _logout(context),
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
        ),
      ],
    );
  }
}