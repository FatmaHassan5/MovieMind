import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';

/// كارت الاقتباس اللي تحت أزرار اللوجين.
class QuoteCard extends StatelessWidget {
  const QuoteCard({super.key, required this.quote, required this.author});

  final String quote;
  final String author;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF19191F),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.movie_creation_outlined,
              size: 16, color: AppColors.textDim),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(quote,
                    style: AppText.body(12.5,
                        color: AppColors.textMuted,
                        weight: FontWeight.w400,
                        height: 1.45)
                        .copyWith(fontStyle: FontStyle.italic)),
                const SizedBox(height: 6),
                Text(author,
                    style: AppText.body(11.5,
                        color: AppColors.textDim, weight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
