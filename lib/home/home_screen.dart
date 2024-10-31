import 'package:esports_app/community/community_page.dart';
import 'package:esports_app/home/home_page.dart';
import 'package:esports_app/home/profile_page.dart';
import 'package:esports_app/tournaments/tournaments_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static Route getRoute() {
    return MaterialPageRoute<void>(
      builder: (_) => const HomeScreen(),
    );
  }

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  bool shadowColor = false;
  double? scrolledUnderElevation;

  final List<Widget> pages = [
    const HomePage(),
    const CommunityPage(),
    const TournamentsPage(),
    ProfilePage(),
  ];

  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.onlyShowSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Esports app'),
        scrolledUnderElevation: scrolledUnderElevation,
        shadowColor: shadowColor ? Theme.of(context).colorScheme.shadow : null,
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        labelBehavior: labelBehavior,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.person_3),
            selectedIcon: Icon(CupertinoIcons.person_3_fill),
            label: 'Community',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.game_controller),
            selectedIcon: Icon(CupertinoIcons.game_controller_solid),
            label: 'Tournaments',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_2_outlined),
            selectedIcon: Icon(Icons.person_2),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
