import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../state/reminder_controller.dart';
import '../state/user_controller.dart';
import '../state/watchlist_controller.dart';

/// بيربط بيانات المستخدم (البروفايل، الـ Watchlist، المشاهدات، التذكيرات،
/// التفضيلات) بحسابه في Firestore: مستند واحد `users/{uid}`.
///
/// - عند تسجيل الدخول: بيحمّل المستند ويملّي الـ controllers.
/// - بعد كده: أي تغيير في أي controller بيتحفظ تلقائيًا (بعد 700ms هدوء).
/// - لو التحميل فشل (أوفلاين/قواعد غلط) بنكمل من غير مزامنة عشان ما نمسحش
///   بيانات السحابة بقيم فاضية، و[syncError] بتعرض المشكلة.
class CloudSyncService {
  CloudSyncService._();
  static final CloudSyncService instance = CloudSyncService._();

  static const _saveDelay = Duration(milliseconds: 700);
  static const _loadTimeout = Duration(seconds: 12);

  final ValueNotifier<String?> syncError = ValueNotifier<String?>(null);

  User? _user;
  Timer? _saveTimer;
  bool _attached = false;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      FirebaseFirestore.instance.collection('users').doc(uid);

  List<Listenable> get _sources {
    final u = UserController.instance;
    final w = WatchlistController.instance;
    return [
      u.name,
      u.favoriteGenres,
      u.pushNotifications,
      u.releaseReminders,
      u.aiPersonalization,
      w.ids,
      w.watchedIds,
      ReminderController.instance.ids,
    ];
  }

  /// بيحمّل بيانات المستخدم من السحابة ويبدأ المزامنة.
  Future<void> startForUser(User user) async {
    await stop();
    _user = user;
    syncError.value = null;

    try {
      final snap = await _doc(user.uid).get().timeout(_loadTimeout);
      if (snap.exists && snap.data() != null) {
        _apply(snap.data()!, user);
      } else {
        _applyNewUser(user);
        await _save(); // إنشاء مستند المستخدم لأول مرة
      }
      _attach();
    } catch (e) {
      debugPrint('Cloud load failed: $e');
      syncError.value = 'Cloud sync unavailable — your changes won\'t be saved.';
      _applyNewUser(user); // نعرض هوية المستخدم على الأقل، من غير مزامنة
    }
  }

  /// بيحفظ أي تغيير معلّق فورًا ويوقف المزامنة (يُستدعى قبل تسجيل الخروج).
  Future<void> stop() async {
    _detach();
    if (_saveTimer?.isActive ?? false) {
      _saveTimer!.cancel();
      await _save();
    }
    _saveTimer = null;
    _user = null;
  }

  /// بيكتب مستند المستخدم بعد إنشاء الحساب (محاولة بدون إيقاف التسجيل لو فشلت).
  Future<void> createProfile(User user, {required String name}) async {
    try {
      await _doc(user.uid).set({
        'name': name,
        'email': user.email,
        'favoriteGenres': <String>[],
        'pushNotifications': true,
        'releaseReminders': true,
        'aiPersonalization': true,
        'watchlist': <String>[],
        'watched': <String>[],
        'reminders': <String>[],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('createProfile failed: $e');
    }
  }

  // ---------------------------------------------------------------- internals

  void _attach() {
    if (_attached) return;
    for (final source in _sources) {
      source.addListener(_scheduleSave);
    }
    _attached = true;
  }

  void _detach() {
    if (!_attached) return;
    for (final source in _sources) {
      source.removeListener(_scheduleSave);
    }
    _attached = false;
  }

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(_saveDelay, _save);
  }

  Future<void> _save() async {
    final user = _user;
    if (user == null) return;
    final u = UserController.instance;
    final w = WatchlistController.instance;
    try {
      await _doc(user.uid).set({
        'name': u.name.value,
        'email': user.email ?? u.email.value,
        'favoriteGenres': u.favoriteGenres.value.toList(),
        'pushNotifications': u.pushNotifications.value,
        'releaseReminders': u.releaseReminders.value,
        'aiPersonalization': u.aiPersonalization.value,
        'watchlist': List<String>.from(w.ids.value),
        'watched': w.watchedIds.value.toList(),
        'reminders': ReminderController.instance.ids.value.toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      syncError.value = null;
    } catch (e) {
      debugPrint('Cloud save failed: $e');
      syncError.value = 'Cloud sync failed — check your connection.';
    }
  }

  String _displayNameFor(User user) {
    final name = user.displayName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return UserController.nameFromEmail(user.email ?? '');
  }

  void _applyNewUser(User user) {
    final u = UserController.instance;
    u.name.value = _displayNameFor(user);
    u.email.value = user.email ?? '';
    u.favoriteGenres.value = <String>{};
    u.pushNotifications.value = true;
    u.releaseReminders.value = true;
    u.aiPersonalization.value = true;
    WatchlistController.instance.clear();
    ReminderController.instance.clear();
  }

  void _apply(Map<String, dynamic> data, User user) {
    final u = UserController.instance;
    final savedName = (data['name'] as String?)?.trim();
    u.name.value =
        (savedName != null && savedName.isNotEmpty) ? savedName : _displayNameFor(user);
    u.email.value = user.email ?? (data['email'] as String? ?? '');
    u.favoriteGenres.value = _stringList(data['favoriteGenres']).toSet();
    u.pushNotifications.value = data['pushNotifications'] as bool? ?? true;
    u.releaseReminders.value = data['releaseReminders'] as bool? ?? true;
    u.aiPersonalization.value = data['aiPersonalization'] as bool? ?? true;
    WatchlistController.instance.setAll(
      saved: _stringList(data['watchlist']),
      watched: _stringList(data['watched']).toSet(),
    );
    ReminderController.instance.setAll(_stringList(data['reminders']).toSet());
  }

  List<String> _stringList(Object? value) =>
      (value as List?)?.whereType<String>().toList() ?? <String>[];
}
