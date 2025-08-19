// lib/ui/auth/signup_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/auth_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/primary_button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _form = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();

    return Scaffold(
      body: Column(
        children: [
          const AuthHeader(
            title: 'Complete Profile',
            subtitle: 'Just a few details to finish setting up',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: 'Full name', border: OutlineInputBorder()),
                      validator: (v) => (v == null || v.trim().length < 2) ? 'Enter your name' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailCtrl,
                      decoration: const InputDecoration(labelText: 'Email (optional)', border: OutlineInputBorder()),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      label: 'Finish',
                      loading: auth.isBusy,
                      onPressed: () async {
                        if (_form.currentState?.validate() ?? false) {
                          await context.read<AuthState>().saveProfile(
                                fullName: _nameCtrl.text.trim(),
                                email: _emailCtrl.text.trim(),
                              );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}