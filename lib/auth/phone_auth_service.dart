// lib/auth/phone_auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;
  int? _resendToken;

  User? get currentUser => _auth.currentUser;

  Future<void> startPhoneVerification({
    required String e164Phone,
    required void Function() codeSent,
    required void Function(String message) onError,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: e164Phone,
        timeout: const Duration(seconds: 60),
        forceResendingToken: _resendToken,
        verificationCompleted: (PhoneAuthCredential cred) async {
          await _auth.signInWithCredential(cred);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? forceResendToken) {
          _verificationId = verificationId;
          _resendToken = forceResendToken;
          codeSent();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      onError('Could not start verification');
    }
  }

  Future<User?> confirmOtp({
    required String smsCode,
  }) async {
    if (_verificationId == null) {
      throw StateError('No verification in progress');
    }
    final cred = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: smsCode,
    );
    final result = await _auth.signInWithCredential(cred);
    return result.user;
  }

  Future<void> signOut() => _auth.signOut();
}