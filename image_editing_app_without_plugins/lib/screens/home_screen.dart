import 'package:flutter/material.dart';
import 'package:image_editing_app_without_plugins/screens/edit_image_screen.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          onPressed: () async {
            XFile? imageFile = await ImagePicker().pickImage(
              source: ImageSource.gallery,
            );

            if (imageFile != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      EditImageScreen(selectedImage: imageFile.path),
                ),
              );
            }
          },
          icon: const Icon(
            Icons.upload_file,
            size: 150,
          ),
        ),
      ),
    );
  }
}
