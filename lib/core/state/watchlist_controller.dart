// import 'package:flutter/foundation.dart';

// import '../data/movie_catalog.dart';

// /// حالة الـ Watchlist على مستوى التطبيق كله (Singleton بسيط).
// /// أي شاشة تقدر تضيف/تشيل فيلم، وكل الشاشات اللي بتسمع للـ [ids]
// /// بتتحدث تلقائيًا (Home, Search, AI Mind, Watchlist).
// class WatchlistController {
//   WatchlistController._();
//   static final WatchlistController instance = WatchlistController._();

//   final ValueNotifier<List<String>> ids =
//       ValueNotifier<List<String>>(MovieCatalog.watchlistSeed.map((m) => m.id).toList());

//   final ValueNotifier<Set<String>> watchedIds = ValueNotifier<Set<String>>({});

//   bool isSaved(String movieId) => ids.value.contains(movieId);

//   void toggle(String movieId) {
//     final updated = List<String>.from(ids.value);
//     if (updated.contains(movieId)) {
//       updated.remove(movieId);
//     } else {
//       updated.add(movieId);
//     }
//     ids.value = updated;
//   }

//   void remove(String movieId) {
//     final updated = List<String>.from(ids.value)..remove(movieId);
//     ids.value = updated;
//   }

//   bool isWatched(String movieId) => watchedIds.value.contains(movieId);

//   void toggleWatched(String movieId) {
//     final updated = Set<String>.from(watchedIds.value);
//     if (!updated.add(movieId)) updated.remove(movieId);
//     watchedIds.value = updated;
//   }
// }

import 'package:flutter/foundation.dart';

import '../data/movie_catalog.dart';

/// حالة الـ Watchlist على مستوى التطبيق كله (Singleton بسيط).
/// أي شاشة تقدر تضيف/تشيل فيلم، وكل الشاشات اللي بتسمع للـ [ids]
/// بتتحدث تلقائيًا. بعد تسجيل الدخول بتتملي من حساب المستخدم في Firestore.
class WatchlistController {
  WatchlistController._();
  static final WatchlistController instance = WatchlistController._();

  final ValueNotifier<List<String>> ids =
      ValueNotifier<List<String>>(MovieCatalog.watchlistSeed.map((m) => m.id).toList());

  final ValueNotifier<Set<String>> watchedIds = ValueNotifier<Set<String>>({});

  bool isSaved(String movieId) => ids.value.contains(movieId);

  void toggle(String movieId) {
    final updated = List<String>.from(ids.value);
    if (updated.contains(movieId)) {
      updated.remove(movieId);
    } else {
      updated.add(movieId);
    }
    ids.value = updated;
  }

  void remove(String movieId) {
    final updated = List<String>.from(ids.value)..remove(movieId);
    ids.value = updated;
  }

  bool isWatched(String movieId) => watchedIds.value.contains(movieId);

  void toggleWatched(String movieId) {
    final updated = Set<String>.from(watchedIds.value);
    if (!updated.add(movieId)) updated.remove(movieId);
    watchedIds.value = updated;
  }

  /// استبدال كل الحالة (بيتستخدم لما نحمّل بيانات المستخدم من السحابة).
  void setAll({required List<String> saved, required Set<String> watched}) {
    ids.value = saved;
    watchedIds.value = watched;
  }

  void clear() => setAll(saved: <String>[], watched: <String>{});
}
