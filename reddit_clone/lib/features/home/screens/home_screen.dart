import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_new/constants/constants.dart';
import 'package:reddit_clone_new/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone_new/features/home/delegates/search_community_delegate.dart';
import 'package:reddit_clone_new/features/home/drawers/community_list_drawer.dart';
import 'package:reddit_clone_new/features/home/drawers/profile_drawer.dart';
import 'package:reddit_clone_new/theme/colors.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _pageNumber = 0;

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayProfileDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChanged(int page) {
    setState(() {
      _pageNumber = page;
    });
  }

  void navigateToAddPostScreenOnWeb(BuildContext context) {
    Routemaster.of(context).push("/add-post");
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: false,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => displayDrawer(context),
            icon: const Icon(Icons.menu),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: SearchCommunityDelegate(ref: ref));
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () =>navigateToAddPostScreenOnWeb(context),
            icon: const Icon(Icons.add),
          ),
          Builder(
            builder: (context) => IconButton(
              onPressed: () => displayProfileDrawer(context),
              icon: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
              ),
            ),
          ),
        ],
      ),
      drawer: const CommunityListDrawer(),
      endDrawer: isGuest ? null : const ProfileDrawer(),
      body: IndexedStack(
        index: _pageNumber,
        children: Constants.tabWidgets,
      ),
      bottomNavigationBar: isGuest || kIsWeb
          ? null
          : CupertinoTabBar(
              activeColor: currentTheme.iconTheme.color,
              backgroundColor: currentTheme.colorScheme.background,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home)),
                BottomNavigationBarItem(icon: Icon(Icons.add)),
              ],
              onTap: onPageChanged,
              currentIndex: _pageNumber,
            ),
    );
  }
}
