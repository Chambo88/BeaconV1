import 'package:beacon/Assests/Icons.dart';
import 'package:beacon/models/GroupModel.dart';
import 'package:beacon/pages/menu/groups/CreateGroupPage.dart';
import 'package:beacon/services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'EditGroupsPage.dart';

class GroupSettings extends StatefulWidget {
  @override
  _GroupSettingsState createState() => _GroupSettingsState();
}

class _GroupSettingsState extends State<GroupSettings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userService = Provider.of<UserService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Groups"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateGroupPage(),
                  ),
                );
                setState(() {});
              },
              child: Icon(
                Icons.add,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
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
              child: Container(
                key: Key('$index'),
                child: ListTile(
                  leading: Icon(
                    userService.currentUser.groups[index].icon,
                    color: Colors.white,
                  ),
                  title: Text(
                    userService.currentUser.groups[index].name,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  trailing: ReorderableDragStartListener(
                    index: index,
                    child: Icon(
                      Icons.reorder,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final GroupModel group =
                userService.currentUser.groups.removeAt(oldIndex);
            userService.currentUser.groups.insert(newIndex, group);
          });
        },
      ),
    );
  }
}
