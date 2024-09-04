import 'dart:io';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/pages/menu/Profile/EditNamePage.dart';
import 'package:beacon/pages/menu/Profile/EditProfilePicturePage.dart';
import 'package:beacon/services/AuthService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/ProfilePicWidget.dart';
import 'package:beacon/widgets/tiles/SubTitleText.dart';
import 'package:beacon/widgets/buttons/BeaconFlatButton.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double spacing = 6.0;
  File? _editedImage;
  String? downloadURL;
  ImageCropper ic = ImageCropper();

  Future getImage() async {
    // Clear any previous edited image
    _editedImage = null;

    // Pick image from gallery using ImagePicker
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Crop the image using the updated cropImage method
      _editedImage = await cropImage(File(image.path));
    }

    // If the image was cropped and edited, navigate to the next page
    if (_editedImage != null) {
      Navigator.of(context)
          .push(
            CustomPageRoute(
              builder: (context) => EditProfilePicturePage(
                image: PickedFile(image!.path),
                editedImage: _editedImage,
              ),
            ),
          )
          .then((value) => setState(() {}));
    }
  }

  Future<File?> cropImage(File imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      cropStyle: CropStyle.circle,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: Colors.orange,
          statusBarColor: Colors.black,
          backgroundColor: Colors.black,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );

    if (croppedFile != null) {
      return File(croppedFile.path); // Return cropped file path
    }

    return null; // Return null if cropping was canceled
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AuthService _auth = context.watch<AuthService>();
    UserModel user = context.read<UserService>().currentUser!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Profile",
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Stack(children: [
              ProfilePicture(
                user: user,
                onClicked: () {
                  getImage();
                },
                size: 70,
              ),
              Positioned(
                  bottom: -4,
                  right: -4,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 5.0)),
                    child: ClipOval(
                      child: Container(
                        color: theme.secondaryHeaderColor,
                        child: IconButton(
                            onPressed: () {
                              getImage();
                            },
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            )),
                      ),
                    ),
                  )),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 12),
            child: Text(
              "${user.firstName} ${user.lastName}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SubTitleText(text: "Profile"),
          BeaconFlatButton(
            icon: Icons.edit_outlined,
            title: 'Name',
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => EditNamePage()))
                  .then((value) => setState(() {}));
            },
          ),
        ],
      ),
    );
  }
}

class CustomPageRoute extends MaterialPageRoute {
  CustomPageRoute({builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}
