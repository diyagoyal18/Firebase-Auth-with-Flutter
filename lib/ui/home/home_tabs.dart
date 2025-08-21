import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'wallet_page.dart';
import 'bracelet_page.dart';
import 'profile_page.dart';

class HomeTabs extends StatefulWidget {
  const HomeTabs({super.key});

  @override
  State<HomeTabs> createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs> {
  int _index = 0;

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged_in', false);
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final pages = const [
      WalletPage(),
      BraceletPage(),
      ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bracelet Pay'),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Wallet'),
          NavigationDestination(icon: Icon(Icons.watch_outlined), label: 'Bracelet'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}