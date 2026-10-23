

import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/widgets/pill_chip.dart';

/// شريط تصنيفات أفقي. بيبلّغ عن التصنيف المختار (null = All).
class GenreChips extends StatefulWidget {
  const GenreChips({super.key, required this.onChanged});

  final ValueChanged<String?> onChanged;

  @override
  State<GenreChips> createState() => _GenreChipsState();
}

class _GenreChipsState extends State<GenreChips> {
  static const _genres = [
    'All', 'Action', 'Sci-Fi', 'Drama', 'Comedy', 'Horror', 'Thriller', 'Romance',
  ];
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _genres.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final selected = i == _selected;
          return GestureDetector(
            onTap: () {
              setState(() => _selected = i);
              widget.onChanged(i == 0 ? null : _genres[i]);
            },
            child: PillChip(
              label: _genres[i],
              fontSize: 12.5,
              background: selected ? AppColors.primary : AppColors.surface,
              foreground: selected ? AppColors.onPrimary : AppColors.text,
              weight: selected ? FontWeight.w700 : FontWeight.w600,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            ),
          );
        },
      ),
    );
  }
}
