
import 'package:beacon/library/ColorHelper.dart';
import 'package:beacon/models/GroupModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/ProfilePicWidget.dart';
import 'package:beacon/widgets/beacon_sheets/FriendSelectorSheet.dart';
import 'package:beacon/widgets/beacon_sheets/IconPickerSheet.dart';
import 'package:beacon/widgets/buttons/BeaconFlatButton.dart';
import 'package:beacon/widgets/buttons/GradientButton.dart';
import 'package:beacon/widgets/tiles/SubTitleText.dart';
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
  GroupModel _group;
  TextEditingController _groupNameTextController;
  FigmaColours figmaColours;

  @override
  void initState() {
    super.initState();
    _groupNameTextController = TextEditingController();
    figmaColours = FigmaColours();
    _group = GroupModel(members: [], icon: Icons.local_fire_department_outlined, name: null);
  }

  @override
  void dispose() {
    _groupNameTextController.dispose();
    super.dispose();
  }

  void setEnabledButton() {
    setState(() {
      _enableButton =
          _formKey.currentState.validate() && _groupNameTextController.text.isNotEmpty;
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
  }

  @override
  Widget build(BuildContext context) {
    var userService = Provider.of<UserService>(context);
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
      },
      child: Scaffold(
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
              Navigator.pop(context, false);
            },
          ),
          title: Text("Create Group"),
          actions: [
            _enableButton ? TextButton(
              child: Text("Save",
                style: TextStyle(
                    color: theme.accentColor,
                    fontWeight: FontWeight.bold
                ),
              ),
              onPressed: () {
                _group.name = _groupNameTextController.value.text;
                userService.addGroup(_group);
                Navigator.pop(context);
              },
            ) :
            TextButton(
              child: Text("Save",
                style: TextStyle(
                color: Color(figmaColours.greyLight),
                fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: null
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            onChanged: setEnabledButton,
            child: Column(
              children: [
                Padding(
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
                      setEnabledButton();
                    },
                    validator: (value) {
                      if(value != null) {
                        if(value.length >= 20) {
                          return "Group names can't be more than 20 characters";
                        }
                      }
                      if (userService.currentUser.groups
                          .map((GroupModel group) => group.name)
                          .contains(value)) {
                        return 'You already have a group with that name.';
                      }
                      return null;
                    },
                  ),
                ),
          Padding(
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
                      color: Color(figmaColours.highlight),
                    ),
                  ],
                ),
              ),
            ),
          ),
                section(
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
              ],
            ),
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
        SubTitleText(
          text: title
        ),
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
