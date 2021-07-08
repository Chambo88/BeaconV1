import 'package:beacon/library/ColorHelper.dart';
import 'package:beacon/models/GroupModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/buttons/GradientButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddToGroupsDialog extends StatefulWidget {

  UserModel otherUser;
  AddToGroupsDialog({
    @required this.otherUser,
  });

  @override
  _AddToGroupsDialogState createState() => _AddToGroupsDialogState();
}

class _AddToGroupsDialogState extends State<AddToGroupsDialog> {

  List<GroupModel> groupsModified;
  FigmaColours figmaColours = FigmaColours();
  List<GroupModel> groupsForComparison;
  List<GroupModel> groupsToRemoveFrom;
  List<GroupModel>groupsToAddTo;


  @override
  void initState() {
    super.initState();
    UserService userService = context.read<UserService>();
    groupsModified = [];
    groupsForComparison = [];
    groupsToRemoveFrom = [];
    groupsToAddTo = [];
    for (GroupModel group in userService.currentUser.groups) {
      if(group.members.contains(widget.otherUser.id)) {
        groupsModified.add(group);
        groupsForComparison.add(group);
      }
    }
  }

  void getGroupsToAddTo() {
    for (GroupModel group in groupsModified) {
      if(!groupsForComparison.contains(group)) {
        groupsToAddTo.add(group);
      }
    }
  }

  void getGroupsToRemoveFrom() {

    for (GroupModel group in groupsForComparison) {
      if(!groupsModified.contains(group)) {
        groupsToRemoveFrom.add(group);
      }
    }
  }



  Color getCheckboxColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  void excecuteChanges(UserService userService) {
    getGroupsToAddTo();
    getGroupsToRemoveFrom();
    for(GroupModel group in groupsToAddTo) {
      GroupModel temp = GroupModel.clone(group);
      temp.addId(widget.otherUser.id);
      userService.removeGroup(group);
      userService.addGroup(temp);
    }
    for(GroupModel group in groupsToRemoveFrom) {
      GroupModel temp = GroupModel.clone(group);
      temp.removeId(widget.otherUser.id);
      userService.removeGroup(group);
      userService.addGroup(temp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = context.read<UserService>();
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Color(figmaColours.greyDark),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(12),
              child: Stack(
                alignment: Alignment.center,
                children: [

                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Add to Groups",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                      color: Color(figmaColours.greyDark),
                      child: IconButton(
                        icon: Icon(Icons.close_rounded),
                        color: Color(figmaColours.greyLight),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: ListView(

                  children: userService.currentUser.groups.map((group) {
                    return Material(
                      child: ListTile(
                        tileColor: Color(figmaColours.greyDark),
                        leading: Icon(
                          group.icon,
                          color: Color(figmaColours.greyLight),
                        ),
                        title: Text(
                          group.name,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        trailing: Checkbox(
                          fillColor: MaterialStateProperty.resolveWith(getCheckboxColor),
                          checkColor: Colors.black,
                          value: groupsModified.contains(group),
                          onChanged: (v) {
                            setState(
                                  () {
                                if (v) {
                                  groupsModified.add(group);
                                } else {
                                  groupsModified.remove(group);
                                }
                              },
                            );
                          },
                        ),
                      ),
                    );
                  }).toList(),

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: GradientButton(
                  child: Text("Accept",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  onPressed: () {
                    excecuteChanges(userService);
                    Navigator.pop(context);
                  },
                  gradient: ColorHelper.getBeaconGradient()),
            )
          ],
        ),

      ),
    );
  }
}