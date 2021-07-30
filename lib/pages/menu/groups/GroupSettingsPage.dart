import 'package:beacon/Assests/Icons.dart';
import 'package:beacon/models/GroupModel.dart';
import 'package:beacon/pages/menu/groups/CreateGroupPage.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/buttons/BeaconFlatButton.dart';
import 'package:beacon/widgets/tiles/SubTitleText.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'EditGroupsPage.dart';

class GroupSettings extends StatefulWidget {
  GroupSettings({this.originalGroupList});

  List<GroupModel> originalGroupList;

  @override
  _GroupSettingsState createState() => _GroupSettingsState();
}

class _GroupSettingsState extends State<GroupSettings> {

  bool orderChanged;
  FigmaColours figmaColours;
  List<GroupModel> potentialNewGroupList;


  @override
  void initState() {
    super.initState();
    figmaColours = FigmaColours();
    orderChanged = false;
    potentialNewGroupList = new List<GroupModel>.from(widget.originalGroupList);
  }

  @override
  Widget build(BuildContext context) {
    var userService = Provider.of<UserService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Groups"),
      ),
      body: Column(
        children: [
          BeaconFlatButton(
            icon: Icons.group_add_outlined,
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateGroupPage(),
                  ),
                );
                setState(() {});
              },
            title: 'Create new group',
          ),
          SubTitleText(
            text: 'Reorder and edit groups',
          ),
          Expanded(child: buildReorderableListView(userService)),
        ],
      ),
    );
  }

  Widget buildReorderableListView(UserService userService) {
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      child: ReorderableListView(
        buildDefaultDragHandles: false,
        children: <Widget>[
          for (int index = 0;
              index < userService.currentUser.groups.length;
              index++)
            InkWell(
              key: Key('$index'),
              onTap: () async {
                //copy current groups list object so we dont modify it when we create a temp group
                List<String> userIdsCopy = [
                  ...userService.currentUser.groups[index].members
                ];
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditGroupPage(
                      originalGroup: new GroupModel(
                        // name: user.groups[index].name,
                        name: userService.currentUser.groups[index].name,
                        members: userIdsCopy,
                        icon: userService.currentUser.groups[index].icon,
                      ),
                    ),
                  ),
                );
                setState(() {});
              },
              child: Padding(
                key: Key('$index'),
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Container(
                  color: Color(figmaColours.greyDark),
                  key: Key('$index'),
                  child: ListTile(
                    leading: Icon(
                      userService.currentUser.groups[index].icon,
                      color: Color(figmaColours.greyLight),
                    ),
                    title: Text(
                      userService.currentUser.groups[index].name,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    trailing: ReorderableDragStartListener(
                      index: index,
                      child: Icon(
                        Icons.reorder,
                        color: Color(figmaColours.highlight),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            orderChanged = true;
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final GroupModel group =
                userService.currentUser.groups.removeAt(oldIndex);
            userService.currentUser.groups.insert(newIndex, group);
            userService.currentUser.groups.forEach((element) {print(element.name);});
          });
        },
      ),
    );
  }
}
