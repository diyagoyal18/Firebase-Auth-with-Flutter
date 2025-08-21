import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _countryCtrl = TextEditingController(text: '+91');
  final TextEditingController _phoneCtrl = TextEditingController();
  bool _submitting = false;
  String? _errorMessage;

  String _buildE164() {
    final code = _countryCtrl.text.trim();
    final local = _phoneCtrl.text.trim();
    return '$code$local'.replaceAll(' ', '');
  }

  Future<void> _onSendOtp() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    setState(() => _submitting = false);

    Navigator.of(context).pushNamed('/otp', arguments: {
      'phone': _buildE164(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _AuthHeader(
            title: 'Welcome Back',
            subtitle: 'Login or create your account to continue',
          ),
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
                            Row(
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: TextFormField(
                                    controller: _countryCtrl,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[+0-9 ]'))],
                                    decoration: const InputDecoration(labelText: 'Code'),
                                        validator: (v) {
                                            final val = v?.trim() ?? '';
                                            if (!val.startsWith('+') || val.length < 2) return 'Ex: +91';
                                            if (!RegExp(r'^\+[0-9 ]+$').hasMatch(val)) return 'Digits only';
                                            return null;
                                          },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Flexible(
                                  flex: 7,
                                  child: TextFormField(
                                    controller: _phoneCtrl,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    decoration: const InputDecoration(labelText: 'Phone number'),
                                    validator: (v) {
                                      final val = (v ?? '').trim();
                                      if (val.length < 8) return 'Enter valid phone';
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: FilledButton.tonalIcon(
                                onPressed: _submitting ? null : _onSendOtp,
                                icon: _submitting
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : const Icon(Icons.arrow_forward),
                                label: const Text('Send OTP'),
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
                    const SizedBox(height: 24),
                    Opacity(
                      opacity: 0.8,
                      child: Text(
                        'By continuing, you agree to our Terms & Privacy Policy',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
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
        gradient: LinearGradient(
          colors: [cs.primary, cs.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -28,
            top: -28,
            child: CircleAvatar(radius: 64, backgroundColor: cs.onPrimary.withOpacity(0.06)),
          ),
          Positioned(
            left: 20,
            bottom: 28,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: cs.onPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: cs.onPrimary.withOpacity(0.95),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}