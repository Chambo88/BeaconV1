import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePicture extends StatelessWidget {
  final VoidCallback onClicked;
  final FigmaColours figmaColours = FigmaColours();
  final double size;
  final UserModel user;
  String url = '';

  ProfilePicture({
    this.onClicked,
    this.size = 24,
    @required this.user,
  });

  @override
  Widget build(BuildContext context) {
    if(user.imageURL != null) {
      url = user.imageURL;
    }
    return GestureDetector(
        onTap: onClicked ?? null,
        child: getImage()
    );
  }


  CircleAvatar getImage() {
    if (url == '') {


      return CircleAvatar(
        radius: size,
        child: Text(
          '${user.firstName[0].toUpperCase()}${user.lastName[0].toUpperCase()}',
          style: TextStyle(
            color: Color(figmaColours.greyMedium),
          ),
        ),
        backgroundColor: Color(figmaColours.greyLight),
      );
    } else {

      return CircleAvatar(
        radius: size,
        backgroundImage: NetworkImage(user.imageURL),
      );
    }
  }
}