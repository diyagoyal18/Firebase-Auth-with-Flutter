// lib/auth/auth_state.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'phone_auth_service.dart';

enum AuthStage { enterPhone, enterOtp, completeProfile, authed }

class AuthState extends ChangeNotifier {
  final PhoneAuthService phoneAuth;
  AuthState({required this.phoneAuth});

  AuthStage _stage = AuthStage.enterPhone;
  String _e164Phone = '';
  bool _busy = false;
  String? _error;
  int _secondsLeft = 60;
  Timer? _timer;

  AuthStage get stage => _stage;
  String get e164Phone => _e164Phone;
  bool get isBusy => _busy;
  String? get error => _error;
  int get secondsLeft => _secondsLeft;
  User? get user => phoneAuth.currentUser;

  void _setBusy(bool v) { _busy = v; notifyListeners(); }
  void _setError(String? m) { _error = m; notifyListeners(); }

  Future<void> start(String e164Phone) async {
    _e164Phone = e164Phone;
    _setBusy(true);
    _setError(null);
    await phoneAuth.startPhoneVerification(
      e164Phone: e164Phone,
      codeSent: () {
        _stage = AuthStage.enterOtp;
        _startCountdown();
        _setBusy(false);
        notifyListeners();
      },
      onError: (m) {
        _setBusy(false);
        _setError(m);
      },
    );
  }

  Future<void> resend() async {
    if (_secondsLeft > 0) return;
    await start(_e164Phone);
  }

  Future<void> confirmOtp(String code) async {
    _setBusy(true);
    _setError(null);
    try {
      final u = await phoneAuth.confirmOtp(smsCode: code);
      if (u != null) {
        if (u.displayName == null || u.displayName!.isEmpty) {
          _stage = AuthStage.completeProfile;
        } else {
          _stage = AuthStage.authed;
        }
      }
    } catch (e) {
      _setError('Invalid code');
    } finally {
      _setBusy(false);
      notifyListeners();
    }
  }

  Future<void> saveProfile({required String fullName, String? email}) async {
    _setBusy(true);
    try {
      await FirebaseAuth.instance.currentUser?.updateDisplayName(fullName);
      if (email != null && email.isNotEmpty) {
        // Optional: only if you also support email/password
      }
      _stage = AuthStage.authed;
    } finally {
      _setBusy(false);
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await phoneAuth.signOut();
    _stage = AuthStage.enterPhone;
    _e164Phone = '';
    _secondsLeft = 60;
    _timer?.cancel();
    notifyListeners();
  }

  void _startCountdown() {
    _timer?.cancel();
    _secondsLeft = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft == 0) { t.cancel(); } else { _secondsLeft--; }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}