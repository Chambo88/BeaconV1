
import 'package:beacon/models/GroupModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/Dialogs/TwoButtonDialog.dart';
import 'package:beacon/widgets/ProfilePicWidget.dart';
import 'package:beacon/widgets/beacon_sheets/FriendSelectorSheet.dart';
import 'package:beacon/widgets/beacon_sheets/IconPickerSheet.dart';
import 'package:beacon/widgets/buttons/BeaconFlatButton.dart';
import 'package:beacon/widgets/tiles/SubTitleText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditGroupPage extends StatefulWidget {
  final GroupModel originalGroup;

  EditGroupPage({@required this.originalGroup});

  @override
  _EditGroupPageState createState() => _EditGroupPageState();
}

class _EditGroupPageState extends State<EditGroupPage> {
  final _formKey = GlobalKey<FormState>();
  bool _enableButton = false;
  GroupModel _group;
  TextEditingController _groupNameTextController;

  @override
  void initState() {
    super.initState();
    _groupNameTextController = TextEditingController();
    _groupNameTextController.text = widget.originalGroup.name;
    _group = GroupModel.clone(widget.originalGroup);
  }

  @override
  void dispose() {
    _groupNameTextController.dispose();
    super.dispose();
  }

  void setEnabledButton() {
    setState(() {
      _enableButton = _formKey.currentState.validate() &&
          _group != widget.originalGroup;
    });
  }

  void _updateFriendsList(Set<String> friendsList) {
    setState(() {
      _group.members = friendsList.toList();
    });
    setEnabledButton();
  }

  void setIcon(IconData icon) {
    setState(() {
      _group.icon = icon;
    });
    setEnabledButton();
  }

  Future<dynamic> cancelDialog(BuildContext context,) {
    return showDialog(
        context: context,
        builder: (BuildContext) {
          return TwoButtonDialog(
            title: "Cancel",
            bodyText: "Discard changes to group?",
            onPressedGrey: () => Navigator.pop(context, false),
            onPressedHighlight: () => Navigator.pop(context, true),
            buttonGreyText: "No",
            buttonHighlightText: "Yes",
          );
        });
  }

