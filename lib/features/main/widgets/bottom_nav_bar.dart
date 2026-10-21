import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';

class NavItem {
  const NavItem(this.icon, this.activeIcon, this.label);
  final IconData icon;
  final IconData activeIcon;
  final String label;
}

/// شريط التنقل السفلي المشترك بين كل الصفحات الرئيسية.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  static const _items = [
    NavItem(Icons.home_outlined, Icons.home_rounded, 'Home'),
    NavItem(Icons.search, Icons.search, 'Search'),
    NavItem(Icons.auto_awesome_outlined, Icons.auto_awesome, 'AI Mind'),
    NavItem(Icons.bookmark_border, Icons.bookmark, 'Watchlist'),
    NavItem(Icons.person_outline, Icons.person, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: List.generate(_items.length, (i) {
              final selected = i == index;
              final item = _items[i];
              return Expanded(
                child: InkWell(
                  onTap: () => onChanged(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selected
                              ? AppColors.primary.withOpacity(0.16)
                              : Colors.transparent,
                        ),
                        child: Icon(
                          selected ? item.activeIcon : item.icon,
                          size: 21,
                          color: selected ? AppColors.primary : AppColors.textDim,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(item.label,
                          style: AppText.body(10,
                              color: selected ? AppColors.primary : AppColors.textDim,
                              weight: selected ? FontWeight.w700 : FontWeight.w500)),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
