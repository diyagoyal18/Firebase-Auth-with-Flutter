import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends StatefulWidget {
  SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  bool _submitting = false;
  String? _errorMessage;

  Future<void> _onFinish() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged_in', true);

    if (!mounted) return;
    setState(() => _submitting = false);
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _AuthHeader(title: 'Complete Profile', subtitle: 'Just a few details to finish setting up'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
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
                              validator: (v) {
                                final val = (v ?? '').trim();
                                if (val.isEmpty) return null;
                                final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(val);
                                return ok ? null : 'Enter a valid email';
                              },
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: FilledButton.tonalIcon(
                                onPressed: _submitting ? null : _onFinish,
                                icon: _submitting
                                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                                    : const Icon(Icons.check),
                                label: const Text('Finish'),
                              ),
                            ),
                            if (_errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                              ),
                          ],
                        ),
                      ),
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

class _AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _AuthHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [cs.primary, cs.secondary]),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
      ),
      child: Stack(
        children: [
          Positioned(right: -28, top: -28, child: CircleAvatar(radius: 64, backgroundColor: cs.onPrimary.withOpacity(0.06))),
          Positioned(
            left: 20,
            bottom: 28,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: cs.onPrimary, fontSize: 26, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(subtitle, style: TextStyle(color: cs.onPrimary.withOpacity(0.95), fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}