  Future<dynamic> deleteDialog(BuildContext context,) {
    return showDialog(
        context: context,
        builder: (BuildContext) {
          return TwoButtonDialog(
            title: "Delete Group",
            bodyText: "Are you sure you want to delete this group?",
            onPressedGrey: () => Navigator.pop(context, false),
            onPressedHighlight: () => Navigator.pop(context, true),
            buttonGreyText: "Cancel",
            buttonHighlightText: "Yes",
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var userService = Provider.of<UserService>(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: TextButton(
          child: Text("Cancel",
            style: TextStyle(
                color: theme.accentColor,
                fontWeight: FontWeight.bold
            ),
          ),
          onPressed: () {
            // Only show dialog if changes have occurred
            if (_enableButton) {
                  cancelDialog(context).then(
                (value) {
                  if(value) {
                    Navigator.pop(context, false);
                  }
                },
              );
            } else {
              Navigator.pop(context, false);
            }
          },
        ),
        title: Text("Edit Group"),
        actions: [
          TextButton(
            onPressed: _enableButton
                ? () {
                    _group.name = _groupNameTextController.value.text;
                    int index = userService.currentUser.groups.indexOf(widget.originalGroup);
                    userService.currentUser.groups.remove(widget.originalGroup);
                    userService.currentUser.groups.insert(index, _group);
                    userService.updateGroups();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Group updated',
                        ),
                      ),
                    );
                    Navigator.pop(context);
                  }
                : null,
            child: Text("Save"),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              onChanged: setEnabledButton,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: (_group.members != null)? _group.members.length + 3: 3,
                itemBuilder: (BuildContext context,int index) {
                  if(index == 0) {
                    return getNameTile(theme, userService);
                  }
                  if(index == 1) {
                    return getIconTile(context, theme);
                  }
                  if(index == 2) {
                    return getAddMembersTile(theme, context);
                  }
                  return SelectedFriend(
                    friend: _group.members[index - 3],
                      onRemove: () {
                        setState(() {
                          _group.members.removeAt(index - 3);
                        });
                        setEnabledButton();
                      });
                },
              ),
            ),
          ),
          BeaconFlatButton(
            title: 'Delete Group',
            onTap: () {
              // showDialog<bool>(
              //   context: context,
              //   barrierDismissible: false,
              //   builder: (BuildContext context) {
              //     return AlertDialog(
              //       title: const Text('Delete Group'),
              //       content: SingleChildScrollView(
              //         child: ListBody(
              //           children: const <Widget>[
              //             Text(
              //                 'Are you sure you would like to delete this group?'),
              //           ],
              //         ),
              //       ),
              //       actions: <Widget>[
              //         TextButton(
              //           child: const Text('Cancel'),
              //           onPressed: () {
              //             Navigator.of(context).pop(false);
              //           },
              //         ),
              //         TextButton(
              //           child: const Text('Yes'),
              //           onPressed: () {
              //             Navigator.of(context).pop(true);
              //           },
              //         )
              //       ],
              //     );
              //   },
              // )
                  deleteDialog(context).then(
                    (value) {
                  if (value) {
                    userService.removeGroup(widget.originalGroup);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Group deleted',
                        ),
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                },
              );
            },
            arrow: false,
            icon: Icons.delete,
          ),
        ],
      ),
    );
  }

  Widget getAddMembersTile(ThemeData theme, BuildContext context) {
    return section(
                theme: theme,
                title: 'Members',
                child: Column(
                  children: [
                    BeaconFlatButton(
                      icon: Icons.group_add_outlined,
                      title: 'Add Members',
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) {
                            return FriendSelectorSheet(

                              onContinue: _updateFriendsList,
                              friendsSelected: _group.members.toSet(),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
  }

  Padding getNameTile(ThemeData theme, UserService userService) {
    return Padding(
              padding: const EdgeInsets.only(top: 30),
              child: TextFormField(
                style: TextStyle(
                    color: theme.accentColor,
                    fontSize: 18
                ),
                decoration: new InputDecoration(
                  prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                  // isDense: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Text("Name",
                        style: theme.textTheme.headline4),
                  ),
                  hintText: "Add a group name",
                ),
                autovalidateMode: AutovalidateMode.always,
                controller: _groupNameTextController,
                onChanged: (value) {
                  _group.name = _groupNameTextController.text;
                  setEnabledButton();
                },
                validator: (value) {
                  if(value != null) {
                    if(value.length >= 20) {
                      return "Group names can't be more than 20 characters";
                    }
                  }
                  if (userService.currentUser.groups
                      .map((GroupModel group) => group.name )
                      .contains(value) &&
                      _group.name != widget.originalGroup.name) {
                    return 'You already have a group with that name.';
                  }
                  return null;
                },
              ),
            );
  }

  Padding getIconTile(BuildContext context, ThemeData theme) {
    return Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (context) {
                      return IconPickerSheet(
                        onSelected: (icon) => setIcon(icon),
                      );
                    },
                  );
                },
                child: Container(
                  color: theme.primaryColor,
                  height: 50,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(28, 0, 16, 0),
                        child: Text("Icon",
                            style: theme.textTheme.headline4),
                      ),
                      Icon(_group.icon,
                        color: theme.accentColor,
                      ),
                    ],
                  ),
                ),
              ),
            );
  }


  Widget section({
    @required ThemeData theme,
    @required String title,
    @required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SubTitleText(text: title),
        Container(
          color: theme.primaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: child,
          ),
        )
      ],
    );
  }
}

class SelectedFriend extends StatelessWidget {
  final String friend;
  final VoidCallback onRemove;
  UserModel friendModel;
  final figmaColours = FigmaColours();

  SelectedFriend({
    @required this.friend,
    @required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final _userService = Provider.of<UserService>(context);
    friendModel = _userService.getAFriendModelFromId(friend);
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Column(
        children: [
          Container(
            height: 50,
            child: ListTile(
              leading: ProfilePicture(
                user: friendModel,
                size: 20,
              ),
              title: Text(
                "${friendModel.firstName} ${friendModel.lastName}",
                style: Theme.of(context).textTheme.headline4,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                  icon: const Icon(
                    Icons.close,
                  ),
                  color: Color(figmaColours.greyLight),
                  onPressed: onRemove),
            ),
          ),
          Divider(
            thickness: 1,
            color: Color(figmaColours.greyMedium),
          )
        ],
      ),
    );
  }
}
