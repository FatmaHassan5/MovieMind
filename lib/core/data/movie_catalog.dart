// import '../app_assets.dart';
// import '../models/movie.dart';

// // أفلام/مسلسلات ثابتة تُستخدم في أكتر من شاشة (Home, Search, Watchlist, AI Mind)
// // — مكان واحد للبيانات بدل تكرارها في كل شاشة لوحدها.

// const dunePartTwo = Movie(
//   id: 'dune-part-two',
//   title: 'Dune: Part Two',
//   year: '2024',
//   genre: 'Sci-Fi/Adv',
//   posterAsset: AppAssets.dune,
//   rating: '8.6',
//   matchPercent: '98',
//   duration: '2h 46m',
//   badge: '4K HDR',
//   description:
//       'Paul Atreides unites with Chani and the Fremen while seeking revenge '
//       'against the conspirators who destroyed his family.',
// );

// const oppenheimer = Movie(
//   id: 'oppenheimer',
//   title: 'Oppenheimer',
//   year: '2023',
//   genre: 'Drama/Bio',
//   posterAsset: AppAssets.oppenheimer,
//   rating: '8.9',
//   matchPercent: '96',
//   duration: '3h 0m',
//   badge: 'IMAX',
//   description:
//       'The story of American scientist J. Robert Oppenheimer and his role '
//       'in the development of the atomic bomb.',
// );

// const interstellar = Movie(
//   id: 'interstellar',
//   title: 'Interstellar',
//   year: '2014',
//   genre: 'Sci-Fi',
//   posterAsset: AppAssets.interstellar,
//   rating: '8.7',
//   matchPercent: '98',
//   duration: '2h 49m',
//   badge: '4K HDR',
//   description:
//       'A team of explorers travel through a wormhole in space in an '
//       'attempt to ensure humanity\'s survival.',
// );

// const theBatman = Movie(
//   id: 'the-batman',
//   title: 'The Batman',
//   year: '2022',
//   genre: 'Action/Crime',
//   posterAsset: AppAssets.batman,
//   rating: '7.8',
//   matchPercent: '90',
//   duration: '2h 56m',
//   badge: 'HD',
//   description:
//       'When a sadistic serial killer begins murdering Gotham\'s political '
//       'figures, Batman must unravel the mystery.',
// );

// const arrival = Movie(
//   id: 'arrival',
//   title: 'Arrival',
//   year: '2016',
//   genre: 'Mystery • Sci-Fi',
//   posterAsset: AppAssets.arrival,
//   rating: '8.0',
//   matchPercent: '94',
//   duration: '1h 56m',
//   badge: 'HD',
//   description:
//       'A linguist is recruited to communicate with alien visitors, unlocking '
//       'a non-linear understanding of time itself.',
// );

// const contact = Movie(
//   id: 'contact',
//   title: 'Contact',
//   year: '1997',
//   genre: 'Cosmic • Drama',
//   posterAsset: AppAssets.contact,
//   rating: '7.5',
//   matchPercent: '92',
//   duration: '2h 30m',
//   badge: '4K Remaster',
//   description:
//       'A scientist receives an interstellar message and becomes the first '
//       'human selected to make contact with an alien civilization.',
// );

// const inception = Movie(
//   id: 'inception',
//   title: 'Inception',
//   year: '2010',
//   genre: 'Sci-Fi • Thriller',
//   posterAsset: AppAssets.inception,
//   rating: '8.8',
//   matchPercent: '96',
//   duration: '2h 28m',
//   badge: 'Dolby Vision',
//   description:
//       'A thief who enters people\'s dreams to steal secrets is offered a '
//       'chance to have his criminal history erased.',
// );

// const theMartian = Movie(
//   id: 'the-martian',
//   title: 'The Martian',
//   year: '2015',
//   genre: 'Sci-Fi • Survival',
//   posterAsset: AppAssets.martian,
//   rating: '8.0',
//   matchPercent: '89',
//   duration: '2h 24m',
//   badge: '4K',
//   description:
//       'An astronaut becomes stranded on Mars and must find a way to signal '
//       'Earth that he is alive while awaiting rescue.',
// );

// const spaceOdyssey = Movie(
//   id: 'space-odyssey',
//   title: '2001: Space Odyssey',
//   year: '1968',
//   genre: 'Classic • Sci-Fi',
//   posterAsset: AppAssets.spaceOdyssey,
//   rating: '8.3',
//   matchPercent: '87',
//   duration: '2h 29m',
//   badge: 'Cult',
//   description:
//       'A voyage to Jupiter with the sentient computer HAL after the '
//       'discovery of a mysterious black monolith.',
// );

