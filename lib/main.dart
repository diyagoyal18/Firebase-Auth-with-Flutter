import 'package:flutter/material.dart';

// UI-only imports. Ensure these files exist in your project.
import 'ui/auth/login_page.dart';
import 'ui/auth/otp_page.dart';
import 'ui/auth/signup_page.dart';
// Optional: if you have a home tabs UI
// import 'ui/home/home_tabs.dart';

void main() {
  runApp(const BraceletPayApp());
}

class BraceletPayApp extends StatelessWidget {
  const BraceletPayApp({super.key});

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
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/otp': (_) => const OtpPage(),
        '/signup': (_) => const SignupPage(),
        // '/home': (_) => const HomeTabs(),
      },
    );
  }
}
