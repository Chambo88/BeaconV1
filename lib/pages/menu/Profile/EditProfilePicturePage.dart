import 'package:beacon/services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

class EditProfilePicturePage extends StatefulWidget {
  PickedFile? image;
  File? editedImage;
  EditProfilePicturePage({@required this.image, @required this.editedImage});

  @override
  _EditProfilePicturePageState createState() => _EditProfilePicturePageState();
}

class _EditProfilePicturePageState extends State<EditProfilePicturePage> {
  bool _loading = false;
  ImageCropper ic = ImageCropper();

  Future<File?> cropImage(File imageFile) async {
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      cropStyle: CropStyle.circle,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Theme.of(context).secondaryHeaderColor,
          activeControlsWidgetColor: Theme.of(context).secondaryHeaderColor,
          statusBarColor: Colors.black,
          backgroundColor: Colors.black,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: '',
        ),
      ],
    );

    if (croppedFile != null) {
      return File(croppedFile.path); // Convert CroppedFile to File and return
    }

    return null; // Return null if no image was cropped
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var userService = Provider.of<UserService>(context);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "cancel",
              style: TextStyle(
                color: theme.secondaryHeaderColor,
              ),
            )),
        title: Text("Profile Picture"),
        actions: [
          (_loading == true)
              ? SizedBox(
                  height: 10,
                  width: 30,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 10, 15),
                    child: CircularProgressIndicator(
                      color: theme.secondaryHeaderColor,
                    ),
                  ),
                )
              : TextButton(
                  onPressed: () async {
                    setState(() {
                      _loading = true;
                    });
                    await userService.changeProfilePic(widget.editedImage!);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(
                        color: theme.secondaryHeaderColor,
                        fontWeight: FontWeight.bold),
                  ),
                )
        ],
      ),
      body: Column(
        children: [
          Flexible(flex: 2, child: Container()),
          Center(
            child: Container(
              width: 250,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: theme.secondaryHeaderColor, width: 2.0)),
              child: CircleAvatar(
                radius: 150,
                child: ClipOval(child: Image.file(widget.editedImage!)),
              ),
            ),
          ),
          Center(
            child: TextButton.icon(
              label: Text(
                "Edit Image",
                style: theme.textTheme.headlineSmall,
              ),
              icon: Icon(Icons.image_outlined),
              style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                  backgroundColor: WidgetStateProperty.all<Color>(
                      theme.secondaryHeaderColor),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: theme.secondaryHeaderColor)))),
              onPressed: () async {
                final file = await cropImage(File(widget.image!.path));
                if (file != null) {
                  widget.editedImage = file;
                }
                setState(() {});
              },
            ),
          ),
          Flexible(flex: 4, child: Container())
        ],
      ),
    );
  }
}
