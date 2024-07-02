import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_new/core/common/error_text.dart';
import 'package:reddit_clone_new/core/common/loader.dart';
import 'package:reddit_clone_new/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone_new/features/community/controller/community_controller.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String communityName;
  const AddModsScreen({
    super.key,
    required this.communityName,
  });

  @override
  ConsumerState<AddModsScreen> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  Set<String> uids = {};
  int counter = 0;

  void addUid(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUid(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void saveMods() {
    ref.read(communityControllerProvider.notifier).addMods(
          widget.communityName,
          uids.toList(),
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: saveMods,
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.communityName)).when(
            data: (community) => ListView.builder(
              itemCount: community.members.length,
              itemBuilder: (context, index) {
                final member = community.members[index];

                return ref.watch(getUserDataProvider(member)).when(
                      data: (user) {
                        if (community.mods.contains(member) && counter == 0) {
                          uids.add(member);
                        }

                        counter++;

                        return CheckboxListTile(
                          value: uids.contains(user.uid),
                          onChanged: (value) {
                            if (value!) {
                              addUid(user.uid);
                            } else {
                              removeUid(user.uid);
                            }
                          },
                          title: Text(user.name),
                        );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(errorText: error.toString()),
                      loading: () => const Loader(),
                    );
              },
            ),
            error: (error, stackTrace) =>
                ErrorText(errorText: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
