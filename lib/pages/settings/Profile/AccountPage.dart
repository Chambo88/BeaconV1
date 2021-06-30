import 'dart:io';

import 'package:beacon/models/UserModel.dart';
import 'package:beacon/pages/settings/Profile/EditNamePage.dart';
import 'package:beacon/pages/settings/Profile/EditPasswordPage.dart';
import 'package:beacon/services/AuthService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/ProfilePicWidget.dart';
import 'package:beacon/widgets/SubTitleText.dart';
import 'package:beacon/widgets/buttons/BeaconFlatButton.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  double spacing = 6.0;
  PickedFile _image;

  Future getImage() async {
    var image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image path ${_image.path}');
    });
  }

  Future uploadPic(BuildContext context) async {
    String fileName = _image.path;
    Reference firebaseStoragRef = FirebaseStorage.instance.ref(fileName);
    UploadTask uploadTask = firebaseStoragRef.putFile(File(_image.path));
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete();
  }

  @override
  Widget build(BuildContext context) {
    
    final theme = Theme.of(context);
    final AuthService _auth = context.watch<AuthService>();
    UserModel user = context.read<UserService>().currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Account",
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: ProfilePicture(
              user: user,
              onClicked: () {
                getImage();
              },
              size: 60,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 12),
            child: Text(
                "${user.firstName} ${user.lastName}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold

              ),
            ),
          ),
          SubTitleText(text: "Profile"),
          BeaconFlatButton(
            icon: Icons.edit_outlined,
            title: 'Name',
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditNamePage())).then((value) => setState(() {}));

            },
          ),
          BeaconFlatButton(
            icon: Icons.password_outlined,
            title: 'Password',
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditPasswordPage()));
            },
          ),
          BeaconFlatButton(
            icon: Icons.logout_outlined,
            title: 'Log Out',
            onTap: () async {
              await _auth.signOut();
              Navigator.of(context).pop();
            },
          ),

        ],
      ),
    );
  }
}



