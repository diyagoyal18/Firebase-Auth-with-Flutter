import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_theme.dart';

import 'ui/auth/login_page.dart';
import 'ui/auth/otp_page.dart';
import 'ui/auth/signup_page.dart';
import 'ui/home/home_tabs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppTheme.init();
  runApp(BraceletPayApp());
}

class BraceletPayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeMode,
      builder: (_, mode, __) {
        return MaterialApp(
          title: 'Bracelet Pay',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.indigo,
            brightness: Brightness.light,
            inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.indigo,
            brightness: Brightness.dark,
            inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
          ),
          themeMode: mode,
          home: const LaunchDecider(),
          routes: {
            '/login': (_) => LoginPage(),
            '/otp': (_) => OtpPage(),
            '/signup': (_) => SignupPage(),
            '/home': (_) => const HomeTabs(),
          },
        );
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
  bool _ready = false, _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _ready = true;
      _loggedIn = prefs.getBool('logged_in') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return _loggedIn ? const HomeTabs() : LoginPage();
  }
}