
import 'package:flutter/foundation.dart';

/// بيانات المستخدم وتفضيلاته (حالة عامة): الاسم، الإيميل، التصنيفات المفضلة،
/// وإعدادات الإشعارات. بتتملى من اللوجين/التسجيل وبتتعدل من صفحة Profile.
class UserController {
  UserController._();
  static final UserController instance = UserController._();

  static const _defaultName = 'Movie Lover';
  static const _defaultEmail = 'you@example.com';

  final ValueNotifier<String> name = ValueNotifier<String>(_defaultName);
  final ValueNotifier<String> email = ValueNotifier<String>(_defaultEmail);
  final ValueNotifier<Set<String>> favoriteGenres =
      ValueNotifier<Set<String>>({'Sci-Fi', 'Drama'});

  final ValueNotifier<bool> pushNotifications = ValueNotifier<bool>(true);
  final ValueNotifier<bool> releaseReminders = ValueNotifier<bool>(true);
  final ValueNotifier<bool> aiPersonalization = ValueNotifier<bool>(true);

  void setProfile({String? name, String? email}) {
    if (name != null && name.isNotEmpty) this.name.value = name;
    if (email != null && email.isNotEmpty) this.email.value = email;
  }

  /// بعد تسجيل الدخول بإيميل: بنستنتج اسم معقول من الإيميل (alex.rivera → Alex Rivera).
  void signInWithEmail(String email) =>
      setProfile(name: nameFromEmail(email), email: email);

  void toggleGenre(String genre) {
    final updated = Set<String>.from(favoriteGenres.value);
    if (!updated.add(genre)) updated.remove(genre);
    favoriteGenres.value = updated;
  }

  /// بيرجّع كل حاجة للوضع الافتراضي (بعد تسجيل الخروج).
  void reset() {
    name.value = _defaultName;
    email.value = _defaultEmail;
    favoriteGenres.value = <String>{};
    pushNotifications.value = true;
    releaseReminders.value = true;
    aiPersonalization.value = true;
  }

  static String nameFromEmail(String email) {
    final local = email.split('@').first;
    final words = local
        .split(RegExp(r'[._\-+]'))
        .map((p) => p.replaceAll(RegExp(r'[0-9]'), ''))
        .where((p) => p.isNotEmpty)
        .map((p) => p[0].toUpperCase() + p.substring(1))
        .toList();
    return words.isEmpty ? _defaultName : words.join(' ');
  }
}
