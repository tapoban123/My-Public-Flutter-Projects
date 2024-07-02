import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends StatelessWidget {
  final String name;
  const ModToolsScreen({
    super.key,
    required this.name,
  });
  void navigateToEditCommunity(BuildContext context) {
    Routemaster.of(context)
        .push('/r/$name/mod-tools/$name/edit-community/$name');
  }

  void navigateToModToolsScreen(BuildContext context) {
    Routemaster.of(context).push('/r/$name/mod-tools/$name/add-mods/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mod Tools"),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add_moderator),
            title: const Text("Add Moderators"),
            onTap: () => navigateToModToolsScreen(context),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Edit Community"),
            onTap: () => navigateToEditCommunity(context),
          )
        ],
      ),
    );
  }
}