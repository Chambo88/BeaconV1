import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/buttons/BeaconFlatButton.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

class EditProfilePicturePage extends StatefulWidget {
  PickedFile image;
  EditProfilePicturePage({@required this.image});

  @override
  _EditProfilePicturePageState createState() => _EditProfilePicturePageState();
}

class _EditProfilePicturePageState extends State<EditProfilePicturePage> {
  File _editedImage;
  bool _loading = false;



  Future<File> cropImage(File imageFile) async {
    return await ImageCropper.cropImage(sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      aspectRatioPresets: [CropAspectRatioPreset.square],
      compressQuality: 80,
      cropStyle: CropStyle.circle,
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: '',
        toolbarColor: Colors.black,
        toolbarWidgetColor: Theme.of(context).accentColor,
        activeControlsWidgetColor: Theme.of(context).accentColor,
        statusBarColor: Colors.black
      ),
      iosUiSettings: IOSUiSettings(
        title: '',
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var userService = Provider.of<UserService>(context);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: TextButton(onPressed: () {Navigator.pop(context);}, child: Text("cancel",
          style: TextStyle(
            color: theme.accentColor,
          ),

        )),
        title: Text("Profile Picture"),
        actions: [
          (_loading == true)? SizedBox(
            height: 10,
            width: 30,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 10, 15),
              child: CircularProgressIndicator(
                color: theme.accentColor,

              ),
            ),
          ) :
          TextButton(
              onPressed: () async {
                setState(()  {
                  _loading = true;
                });
                await userService.changeProfilePic(_editedImage ?? File(widget.image.path));
                Navigator.pop(context);},
              child: Text(
                "Save",
                style: TextStyle(
                    color: theme.accentColor,
                    fontWeight: FontWeight.bold
                ),
              ),
          )
        ],
      ),
      body: Column(
        children: [
          Flexible(
            flex: 1,
              child: Container()
          ),
          Flexible(
            flex: 8,
            child: Center(
              child: CircleAvatar(
                radius: 120,
                child: ClipOval(
                  child: (_editedImage == null) ?
                  Image.file(File(widget.image.path)) :
                  Image.file(_editedImage),
                )
              ),
            ),
          ),
          Flexible(child:
          BeaconFlatButton(
            title: "Edit image",
            icon: Icons.image_outlined,
            onTap: () async {
              final file = await cropImage(File(widget.image.path));
              if (file != null) {
                _editedImage = file;
              }
              setState(() {

              });
            },
          ))
        ],
      ),
    );
  }
}


