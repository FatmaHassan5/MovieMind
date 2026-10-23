

import 'package:flutter/foundation.dart';

/// الأفلام اللي المستخدم ضغط "Remind Me" عليها (حالة عامة بين Home والـ Calendar).
class ReminderController {
  ReminderController._();
  static final ReminderController instance = ReminderController._();

  final ValueNotifier<Set<String>> ids = ValueNotifier<Set<String>>({});

  bool isSet(String movieId) => ids.value.contains(movieId);

  /// بيقلب حالة التذكير وبيرجّع true لو التذكير اتفعّل دلوقتي.
  bool toggle(String movieId) {
    final updated = Set<String>.from(ids.value);
    final added = updated.add(movieId);
    if (!added) updated.remove(movieId);
    ids.value = updated;
    return added;
  }

  void setAll(Set<String> value) => ids.value = value;

  void clear() => ids.value = <String>{};
}