// const gladiatorTwo = Movie(
//   id: 'gladiator-ii',
//   title: 'Gladiator II',
//   year: '2024',
//   genre: 'Action • Historical • Drama',
//   posterAsset: AppAssets.gladiator,
//   badge: 'HD',
//   releaseLabel: 'Nov 2024',
//   description:
//       'Years after Maximus\' death, Lucius is forced into the Colosseum '
//       'after his home is conquered by two tyrannical emperors.',
// );

// const deadpoolWolverine = Movie(
//   id: 'deadpool-wolverine',
//   title: 'Deadpool & Wolverine',
//   year: '2024',
//   genre: 'Action • Comedy • Sci-Fi',
//   posterAsset: AppAssets.deadpool,
//   badge: 'HD',
//   releaseLabel: 'Jul 2024',
//   description:
//       'Deadpool is offered a place in the Time Variance Authority and '
//       'teams up with a reluctant Wolverine.',
// );

// const poorThings = Movie(
//   id: 'poor-things',
//   title: 'Poor Things',
//   year: '2023',
//   genre: 'Comedy/Drama',
//   posterAsset: AppAssets.poorThings,
//   rating: '7.9',
//   matchPercent: '91',
//   duration: '2h 21m',
//   description:
//       'The incredible tale about the fantastical evolution of Bella Baxter, '
//       'brought back to life by a brilliant scientist.',
// );

// const severance = Movie(
//   id: 'severance',
//   title: 'Severance',
//   year: '2022',
//   genre: 'Sci-Fi Thriller',
//   posterAsset: AppAssets.severance,
//   rating: '8.7',
//   matchPercent: '99',
//   duration: 'Season 1',
//   badge: 'TV',
//   isTvShow: true,
//   description:
//       'Mark leads a team of office workers whose memories have been '
//       'surgically divided between their work and personal lives.',
// );

// const theBear = Movie(
//   id: 'the-bear',
//   title: 'The Bear',
//   year: '2022',
//   genre: 'Drama',
//   posterAsset: AppAssets.theBear,
//   rating: '8.6',
//   matchPercent: '94',
//   duration: 'Season 2',
//   badge: 'TV',
//   isTvShow: true,
//   description:
//       'A young fine-dining chef returns home to manage his deceased '
//       'brother\'s gritty Chicago sandwich shop.',
// );

// const pastLives = Movie(
//   id: 'past-lives',
//   title: 'Past Lives',
//   year: '2023',
//   genre: 'Romance',
//   posterAsset: AppAssets.pastLives,
//   rating: '7.8',
//   matchPercent: '92',
//   duration: '1h 45m',
//   description:
//       'Nora and Hae Sung, two deeply connected childhood friends, are '
//       'reunited decades later in New York.',
// );

// /// كل الأفلام/المسلسلات في مكان واحد — المرجع الوحيد للبحث والتفاصيل.
// abstract class MovieCatalog {
//   static const all = <Movie>[
//     dunePartTwo,
//     oppenheimer,
//     interstellar,
//     theBatman,
//     arrival,
//     contact,
//     inception,
//     theMartian,
//     spaceOdyssey,
//     gladiatorTwo,
//     deadpoolWolverine,
//     poorThings,
//     severance,
//     theBear,
//     pastLives,
//   ];

//   static const trending = [dunePartTwo, oppenheimer];
//   static const popular = [interstellar, theBatman, arrival];
//   static const comingSoon = [gladiatorTwo, deadpoolWolverine];

//   /// العناصر اللي بتبدأ محفوظة في الـ Watchlist (بيانات تجريبية).
//   static const watchlistSeed = [
//     dunePartTwo,
//     oppenheimer,
//     poorThings,
//     severance,
//     theBear,
//     pastLives,
//   ];

//   static Movie? byId(String id) {
//     for (final m in all) {
//       if (m.id == id) return m;
//     }
//     return null;
//   }

//   /// بحث فعلي بالاسم (case-insensitive) — ده اللي بيخلي حقل البحث شغال.
//   static List<Movie> search(String query) {
//     final q = query.trim().toLowerCase();
//     if (q.isEmpty) return all;
//     return all.where((m) => m.title.toLowerCase().contains(q)).toList();
//   }
// }

