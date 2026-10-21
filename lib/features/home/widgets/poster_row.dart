import 'package:flutter/material.dart';

import '../../../core/models/movie.dart';
import 'movie_poster_card.dart';

/// صف بوسترات أفقي. الارتفاع محسوب يدويًا (بوستر 2:3 + مسافة + سطرين نص)
/// عشان مايحصلش overflow تحت الكروت. بيتستخدم في Home وProfile.
class PosterRow extends StatelessWidget {
  const PosterRow({super.key, required this.movies});

  final List<Movie> movies;

  static const _cardWidth = 150.0;
  static const _rowHeight = 272.0; // (150 * 1.5) + 7 + ~40 (سطرين نص) + هامش أمان

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _rowHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => MoviePosterCard(movie: movies[i], width: _cardWidth),
      ),
    );
  }
}
