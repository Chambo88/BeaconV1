import 'package:beacon/Assests/Icons.dart';
import 'package:beacon/models/GroupModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/pages/settings/groups/CreateGroupPage.dart';
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
    var user = Provider.of<UserModel>(context);
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

      // body: buildListView(),
      // body: const MyStatefulWidget(),
      body: Column(
        children: [
          Expanded(child: buildReorderableListView(user)),
        ],
      ),
    );
  }

  //Pop up dialog for removing groups
  AlertDialog removeGroupDialog(int index, UserModel user) {
    return AlertDialog(
      title: Text("remove group?"),
      actions: [
        TextButton(
            onPressed: () {
              user.removeGroupFromListFirebase(user.groups[index]);
              setState(() {
                user.removeGroup(user.groups[index]);
                Navigator.of(context).pop();
              });
            },
            child: Text("confirm"))
      ],
    );
  }

  ReorderableListView buildReorderableListView(UserModel user) {
    return ReorderableListView(
      buildDefaultDragHandles: false,
      children: <Widget>[
        for (int index = 0; index < user.groups.length; index++)
          InkWell(
            key: Key('$index'),
            onLongPress: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return removeGroupDialog(index, user);
                  });
            },
            onTap: () async {
              //copy current groups list object so we dont modify it when we create a temp group
              List<String> userIdsCopy = [...user.groups[index].members];
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditGroupPage(
                    originalGroup: new GroupModel(
                      // name: user.groups[index].name,
                      name: user.groups[index].name,
                      members: userIdsCopy,
                      icon: user.groups[index].icon,
                    ),
                  ),
                ),
              );

              //if the person said save then we remove the original grohup from firebase and the user and add the newly created one
              // if (_groupSaved) {
              //   user.removeGroupFromListFirebase(user.groups[index]);
              //   user.removeGroup(user.groups[index]);
              //   user.addGroupToList(returnedGroup);
              //   user.addGroupToListFirebase(returnedGroup);
              //   setState(() {});
              // }
            },
            child: Container(
              key: Key('$index'),
              child: Row(
                children: <Widget>[
                  Icon(user.groups[index].icon),
                  Text(user.groups[index].name),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Container(
                      width: 100,
                      height: 64,
                      padding: const EdgeInsets.all(8),
                      child: ReorderableDragStartListener(
                        index: index,
                        child: Icon(Icons.article_outlined),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final GroupModel group = user.groups.removeAt(oldIndex);
          user.groups.insert(newIndex, group);
        });
        user.updateGroups();
      },
    );
  }
}
