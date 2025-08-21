import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/auth/login_page.dart';
import 'ui/auth/otp_page.dart';
import 'ui/auth/signup_page.dart';
import 'ui/home/home_tabs.dart';

void main() {
  runApp(BraceletPayApp());
}

class BraceletPayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bracelet Pay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
      ),
      home: const LaunchDecider(),
      routes: {
        '/login': (_) => LoginPage(),
        '/otp': (_) => OtpPage(),
        '/signup': (_) => SignupPage(),
        '/home': (_) => const HomeTabs(),
      },
    );
  }
}

class LaunchDecider extends StatefulWidget {
  const LaunchDecider({super.key});
  @override
  State<LaunchDecider> createState() => _LaunchDeciderState();
}

class _LaunchDeciderState extends State<LaunchDecider> {
  bool _ready = false;
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final flag = prefs.getBool('logged_in') ?? false;
    if (!mounted) return;
    setState(() {
      _ready = true;
      _loggedIn = flag;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return _loggedIn ? const HomeTabs() : LoginPage();
  }
}