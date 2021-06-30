import 'package:beacon/Assests/Icons.dart';
import 'package:beacon/library/ColorHelper.dart';
import 'package:beacon/models/GroupModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/BeaconBottomSheet.dart';
import 'package:beacon/widgets/beacon_sheets/FriendSelectorSheet.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/widgets/beacon_sheets/IconPickerSheet.dart';
import 'package:beacon/widgets/buttons/BeaconFlatButton.dart';
import 'package:beacon/widgets/buttons/GradientButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
          _group.members.isNotEmpty &&
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

  @override
  Widget build(BuildContext context) {
    var userService = Provider.of<UserService>(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            // Only show dialog if changes have occurred
            if (_enableButton) {
              showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Cancel'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: const <Widget>[
                          Text('Discard changes to group?'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: const Text('Yes'),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      )
                    ],
                  );
                },
              ).then(
                (value) {
                  if (value) {
                    Navigator.of(context).pop();
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
                    userService.removeGroup(widget.originalGroup);
                    userService.addGroup(_group);
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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          onChanged: setEnabledButton,
          child: Column(
            children: [
              section(
                theme: theme,
                title: "Name",
                child: TextFormField(
                  controller: _groupNameTextController,
                  autovalidateMode: AutovalidateMode.always,
                  onChanged: (value) {
                    _group.name = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Group name can not be empty.';
                    }
                    else if (userService.currentUser.groups
                            .map((GroupModel group) => group.name)
                            .contains(value) &&
                        _group.name != widget.originalGroup.name) {
                      return 'You already have a group with that name.';
                    }
                    return null;
                  },
                ),
              ),
              section(
                theme: theme,
                title: 'Customization',
                child: Container(
                  height: 50,
                  color: theme.primaryColor,
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
                    child: _group.icon != null
                        ? Row(children: [
                            Text(
                              'Icon:',
                            ),
                            Icon(
                              _group.icon,
                            ),
                          ])
                        : null,
                  ),
                ),
              ),
              section(
                theme: theme,
                title: 'Members',
                child: Column(
                  children: [
                    BeaconFlatButton(
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
              ),
              if (_group.members != null)
                Column(
                  children: _group.members.map((friend) {
                    return SelectedFriend(
                        friend: friend,
                        onRemove: () {
                          setState(() {
                            _group.members.remove(friend);
                          });
                          setEnabledButton();
                        });
                  }).toList(),
                ),
              section(
                theme: theme,
                title: 'More Actions',
                child: BeaconFlatButton(
                  title: 'Delete Group',
                  onTap: () {
                    showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete Group'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: const <Widget>[
                                Text(
                                    'Are you sure you would like to delete this group?'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            TextButton(
                              child: const Text('Yes'),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            )
                          ],
                        );
                      },
                    ).then(
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 2),
            child: Text(
              title,
              style: theme.textTheme.bodyText2,
            ),
          ),
          Container(
            color: theme.primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: child,
            ),
          )
        ],
      ),
    );
  }
}

class SelectedFriend extends StatelessWidget {
  final String friend;
  final VoidCallback onRemove;

  SelectedFriend({
    @required this.friend,
    @required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.circle,
        size: 50,
        color: Colors.grey,
      ),
      title: Text(
        friend,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      trailing: IconButton(
          icon: const Icon(
            Icons.close,
          ),
          color: Colors.white,
          onPressed: onRemove),
    );
  }
}