import '../app_assets.dart';
import '../models/movie.dart';
import '../utils/app_dates.dart';

// أفلام/مسلسلات ثابتة تُستخدم في أكتر من شاشة (Home, Search, Watchlist, AI Mind)
// — مكان واحد للبيانات بدل تكرارها في كل شاشة لوحدها.

const dunePartTwo = Movie(
  id: 'dune-part-two',
  title: 'Dune: Part Two',
  year: '2024',
  genre: 'Sci-Fi/Adv',
  posterAsset: AppAssets.dune,
  rating: '8.6',
  matchPercent: '98',
  duration: '2h 46m',
  badge: '4K HDR',
  description:
      'Paul Atreides unites with Chani and the Fremen while seeking revenge '
      'against the conspirators who destroyed his family.',
);

const oppenheimer = Movie(
  id: 'oppenheimer',
  title: 'Oppenheimer',
  year: '2023',
  genre: 'Drama/Bio',
  posterAsset: AppAssets.oppenheimer,
  rating: '8.9',
  matchPercent: '96',
  duration: '3h 0m',
  badge: 'IMAX',
  description:
      'The story of American scientist J. Robert Oppenheimer and his role '
      'in the development of the atomic bomb.',
);

const interstellar = Movie(
  id: 'interstellar',
  title: 'Interstellar',
  year: '2014',
  genre: 'Sci-Fi',
  posterAsset: AppAssets.interstellar,
  rating: '8.7',
  matchPercent: '98',
  duration: '2h 49m',
  badge: '4K HDR',
  description:
      'A team of explorers travel through a wormhole in space in an '
      'attempt to ensure humanity\'s survival.',
);

const theBatman = Movie(
  id: 'the-batman',
  title: 'The Batman',
  year: '2022',
  genre: 'Action/Crime',
  posterAsset: AppAssets.batman,
  rating: '7.8',
  matchPercent: '90',
  duration: '2h 56m',
  badge: 'HD',
  description:
      'When a sadistic serial killer begins murdering Gotham\'s political '
      'figures, Batman must unravel the mystery.',
);

const arrival = Movie(
  id: 'arrival',
  title: 'Arrival',
  year: '2016',
  genre: 'Mystery • Sci-Fi',
  posterAsset: AppAssets.arrival,
  rating: '8.0',
  matchPercent: '94',
  duration: '1h 56m',
  badge: 'HD',
  description:
      'A linguist is recruited to communicate with alien visitors, unlocking '
      'a non-linear understanding of time itself.',
);

const contact = Movie(
  id: 'contact',
  title: 'Contact',
  year: '1997',
  genre: 'Cosmic • Drama',
  posterAsset: AppAssets.contact,
  rating: '7.5',
  matchPercent: '92',
  duration: '2h 30m',
  badge: '4K Remaster',
  description:
      'A scientist receives an interstellar message and becomes the first '
      'human selected to make contact with an alien civilization.',
);

const inception = Movie(
  id: 'inception',
  title: 'Inception',
  year: '2010',
  genre: 'Sci-Fi • Thriller',
  posterAsset: AppAssets.inception,
  rating: '8.8',
  matchPercent: '96',
  duration: '2h 28m',
  badge: 'Dolby Vision',
  description:
      'A thief who enters people\'s dreams to steal secrets is offered a '
      'chance to have his criminal history erased.',
);

const theMartian = Movie(
  id: 'the-martian',
  title: 'The Martian',
  year: '2015',
  genre: 'Sci-Fi • Survival',
  posterAsset: AppAssets.martian,
  rating: '8.0',
  matchPercent: '89',
  duration: '2h 24m',
  badge: '4K',
  description:
      'An astronaut becomes stranded on Mars and must find a way to signal '
      'Earth that he is alive while awaiting rescue.',
);

const spaceOdyssey = Movie(
  id: 'space-odyssey',
  title: '2001: Space Odyssey',
  year: '1968',
  genre: 'Classic • Sci-Fi',
  posterAsset: AppAssets.spaceOdyssey,
  rating: '8.3',
  matchPercent: '87',
  duration: '2h 29m',
  badge: 'Cult',
  description:
      'A voyage to Jupiter with the sentient computer HAL after the '
      'discovery of a mysterious black monolith.',
);

