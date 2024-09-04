import 'package:beacon/models/UserModel.dart';
import 'package:beacon/util/theme.dart';
import 'package:flutter/material.dart';

import '../ProfilePicWidget.dart';

class userListTile extends StatelessWidget {
  UserModel? user;
  String? subText;
  FigmaColours figmaColours = FigmaColours();
  Widget? trailing;

  userListTile({
    @required this.user,
    this.subText,
    this.trailing,
  });

  CircleAvatar getImage() {
    if (user!.imageURL == '') {
      return CircleAvatar(
        radius: 24,
        child: Text(
          '${user!.firstName![0].toUpperCase()}${user!.lastName![0].toUpperCase()}',
          style: TextStyle(
            color: Color(figmaColours.greyMedium),
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        backgroundColor: Color(figmaColours.greyLight),
      );
    } else {
      return CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(user!.imageURL!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          (subText == null) ? EdgeInsets.only(bottom: 10) : EdgeInsets.all(0),
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfilePicture(
              user: user,
            ),
          ],
        ),
        title: Text(
          "${user!.firstName} ${user!.lastName}",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        subtitle: (subText != null)
            ? Text(
                // subText,
                subText!,
                style: TextStyle(
                    fontSize: 16, color: Color(figmaColours.greyLight)),
              )
            : null,
        trailing: (trailing != null) ? trailing : null,
      ),
    );
  }
}
