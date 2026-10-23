

import 'package:flutter/material.dart';

import '../ai_chat/ai_chat_page.dart';
import '../home/home_page.dart';
import '../profile/profile_page.dart';
import '../search/search_page.dart';
import '../watchlist/watchlist_page.dart';
import 'widgets/bottom_nav_bar.dart';

/// الحاوية الرئيسية بعد تسجيل الدخول: بتحتفظ بحالة كل تاب
/// (IndexedStack) وتسمح بالتنقل الحر بين أي صفحة من أي صفحة.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _goTo(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onNavigate: _goTo),
      SearchPage(onNavigate: _goTo),
      const AiChatPage(),
      WatchlistPage(onNavigate: _goTo),
      ProfilePage(onNavigate: _goTo),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: BottomNavBar(index: _index, onChanged: _goTo),
    );
  }
}
