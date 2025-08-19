// lib/ui/auth/login_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/auth_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/phone_input.dart';
import '../widgets/primary_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _e164;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();

    return Scaffold(
      body: Column(
        children: [
          const AuthHeader(
            title: 'Welcome Back',
            subtitle: 'Login or create an account to continue',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          PhoneInput(onValidChanged: (e) => _e164 = e),
                          const SizedBox(height: 16),
                          PrimaryButton(
                            label: 'Send OTP',
                            loading: auth.isBusy,
                            onPressed: (_e164 != null)
                                ? () => context.read<AuthState>().start(_e164!)
                                : null,
                          ),
                          if (auth.error != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(auth.error!, style: const TextStyle(color: Colors.red)),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: null,
                    child: const Text('By continuing you agree to the Terms & Privacy'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}