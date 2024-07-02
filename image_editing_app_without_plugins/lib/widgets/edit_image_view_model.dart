import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_editing_app_without_plugins/models/text_info.dart';
import 'package:image_editing_app_without_plugins/screens/edit_image_screen.dart';
import 'package:image_editing_app_without_plugins/utils/utils.dart';
import 'package:image_editing_app_without_plugins/widgets/default_button.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

abstract class EditImageViewModel extends State<EditImageScreen> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController creatorText = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  List<TextInfo> texts = [];
  int currentIndex = 0;

  removeText(BuildContext context) {
    setState(() {
      texts.removeAt(currentIndex);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Deleted",
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  setCurrentIndex(BuildContext context, int index) {
    setState(() {
      currentIndex = index;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Selected for Styling",
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  saveImageToGallery(BuildContext context) {
    if (texts.isNotEmpty) {
      screenshotController.capture().then(
        (Uint8List? image) {
          saveImage(image!);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Image saved to gallery."),
            ),
          );
        },
      ).catchError((error) {
        debugPrint(error);
      });
    }
  }

  saveImage(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(":", "-");

    final name = "screenshot_$time";

    await requestPermission(Permission.storage);
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  changeTextColour(Color color) {
    setState(() {
      texts[currentIndex].color = color;
    });
  }

  increaseTextFontSize() {
    setState(() {
      texts[currentIndex].fontSize += 2;
    });
  }

  decreaseTextFontSize() {
    setState(() {
      texts[currentIndex].fontSize -= 2;
    });
  }

  changeTextStyle(FontStyle style) {
    setState(() {
      texts[currentIndex].fontStyle = style;
    });
  }

  alignLeftText() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.left;
    });
  }

  alignCenterText() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.center;
    });
  }

  alignRightText() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.right;
    });
  }

  italicText() {
    setState(() {
      if (texts[currentIndex].fontStyle == FontStyle.italic) {
        texts[currentIndex].fontStyle = FontStyle.normal;
      } else {
        texts[currentIndex].fontStyle = FontStyle.italic;
      }
    });
  }

  addLinesToText() {
    setState(() {
      if (texts[currentIndex].text.contains("\n")) {
        texts[currentIndex].text =
            texts[currentIndex].text.replaceAll("\n", " ");
      } else {
        texts[currentIndex].text =
            texts[currentIndex].text.replaceAll(" ", "\n");
      }
    });
  }

  boldText() {
    setState(() {
      if (texts[currentIndex].fontWeight == FontWeight.bold) {
        texts[currentIndex].fontWeight = FontWeight.normal;
      } else {
        texts[currentIndex].fontWeight = FontWeight.bold;
      }
    });
  }

  addNewText(BuildContext context) {
    setState(() {
      texts.add(
        TextInfo(
          text: textEditingController.text,
          left: 0,
          top: 0,
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          fontSize: 20,
          textAlign: TextAlign.left,
        ),
      );
    });

    Navigator.of(context).pop();
  }

  addNewDialog(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Text"),
        content: TextField(
          controller: textEditingController,
          maxLines: 5,
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.edit),
            filled: true,
            hintText: "Your Text Here...",
          ),
        ),
        actions: [
          DefaultButton(
            onPressed: () => Navigator.of(context).pop(),
            backgroundColor: Colors.white,
            textColor: Colors.black,
            child: const Text("Back"),
          ),
          DefaultButton(
            onPressed: () => addNewText(context),
            backgroundColor: Colors.red,
            textColor: Colors.white,
            child: const Text("Add Text"),
          )
        ],
      ),
    );
  }
}
