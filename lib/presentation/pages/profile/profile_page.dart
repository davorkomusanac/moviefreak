import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/user/user_watchlist_and_watched/user_watchlist_and_watched_cubit.dart';
import 'settings/settings_page.dart';
import 'widgets/movie_watched_tab.dart';
import 'widgets/movie_watchlist_tab.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  late final TabController _watchTypeTabController;
  final List<Tab> _tabs = <Tab>[
    const Tab(text: 'Watchlist'),
    const Tab(text: 'Watched'),
  ];

  @override
  void initState() {
    super.initState();
    _watchTypeTabController = TabController(
      initialIndex: 0,
      length: _tabs.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _watchTypeTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<UserWatchlistAndWatchedCubit, UserWatchlistAndWatchedState>(
        listener: (context, state) {
          if (state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                duration: const Duration(seconds: 1),
              ),
            );
          }
        },
        builder: (context, state) => Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              state.watchlistLength.toInt().toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              'Watchlist',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              state.watchedLength.toInt().toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              'Watched',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                            icon: const Icon(
                              Icons.settings,
                              size: 30,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SettingsPage(),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.blue,
                  child: const Divider(
                    height: 5,
                    thickness: 1,
                  ),
                ),
                Container(
                  color: Colors.blue,
                  child: TabBar(
                    controller: _watchTypeTabController,
                    tabs: _tabs,
                    indicatorColor: Colors.tealAccent,
                    indicatorWeight: 5,
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _watchTypeTabController,
                    children: const [
                      MovieWatchlistTab(),
                      MovieWatchedTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
