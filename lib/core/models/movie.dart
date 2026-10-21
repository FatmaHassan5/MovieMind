// /// نموذج فيلم/مسلسل موحّد تستخدمه كل الشاشات (Home, Search, Watchlist, AI Mind)
// /// بدل تكرار نفس البيانات في موديلات منفصلة لكل شاشة.
// class Movie {
//   const Movie({
//     required this.id,
//     required this.title,
//     required this.year,
//     required this.genre,
//     required this.posterAsset,
//     this.rating,
//     this.matchPercent,
//     this.badge,
//     this.duration,
//     this.description,
//     this.releaseLabel,
//     this.isTvShow = false,
//   });

//   /// معرّف فريد وثابت (مستخدم في منطق الـ Watchlist). مثال: 'dune-part-two'.
//   final String id;
//   final String title;
//   final String year;
//   final String genre;
//   final String posterAsset;

//   /// التقييم بالنجمة، زي "8.6". null لأفلام لسه ما طلعتش (Coming Soon).
//   final String? rating;

//   /// نسبة التطابق (من غير علامة %)، زي "98".
//   final String? matchPercent;

//   /// تاج جودة قصير، زي "4K" أو "Dolby Vision" أو "HD".
//   final String? badge;

//   /// المدة أو الموسم، زي "2h 46m" أو "Season 1".
//   final String? duration;

//   /// وصف قصير يظهر في صفحة التفاصيل والـ Watchlist.
//   final String? description;

//   /// تسمية الإصدار لأفلام Coming Soon، زي "Nov 2024".
//   final String? releaseLabel;

//   final bool isTvShow;
// }

/// نموذج فيلم/مسلسل موحّد تستخدمه كل الشاشات (Home, Search, Watchlist, AI Mind)
/// بدل تكرار نفس البيانات في موديلات منفصلة لكل شاشة.
class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.genre,
    required this.posterAsset,
    this.rating,
    this.matchPercent,
    this.badge,
    this.duration,
    this.description,
    this.releaseDate,
    this.isTvShow = false,
  });

  /// معرّف فريد وثابت (مستخدم في منطق الـ Watchlist). مثال: 'dune-part-two'.
  final String id;
  final String title;
  final String year;
  final String genre;
  final String posterAsset;

  /// التقييم بالنجمة، زي "8.6". null لأفلام لسه ما طلعتش (Coming Soon).
  final String? rating;

  /// نسبة التطابق (من غير علامة %)، زي "98".
  final String? matchPercent;

  /// تاج جودة قصير، زي "4K" أو "Dolby Vision" أو "HD".
  final String? badge;

  /// المدة أو الموسم، زي "2h 46m" أو "Season 1".
  final String? duration;

  /// وصف قصير يظهر في صفحة التفاصيل والـ Watchlist.
  final String? description;

  /// تاريخ الإصدار لأفلام Coming Soon (بيتستخدم في الـ Calendar).
  final DateTime? releaseDate;

  final bool isTvShow;
}
