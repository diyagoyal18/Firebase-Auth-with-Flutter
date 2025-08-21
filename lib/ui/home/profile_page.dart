import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../notifications/notifications_page.dart';
import '../settings/settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged_in', false);
    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (r) => false);
  }

  void _goToNotifications(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsPage()));
  }

  void _goToSettings(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsPage()));
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
        ListTile(
          leading: const Icon(Icons.notifications_outlined),
          title: const Text('Notifications'),
          onTap: () => _goToNotifications(context),
        ),
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: const Text('Settings'),
          onTap: () => _goToSettings(context),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: const Text('Privacy & Security'),
          onTap: () => _goToSettings(context),
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('About'),
          subtitle: const Text('Version 1.0.0 (UI only)'),
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