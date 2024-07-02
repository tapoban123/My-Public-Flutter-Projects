import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_new/core/common/error_text.dart';
import 'package:reddit_clone_new/core/common/loader.dart';
import 'package:reddit_clone_new/core/utils.dart';
import 'package:reddit_clone_new/features/community/controller/community_controller.dart';
import 'package:reddit_clone_new/features/post/controller/post_controller.dart';
import 'package:reddit_clone_new/models/community_model.dart';
import 'package:reddit_clone_new/theme/colors.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({
    super.key,
    required this.type,
  });

  @override
  ConsumerState<AddPostTypeScreen> createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  File? bannerFile;
  Community? selectedCommunity;
  List<Community> communities = [];
  Uint8List? bannerWebFile;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
  }

  void selectBannerImage() async {
    final result = await pickImage();

    if (result != null) {
      if (kIsWeb) {
        setState(() {
          bannerWebFile = result.files.first.bytes;
        });
      }
      setState(() {
        bannerFile = File(result.files.first.path!);
      });
    }
  }

  void sharePost() {
    if (widget.type == "image" &&
        (bannerFile != null || bannerWebFile != null) &&
        titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            imageFile: bannerFile,
            webFile: bannerWebFile,
          );
    } else if (widget.type == "text" && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            description: descriptionController.text.trim(),
          );
    } else if (widget.type == "link" &&
        linkController.text.isNotEmpty &&
        titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            link: linkController.text.trim(),
          );
    } else {
      showSnackBar(context, "Please enter all the fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isTypeImage = widget.type == "image";
    bool isTypeText = widget.type == "text";
    bool isTypeLink = widget.type == "link";

    final isLoading = ref.watch(postControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Post ${widget.type}"),
        actions: [
          TextButton(
            onPressed: sharePost,
            child: const Text("Share"),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "Enter Title here",
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.blue)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(18.0),
                    ),
                    maxLength: 30,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (isTypeImage)
                    GestureDetector(
                      onTap: () => selectBannerImage(),
                      child: DottedBorder(
                        radius: const Radius.circular(10),
                        dashPattern: const [3, 4],
                        borderType: BorderType.RRect,
                        strokeCap: StrokeCap.round,
                        color: currentTheme.textTheme.bodyMedium!.color!,
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
                                  : const Center(
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 40,
                                      ),
                                    ),
                        ),
                      ),
                    ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  if (isTypeText)
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: "Enter Description here",
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.blue)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(18.0),
                      ),
                      maxLines: 5,
                    ),

                  if (isTypeLink)
                    TextField(
                      controller: linkController,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: "Enter Title here",
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.blue)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(18.0),
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text("Select Community"),
                  ),
                  ref.watch(userCommunitiesProvider).when(
                        data: (data) {
                          communities = data;

                          if (data.isEmpty) {
                            return const SizedBox();
                          } else {
                            return DropdownButton(
                              value: selectedCommunity ?? data[0],
                              items: data
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.name),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCommunity = value;
                                });
                              },
                            );
                          }
                        },
                        error: (error, stackTrace) =>
                            ErrorText(errorText: error.toString()),
                        loading: () => const Loader(),
                      )
                ],
              ),
            ),
    );
  }
}
