import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/models/movie.dart';
import '../../../core/widgets/app_image.dart';

/// صف أفقي بصور الممثلين وأسماءهم وأدوارهم.
class CastRow extends StatelessWidget {
  const CastRow({super.key, required this.cast});

  final List<CastMember> cast;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 118,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cast.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) {
          final member = cast[i];
          return SizedBox(
            width: 70,
            child: Column(
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: member.photoUrl == null
                        ? Container(
                            color: AppColors.surfaceHigh,
                            child: const Icon(Icons.person, color: AppColors.textDim),
                          )
                        : AppImage(member.photoUrl!),
                  ),
                ),
                const SizedBox(height: 6),
                Text(member.name,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.body(10.5, weight: FontWeight.w600, height: 1.2)),
              ],
            ),
          );
        },
      ),
    );
  }
}
