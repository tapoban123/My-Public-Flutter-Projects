import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_new/constants/constants.dart';
import 'package:reddit_clone_new/core/common/error_text.dart';
import 'package:reddit_clone_new/core/common/loader.dart';
import 'package:reddit_clone_new/core/utils.dart';
import 'package:reddit_clone_new/features/community/controller/community_controller.dart';
import 'package:reddit_clone_new/models/community_model.dart';
import 'package:reddit_clone_new/responsive/responsive.dart';
import 'package:reddit_clone_new/theme/colors.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<EditCommunityScreen> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? avatarFile;
  Uint8List? bannerWebFile;
  Uint8List? profileWebFile;

  void selectAvatarImage() async {
    final result = await pickImage();

    if (result != null) {
      if (kIsWeb) {
        setState(() {
          profileWebFile = result.files.first.bytes;
        });
      } else {
        setState(() {
          avatarFile = File(result.files.first.path!);
        });
      }
    }
  }

  void save(Community community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
          profileFile: avatarFile,
          bannerFile: bannerFile,
          context: context,
          community: community,
          bannerWebFile: bannerWebFile,
          profileWebFile: profileWebFile,
        );
  }

  void selectBannerImage() async {
    final result = await pickImage();

    if (result != null) {
      if (kIsWeb) {
        setState(() {
          bannerWebFile = result.files.first.bytes;
        });
      } else {
        setState(() {
          bannerFile = File(result.files.first.path!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) => Scaffold(
            backgroundColor: currentTheme.colorScheme.background,
            appBar: AppBar(
              title: const Text("Edit Community"),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => save(community),
                  child: const Text("Save"),
                ),
              ],
            ),
            body: isLoading
                ? const Loader()
                : Responsive(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () => selectBannerImage(),
                                  child: DottedBorder(
                                    radius: const Radius.circular(10),
                                    dashPattern: const [3, 4],
                                    borderType: BorderType.RRect,
                                    strokeCap: StrokeCap.round,
                                    color: currentTheme
                                        .textTheme.bodyMedium!.color!,
                                    child: Container(
                                      width: double.infinity,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: bannerWebFile != null
                                          ? Image.memory(bannerWebFile!)
                                          : bannerFile != null
                                              ? Image.file(bannerFile!)
                                              : community.banner.isEmpty ||
                                                      community.banner ==
                                                          Constants
                                                              .bannerDefault
                                                  ? const Center(
                                                      child: Icon(
                                                        Icons.camera_alt,
                                                        size: 40,
                                                      ),
                                                    )
                                                  : Image.network(
                                                      community.banner),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 20,
                                  child: GestureDetector(
                                    onTap: () => selectAvatarImage(),
                                    child: profileWebFile != null
                                        ? CircleAvatar(
                                            backgroundImage:
                                                MemoryImage(profileWebFile!),
                                            radius: 32,
                                          )
                                        : avatarFile != null
                                            ? CircleAvatar(
                                                backgroundImage:
                                                    FileImage(avatarFile!),
                                                radius: 32,
                                              )
                                            : CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    community.avatar),
                                                radius: 32,
                                              ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          error: (error, stackTrace) => ErrorText(errorText: error.toString()),
          loading: () => const Loader(),
        );
  }
}
