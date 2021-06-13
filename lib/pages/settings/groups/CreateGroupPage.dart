import 'package:beacon/Assests/Icons.dart';
import 'package:beacon/library/ColorHelper.dart';
import 'package:beacon/models/GroupModel.dart';
import 'package:beacon/widgets/BeaconBottomSheet.dart';
import 'package:beacon/widgets/beacon_sheets/FriendSelectorSheet.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/widgets/buttons/FlatArrowButton.dart';
import 'package:beacon/widgets/buttons/GradientButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateGroupPage extends StatefulWidget {
  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _formKey = GlobalKey<FormState>();
  bool _enableButton = false;
  var _group = GroupModel();
  TextEditingController _groupNameTextController;
  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _groupNameTextController = TextEditingController();
  }

  @override
  void dispose() {
    _groupNameTextController.dispose();
    super.dispose();
  }

  void setEnabledButton() {
    setState(() {
      _enableButton =
          _formKey.currentState.validate() && _group.userIds.isNotEmpty;
    });
  }

  void _updateFriendsList(Set<String> friendsList) {
    setState(() {
      _group.userIds = friendsList.toList();
    });
    setEnabledButton();
  }

  void setIcon(IconData icon) {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserModel>(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        title: Text("Create Group"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              onChanged: setEnabledButton,
              child: Column(
                children: [
                  section(
                    theme: theme,
                    title: "Name",
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.always,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Group name can not be empty.';
                        }
                        if (user.groups
                            .map((GroupModel group) => group.name)
                            .contains(value)) {
                          return 'You already belong to a group with that name.';
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
                                Text('Icon:'),
                                Icon(
                                  BeaconIcons.getIconFromString(_group.icon),
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
                        FlatArrowButton(
                          title: 'Add Members',
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (context) {
                                return FriendSelectorSheet(
                                  onContinue: _updateFriendsList,
                                  friendsSelected: _group.userIds.toSet(),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  if (_group.userIds != null)
                    Column(
                      children: _group.userIds.map((friend) {
                        return SelectedFriend(
                            friend: friend,
                            onRemove: () {
                              setState(() {
                                _group.userIds.remove(friend);
                              });
                              setEnabledButton();
                            });
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: GradientButton(
              child: Text('Create'),
              onPressed: _enableButton
                  ? () {
                      user.addGroupToList(_group);
                    }
                  : null,
              gradient: ColorHelper.getBeaconGradient(),
            ),
          )
        ],
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

typedef void iconSelected(IconData icon);

class IconPickerSheet extends StatelessWidget {
  final iconSelected onSelected;

  IconPickerSheet({@required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 400,
      child: BeaconBottomSheet(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                leading: CloseButton(
                  color: Colors.white,
                ),
                title: Text('Icons',
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headline4),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 4,
                      childAspectRatio: 1.0,
                      padding: const EdgeInsets.all(4.0),
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      children: BeaconIcons.iconDataList.map((e) {
                        return InkWell(
                            onTap: () {
                              onSelected(e);
                              Navigator.pop(context);
                            },
                            child: Icon(e));
                      }).toList())),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectedFriend extends StatelessWidget {
  final String friend;
  final VoidCallback onRemove;

  SelectedFriend({@required this.friend, @required this.onRemove});

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
          icon: const Icon(Icons.close),
          color: Colors.white,
          onPressed: onRemove),
    );
  }
}
