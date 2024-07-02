import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_new/core/common/loader.dart';
import 'package:reddit_clone_new/features/community/controller/community_controller.dart';
import 'package:reddit_clone_new/responsive/responsive.dart';
import 'package:reddit_clone_new/theme/colors.dart';
import 'package:routemaster/routemaster.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<CreateCommunityScreen> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final TextEditingController communityNameController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
  }

  void createCommunity() {
    ref.read(communityControllerProvider.notifier).createCommunity(
          communityNameController.text.trim(),
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a community"),
      ),
      body: isLoading
          ? const Loader()
          : Responsive(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text("Community name"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "r/Community_name",
                        filled: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18),
                      ),
                      controller: communityNameController,
                      maxLength: 21,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: createCommunity,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: Pallete.blueColor,
                      ),
                      child: const Text(
                        "Create community",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
