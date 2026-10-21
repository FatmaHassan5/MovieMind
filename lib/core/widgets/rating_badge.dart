import 'package:flutter/material.dart';

import '../app_theme.dart';

/// بادج التقييم بالنجمة (زي "8.6") فوق بوسترات الأفلام.
class RatingBadge extends StatelessWidget {
  const RatingBadge({super.key, required this.rating});

  final String rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xCC000000),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 11, color: Color(0xFFFFC64B)),
          const SizedBox(width: 3),
          Text(rating,
              style: AppText.body(11, weight: FontWeight.w700, color: Colors.white)),
        ],
      ),
    );
  }
}
