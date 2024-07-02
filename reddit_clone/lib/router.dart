import 'package:flutter/material.dart';
import 'package:reddit_clone_new/features/auth/screens/login_screen.dart';
import 'package:reddit_clone_new/features/community/screens/add_mods_screen.dart';
import 'package:reddit_clone_new/features/community/screens/community_screen.dart';
import 'package:reddit_clone_new/features/community/screens/create_community_screen.dart';
import 'package:reddit_clone_new/features/community/screens/edit_community_screen.dart';
import 'package:reddit_clone_new/features/community/screens/mod_tools_screen.dart';
import 'package:reddit_clone_new/features/home/screens/home_screen.dart';
import 'package:reddit_clone_new/features/post/screens/add_post_screen.dart';
import 'package:reddit_clone_new/features/post/screens/add_post_type_screen.dart';
import 'package:reddit_clone_new/features/post/screens/comments_screen.dart';
import 'package:reddit_clone_new/features/user_profile/screens/edit_profile_screen.dart';
import 'package:reddit_clone_new/features/user_profile/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: LoginScreen()),
  },
);

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: HomeScreen()),
    '/create-community': (_) =>
        const MaterialPage(child: CreateCommunityScreen()),
    '/r/:name': (route) => MaterialPage(
        child: CommunityScreen(communityName: route.pathParameters['name']!)),
    '/r/:name/mod-tools/:name': (route) => MaterialPage(
        child: ModToolsScreen(name: route.pathParameters['name']!)),
    '/r/:name/mod-tools/:name/edit-community/:name': (route) => MaterialPage(
        child: EditCommunityScreen(name: route.pathParameters['name']!)),
    '/r/:name/mod-tools/:name/add-mods/:name': (route) => MaterialPage(
        child: AddModsScreen(communityName: route.pathParameters['name']!)),
    '/u/:uid': (route) => MaterialPage(
        child: UserProfileScreen(uid: route.pathParameters['uid']!)),
    '/u/:uid/edit-profile/:uid': (route) => MaterialPage(
        child: EditProfileScreen(uid: route.pathParameters['uid']!)),
    '/add-post/:type': (route) => MaterialPage(
        child: AddPostTypeScreen(type: route.pathParameters['type']!)),
    '/posts/:postID/comments': (route) => MaterialPage(
        child: CommentsScreen(postID: route.pathParameters["postID"]!)),
    '/add-post': (route) => MaterialPage(child: AddPostsScreen()),
  },
);
