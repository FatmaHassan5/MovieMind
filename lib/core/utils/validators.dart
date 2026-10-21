/// كل قواعد التحقق (validation) لفورمز اللوجين والتسجيل في مكان واحد،
/// عشان تتعدل رسالة الخطأ أو الشرط من هنا بس.
abstract class Validators {
  static final _emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$');
  static final _lettersRegex = RegExp(r'[a-zA-Zء-ي]');
  static final _numberRegex = RegExp(r'[0-9]');
  static final _specialCharRegex = RegExp(r'''[!@#$%^&*(),.?":{}|<>_\-+=/\\\[\];~`]''');
  static final _nameRegex = RegExp(r'^[a-zA-Zء-ي\s]+$');

  // ---------- Email ----------
  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email address is required.';
    if (!_emailRegex.hasMatch(v)) return 'Enter a valid email address.';
    return null;
  }

  // ---------- Full name ----------
  static String? fullName(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Full name is required.';
    if (v.length < 3) return 'Name looks too short.';
    if (!_nameRegex.hasMatch(v)) {
      return 'Name should only contain letters and spaces.';
    }
    return null;
  }

  // ---------- Login password (just presence) ----------
  static String? loginPassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required.';
    return null;
  }

  // ---------- Password strength rules (used by Sign Up) ----------
  static bool hasMinLength(String v) => v.length >= 8;
  static bool hasLetter(String v) => _lettersRegex.hasMatch(v);
  static bool hasNumber(String v) => _numberRegex.hasMatch(v);
  static bool hasSpecialChar(String v) => _specialCharRegex.hasMatch(v);

  /// عدد الشروط المتحققة (من 0 لـ 4) — بيتحسب بيه شريط قوة الباسورد.
  static int passwordStrengthScore(String v) => [
        hasMinLength(v),
        hasLetter(v),
        hasNumber(v),
        hasSpecialChar(v),
      ].where((met) => met).length;

  static String? signupPassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password is required.';
    if (passwordStrengthScore(v) < 4) {
      return 'Password must meet all the requirements above.';
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password.';
    }
    if (value != original) return 'Passwords do not match.';
    return null;
  }

  static String? termsAgreement(bool? agreed) {
    if (agreed != true) {
      return 'You must agree to the Terms & Conditions and Privacy Policy.';
    }
    return null;
  }
}
