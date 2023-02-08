import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../discover/discover_page.dart';
import '../profile/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<GlobalKey<NavigatorState>> tabNavKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  late final CupertinoTabController _tabController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = CupertinoTabController(initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CupertinoTabScaffold(
        controller: _tabController,
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return CupertinoTabView(
                navigatorKey: tabNavKeys[0],
                builder: (context) => const CupertinoPageScaffold(
                  child: DiscoverPage(),
                ),
              );
            case 1:
              return CupertinoTabView(
                navigatorKey: tabNavKeys[1],
                builder: (context) => const CupertinoPageScaffold(
                  child: ProfilePage(),
                ),
              );
            default:
              return CupertinoTabView(
                navigatorKey: tabNavKeys[0],
                builder: (context) => const CupertinoPageScaffold(
                  child: DiscoverPage(),
                ),
              );
          }
        },
        tabBar: CupertinoTabBar(
          activeColor: Colors.white,
          backgroundColor: Colors.blue,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
            ),
          ],
          onTap: (index) {
            currentIndex = index;
          },
        ),
      );
}
