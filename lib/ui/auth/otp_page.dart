import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpPage extends StatefulWidget {
  OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _codeCtrl = TextEditingController();
  bool _submitting = false;
  String? _errorMessage;
  int _secondsLeft = 60;
  Timer? _timer;

  String _phoneFromArgs(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['phone'] is String) return args['phone'] as String;
    return '';
  }

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeCtrl.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsLeft = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_secondsLeft <= 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  Future<void> _onConfirm() async {
    final code = _codeCtrl.text.trim();
    if (code.length != 6) {
      setState(() => _errorMessage = 'Enter the 6-digit code');
      return;
    }
    setState(() {
      _submitting = true;
      _errorMessage = null;
    });
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() => _submitting = false);

    // UI-only: proceed to profile completion
    Navigator.of(context).pushNamed('/signup');
  }

  Future<void> _onResend() async {
    if (_secondsLeft > 0) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() => _submitting = false);
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    final phone = _phoneFromArgs(context);

    return Scaffold(
      body: Column(
        children: [
          _AuthHeader(
            title: 'Verify OTP',
            subtitle: phone.isEmpty ? 'Enter the 6-digit code' : 'Code sent to $phone',
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: _codeCtrl,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      counterText: '',
                      labelText: '6-digit code',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() => _errorMessage = null),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton.tonalIcon(
                      onPressed: _submitting ? null : _onConfirm,
                      icon: _submitting
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.check),
                      label: const Text('Continue'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: (_secondsLeft == 0 && !_submitting) ? _onResend : null,
                    child: Text(_secondsLeft == 0 ? 'Resend code' : 'Resend in $_secondsLeft s'),
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
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
                Text(title,
                    style: TextStyle(
                      color: cs.onPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    )),
                const SizedBox(height: 6),
                Text(subtitle,
                    style: TextStyle(
                      color: cs.onPrimary.withOpacity(0.95),
                      fontSize: 15,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}