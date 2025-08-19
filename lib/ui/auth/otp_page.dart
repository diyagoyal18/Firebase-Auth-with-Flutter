// lib/ui/auth/otp_page.dart
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../auth/auth_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/primary_button.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});
  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String _code = '';

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();

    return Scaffold(
      body: Column(
        children: [
          AuthHeader(
            title: 'Verify OTP',
            subtitle: 'Sent to ${auth.e164Phone}',
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Pinput(
                    length: 6,
                    onCompleted: (v) => setState(() => _code = v),
                    defaultPinTheme: PinTheme(
                      width: 50,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    label: 'Continue',
                    loading: auth.isBusy,
                    onPressed: _code.length == 6
                        ? () => context.read<AuthState>().confirmOtp(_code)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: auth.secondsLeft == 0 ? () => context.read<AuthState>().resend() : null,
                    child: Text(auth.secondsLeft == 0 ? 'Resend code' : 'Resend in ${auth.secondsLeft}s'),
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
        ],
      ),
    );
  }
}