// تواريخ الإصدار هنا تجريبية ومحسوبة من تاريخ النهارده، استبدليها بتواريخ حقيقية من الـ API.
final gladiatorTwo = Movie(
  id: 'gladiator-ii',
  title: 'Gladiator II',
  year: '2024',
  genre: 'Action • Historical • Drama',
  posterAsset: AppAssets.gladiator,
  badge: 'HD',
  releaseDate: AppDates.daysFromToday(9),
  description:
      'Years after Maximus\' death, Lucius is forced into the Colosseum '
      'after his home is conquered by two tyrannical emperors.',
);

final deadpoolWolverine = Movie(
  id: 'deadpool-wolverine',
  title: 'Deadpool & Wolverine',
  year: '2024',
  genre: 'Action • Comedy • Sci-Fi',
  posterAsset: AppAssets.deadpool,
  badge: 'HD',
  releaseDate: AppDates.daysFromToday(24),
  description:
      'Deadpool is offered a place in the Time Variance Authority and '
      'teams up with a reluctant Wolverine.',
);

const poorThings = Movie(
  id: 'poor-things',
  title: 'Poor Things',
  year: '2023',
  genre: 'Comedy/Drama',
  posterAsset: AppAssets.poorThings,
  rating: '7.9',
  matchPercent: '91',
  duration: '2h 21m',
  description:
      'The incredible tale about the fantastical evolution of Bella Baxter, '
      'brought back to life by a brilliant scientist.',
);

const severance = Movie(
  id: 'severance',
  title: 'Severance',
  year: '2022',
  genre: 'Sci-Fi Thriller',
  posterAsset: AppAssets.severance,
  rating: '8.7',
  matchPercent: '99',
  duration: 'Season 1',
  badge: 'TV',
  isTvShow: true,
  description:
      'Mark leads a team of office workers whose memories have been '
      'surgically divided between their work and personal lives.',
);

const theBear = Movie(
  id: 'the-bear',
  title: 'The Bear',
  year: '2022',
  genre: 'Drama',
  posterAsset: AppAssets.theBear,
  rating: '8.6',
  matchPercent: '94',
  duration: 'Season 2',
  badge: 'TV',
  isTvShow: true,
  description:
      'A young fine-dining chef returns home to manage his deceased '
      'brother\'s gritty Chicago sandwich shop.',
);

const pastLives = Movie(
  id: 'past-lives',
  title: 'Past Lives',
  year: '2023',
  genre: 'Romance',
  posterAsset: AppAssets.pastLives,
  rating: '7.8',
  matchPercent: '92',
  duration: '1h 45m',
  description:
      'Nora and Hae Sung, two deeply connected childhood friends, are '
      'reunited decades later in New York.',
);

/// كل الأفلام/المسلسلات في مكان واحد — المرجع الوحيد للبحث والتفاصيل.
abstract class MovieCatalog {
  static final all = <Movie>[
    dunePartTwo,
    oppenheimer,
    interstellar,
    theBatman,
    arrival,
    contact,
    inception,
    theMartian,
    spaceOdyssey,
    gladiatorTwo,
    deadpoolWolverine,
    poorThings,
    severance,
    theBear,
    pastLives,
  ];

  static const trending = [dunePartTwo, oppenheimer];
  static const popular = [interstellar, theBatman, arrival];

  /// كل الأفلام اللي لها تاريخ إصدار، مرتبة بالأقرب أولًا (بيستخدمها الـ Calendar).
  static List<Movie> get scheduled {
    final list = all.where((m) => m.releaseDate != null).toList()
      ..sort((a, b) => a.releaseDate!.compareTo(b.releaseDate!));
    return list;
  }

  /// الأفلام اللي لسه ما طلعتش (النهارده أو بعده) — بتظهر في Coming Soon.
  static List<Movie> get upcoming {
    final today = AppDates.today();
    return scheduled.where((m) => !m.releaseDate!.isBefore(today)).toList();
  }

  /// العناصر اللي بتبدأ محفوظة في الـ Watchlist (بيانات تجريبية).
  static const watchlistSeed = [
    dunePartTwo,
    oppenheimer,
    poorThings,
    severance,
    theBear,
    pastLives,
  ];

  static Movie? byId(String id) {
    for (final m in all) {
      if (m.id == id) return m;
    }
    return null;
  }

  /// بحث فعلي بالاسم (case-insensitive) — ده اللي بيخلي حقل البحث شغال.
  static List<Movie> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return all.where((m) => m.title.toLowerCase().contains(q)).toList();
  }
}
