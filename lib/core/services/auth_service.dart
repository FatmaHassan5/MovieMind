

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../state/reminder_controller.dart';
import '../state/user_controller.dart';
import '../state/watchlist_controller.dart';
import 'app_firebase.dart';
import 'cloud_sync_service.dart';

/// الحقل اللي رسالة الخطأ تخصه (عشان نعرضها تحت الحقل الصح).
enum AuthField { email, password, general, unverified }

class AuthResult {
  const AuthResult._(this.ok, this.message, this.field);

  const AuthResult.success() : this._(true, null, AuthField.general);

  /// المستخدم قفل نافذة جوجل مثلاً — مفيش رسالة نعرضها.
  const AuthResult.cancelled() : this._(false, null, AuthField.general);

  const AuthResult.failure(String message, [AuthField field = AuthField.general])
      : this._(false, message, field);

  final bool ok;
  final String? message;
  final AuthField field;

  bool get cancelled => !ok && message == null;
}

/// كل عمليات المصادقة عبر Firebase Authentication، مع رسائل خطأ واضحة.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const _notConfigured = AuthResult.failure(
    "Firebase isn't set up yet. Run `flutterfire configure` and restart the app.",
  );

  FirebaseAuth get _auth => FirebaseAuth.instance;

  /// المستخدم المسجّل دخوله حاليًا (Firebase بيحفظ الجلسة بين مرات فتح التطبيق).
  /// بيرجّع null لو الإيميل لسه ما اتأكدش (حسابات الإيميل/الباسورد محتاجة تحقق).
  User? get currentUser {
    if (!AppFirebase.ready) return null;
    final user = _auth.currentUser;
    return (user != null && _isUsable(user)) ? user : null;
  }

  /// حساب جوجل متأكد تلقائيًا؛ حساب الإيميل لازم يكون emailVerified.
  bool _isUsable(User user) =>
      user.emailVerified || user.providerData.every((p) => p.providerId != 'password');

  /// إنشاء حساب جديد: بنسجّل الاسم، وبعدين نعمل تسجيل خروج
  /// عشان المستخدم يدخل من شاشة اللوجين بنفسه.
  Future<AuthResult> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!AppFirebase.ready) return _notConfigured;
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = cred.user!;
      await user.updateDisplayName(name.trim());
      await CloudSyncService.instance.createProfile(user, name: name.trim());
      // لو الإرسال فشل لأي سبب، المستخدم يقدر يطلب إعادة الإرسال من شاشة اللوجين.
      try {
        await user.sendEmailVerification();
      } catch (e) {
        debugPrint('sendEmailVerification failed: $e');
      }
      await _auth.signOut();
      return const AuthResult.success();
    } on FirebaseAuthException catch (e) {
      return _map(e);
    } catch (e) {
      debugPrint('signUp error: $e');
      return _unknown();
    }
  }

  Future<AuthResult> signIn({
    required String email,
    required String password,
    required bool remember,
  }) async {
    if (!AppFirebase.ready) return _notConfigured;
    try {
      // "Remember" بيتحكم في بقاء الجلسة على الويب. على الموبايل الجلسة بتفضل دايمًا.
      if (kIsWeb) {
        await _auth.setPersistence(remember ? Persistence.LOCAL : Persistence.SESSION);
      }
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = cred.user!;
      if (!_isUsable(user)) {
        await _auth.signOut(); // ما نسيبش جلسة لحساب غير متأكد
        return const AuthResult.failure(
          'Please verify your email first. Check your inbox (and spam) for the link.',
          AuthField.unverified,
        );
      }
      await CloudSyncService.instance.startForUser(user);
      return const AuthResult.success();
    } on FirebaseAuthException catch (e) {
      return _map(e);
    } catch (e) {
      debugPrint('signIn error: $e');
      return _unknown();
    }
  }

  /// إعادة إرسال رابط التحقق: بنسجّل دخول بنفس البيانات، نبعت الرابط، ونخرج تاني.
  Future<AuthResult> resendVerification({
    required String email,
    required String password,
  }) async {
    if (!AppFirebase.ready) return _notConfigured;
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = cred.user!;
      if (user.emailVerified) {
        await _auth.signOut();
        return const AuthResult.failure('This email is already verified. You can log in now.');
      }
      await user.sendEmailVerification();
      await _auth.signOut();
      return const AuthResult.success();
    } on FirebaseAuthException catch (e) {
      return _map(e);
    } catch (e) {
      debugPrint('resendVerification error: $e');
      return _unknown();
    }
  }

  Future<AuthResult> signInWithGoogle() async {
    if (!AppFirebase.ready) return _notConfigured;
    try {
      final provider = GoogleAuthProvider();
      final cred = kIsWeb
          ? await _auth.signInWithPopup(provider)
          : await _auth.signInWithProvider(provider);
      await CloudSyncService.instance.startForUser(cred.user!);
      return const AuthResult.success();
    } on FirebaseAuthException catch (e) {
      return _map(e);
    } on UnimplementedError {
      return const AuthResult.failure("Google sign-in isn't supported on this platform.");
    } on UnsupportedError {
      return const AuthResult.failure("Google sign-in isn't supported on this platform.");
    } catch (e) {
      debugPrint('Google sign-in error: $e');
      return _unknown();
    }
  }

  Future<AuthResult> sendPasswordReset(String email) async {
    if (!AppFirebase.ready) return _notConfigured;
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return const AuthResult.success();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return const AuthResult.failure(
            'No account found with this email.', AuthField.email);
      }
      return _map(e);
    } catch (e) {
      debugPrint('reset error: $e');
      return _unknown();
    }
  }

  /// تسجيل الخروج: بنحفظ أي تغيير معلّق، نخرج، وبعدين نمسح البيانات المحلية.
  Future<void> signOut() async {
    await CloudSyncService.instance.stop();
    if (AppFirebase.ready) await _auth.signOut();
    UserController.instance.reset();
    WatchlistController.instance.clear();
    ReminderController.instance.clear();
  }

  // ------------------------------------------------------------------ errors

  AuthResult _unknown() =>
      const AuthResult.failure('Something went wrong. Please try again.');

  AuthResult _map(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return const AuthResult.failure(
            'This email is already registered. Try logging in instead.',
            AuthField.email);
      case 'invalid-email':
        return const AuthResult.failure('Enter a valid email address.', AuthField.email);
      case 'weak-password':
        return const AuthResult.failure(
            'Password is too weak. Use 8+ characters with letters, numbers and symbols.',
            AuthField.password);
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
      case 'invalid-login-credentials':
        return const AuthResult.failure('Incorrect email or password.');
      case 'user-disabled':
        return const AuthResult.failure('This account has been disabled.');
      case 'too-many-requests':
        return const AuthResult.failure(
            'Too many attempts. Please wait a moment and try again.');
      case 'network-request-failed':
        return const AuthResult.failure(
            'No internet connection. Check your network and try again.');
      case 'operation-not-allowed':
        return const AuthResult.failure(
            "This sign-in method isn't enabled in Firebase yet.");
      case 'account-exists-with-different-credential':
        return const AuthResult.failure(
            'An account already exists with this email using a different sign-in method.');
      case 'popup-closed-by-user':
      case 'cancelled-popup-request':
      case 'web-context-canceled':
      case 'canceled':
        return const AuthResult.cancelled();
      default:
        return AuthResult.failure('Something went wrong (${e.code}). Please try again.');
    }
  }
}
