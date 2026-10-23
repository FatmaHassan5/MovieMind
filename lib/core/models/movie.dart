

/// ممثل في طاقم العمل.
class CastMember {
  const CastMember({required this.name, this.character, this.photoUrl});

  final String name;
  final String? character;
  final String? photoUrl;
}

/// نموذج فيلم/مسلسل موحّد تستخدمه كل الشاشات (Home, Search, Watchlist, AI Mind).
/// البيانات جاية من TMDB، والـ id شكله `m123` للفيلم و`t456` للمسلسل.
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
    this.backdropUrl,
    this.tagline,
    this.cast = const [],
  });

  final String id;
  final String title;
  final String year;
  final String genre;

  /// رابط صورة البوستر (https) — اسم الحقل قديم، وبيقبل برضو مسار asset.
  final String posterAsset;

  /// التقييم من 10 (بالنجمة)، زي "8.6". null لو مفيش تصويتات.
  final String? rating;

  /// نسبة التطابق مع ذوقك (من غير علامة %) — بتتحسب في TasteUtils.
  final String? matchPercent;

  /// نص صغير تحت الكارت، زي "12.4k votes".
  final String? badge;

  /// المدة أو عدد المواسم، زي "2h 46m" أو "3 Seasons". بتتملى من صفحة التفاصيل.
  final String? duration;

  final String? description;
  final DateTime? releaseDate;
  final bool isTvShow;
  final String? backdropUrl;
  final String? tagline;
  final List<CastMember> cast;

  /// رقم الفيلم في TMDB.
  int? get tmdbId => id.length > 1 ? int.tryParse(id.substring(1)) : null;

  Movie copyWith({String? matchPercent}) => Movie(
        id: id,
        title: title,
        year: year,
        genre: genre,
        posterAsset: posterAsset,
        rating: rating,
        matchPercent: matchPercent ?? this.matchPercent,
        badge: badge,
        duration: duration,
        description: description,
        releaseDate: releaseDate,
        isTvShow: isTvShow,
        backdropUrl: backdropUrl,
        tagline: tagline,
        cast: cast,
      );

  /// بيملى أي حقل فاضي عندي من [fallback] (عشان بيانات القوائم المختصرة
  /// ما تمسحش التفاصيل اللي اتحملت قبل كده).
  Movie mergedWith(Movie fallback) => Movie(
        id: id,
        title: title,
        year: year.isNotEmpty ? year : fallback.year,
        genre: genre.isNotEmpty ? genre : fallback.genre,
        posterAsset: posterAsset.isNotEmpty ? posterAsset : fallback.posterAsset,
        rating: rating ?? fallback.rating,
        matchPercent: matchPercent ?? fallback.matchPercent,
        badge: badge ?? fallback.badge,
        duration: duration ?? fallback.duration,
        description: (description != null && description!.isNotEmpty)
            ? description
            : fallback.description,
        releaseDate: releaseDate ?? fallback.releaseDate,
        isTvShow: isTvShow,
        backdropUrl: backdropUrl ?? fallback.backdropUrl,
        tagline: tagline ?? fallback.tagline,
        cast: cast.isNotEmpty ? cast : fallback.cast,
      );

  /// نسخة مضغوطة بتتحفظ في Firestore (الـ Watchlist والمشاهدات).
  Map<String, dynamic> toMap() {
    final desc = description;
    return {
      'id': id,
      'title': title,
      'year': year,
      'genre': genre,
      'poster': posterAsset,
      'rating': rating,
      'match': matchPercent,
      'badge': badge,
      'duration': duration,
      'description': (desc != null && desc.length > 300) ? desc.substring(0, 300) : desc,
      'release': releaseDate?.toIso8601String(),
      'tv': isTvShow,
    };
  }

  static Movie? fromMap(Map<String, dynamic> map) {
    final id = map['id'];
    final title = map['title'];
    if (id is! String || title is! String) return null;
    String? str(String key) => map[key] is String ? map[key] as String : null;
    return Movie(
      id: id,
      title: title,
      year: str('year') ?? '',
      genre: str('genre') ?? '',
      posterAsset: str('poster') ?? '',
      rating: str('rating'),
      matchPercent: str('match'),
      badge: str('badge'),
      duration: str('duration'),
      description: str('description'),
      releaseDate: str('release') == null ? null : DateTime.tryParse(str('release')!),
      isTvShow: map['tv'] == true,
    );
  }
}
