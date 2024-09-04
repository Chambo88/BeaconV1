import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/buttons/SmallGradientButton.dart';
import 'package:beacon/widgets/buttons/SmallOutlinedButton.dart';
import 'package:beacon/widgets/tiles/userListTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserResultAddable extends StatefulWidget {
  final UserModel? anotherUser;

  UserResultAddable({this.anotherUser});

  @override
  _UserResultAddableState createState() => _UserResultAddableState();
}

class _UserResultAddableState extends State<UserResultAddable> {
  int? mutualFriends;
  FigmaColours figmaColours = FigmaColours();

  int getMutualFriends(List<String> userFriends, List<String> friendsFriends) {
    int num = 0;
    for (var user in userFriends) {
      for (var user2 in friendsFriends) {
        if (user == user2) {
          num++;
          break;
        }
      }
    }
      return num;
  }

  //Get The Trailing IconBUtton
  Widget checkFriendShipAndPendingStatus(UserService userService) {
    //Build cancel button this if friends request is pending

    if (userService.currentUser!.friends!.contains(widget.anotherUser!.id)) {
      return Container();
    }

    if (userService.currentUser!.receivedFriendRequests!
        .contains(widget.anotherUser!.id!)) {
      return SmallGradientButton(
          child: Text(
            "accept",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          onPressed: () async {
            userService.acceptFriendRequest(widget.anotherUser!);
            setState(() {});
          });
    }

    if (userService.currentUser!.sentFriendRequests!
        .contains(widget.anotherUser!.id)) {
      return SmallGradientButton(
          child: Text(
            "pending",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          onPressed: () async {
            userService.removeSentFriendRequest(widget.anotherUser!);
            setState(() {});
          });
      // );
      // return SmallOutlinedButton(
      //     title: "pending",
    } else {
      return SmallOutlinedButton(
          title: "add",
          icon: Icons.person_add_alt_1_outlined,
          onPressed: () async {
            userService.sendFriendRequest(widget.anotherUser!);
            setState(() {});
          });
    }
  }

  bool alreadyFriends(UserService userService) {
    if (userService.currentUser!.friends!.contains(widget.anotherUser)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var userService = Provider.of<UserService>(context);
    bool alreadyMates = alreadyFriends(userService);
    mutualFriends = getMutualFriends(
        userService.currentUser!.friends!, widget.anotherUser!.friends!);
    return userListTile(
      user: widget.anotherUser!,
      subText: alreadyMates ? "Friends" : "$mutualFriends mutual friends",
      trailing:
          alreadyMates ? null : checkFriendShipAndPendingStatus(userService),
    );
  }
}
