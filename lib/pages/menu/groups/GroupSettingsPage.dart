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

  List<GroupModel>? originalGroupList;

  @override
  _GroupSettingsState createState() => _GroupSettingsState();
}

class _GroupSettingsState extends State<GroupSettings> {
  FigmaColours? figmaColours;

  @override
  void initState() {
    super.initState();
    figmaColours = FigmaColours();
  }

  @override
  Widget build(BuildContext context) {
    var userService = Provider.of<UserService>(context);
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(
          context,
        );
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Color(figmaColours!.highlight),
            onPressed: () {
              Navigator.pop(
                context,
              );
            },
          ),
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
              index < userService.currentUser!.groups!.length;
              index++)
            InkWell(
              key: Key('$index'),
              onTap: () async {
                //copy current groups list object so we dont modify it when we create a temp group
                List<String> userIdsCopy = [
                  ...userService.currentUser!.groups![index].members!
                ];
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditGroupPage(
                      originalGroup: new GroupModel(
                        // name: user.groups[index].name,
                        name: userService.currentUser!.groups![index].name,
                        members: userIdsCopy,
                        icon: userService.currentUser!.groups![index].icon,
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
                  height: 50,
                  color: Color(figmaColours!.greyDark),
                  key: Key('$index'),
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    leading: Icon(
                      userService.currentUser!.groups![index].icon,
                      color: Color(figmaColours!.greyLight),
                    ),
                    title: Transform.translate(
                      offset: Offset(0, 0),
                      child: Text(
                        userService.currentUser!.groups![index].name!,
                        style: Theme.of(context).textTheme.headlineMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: ReorderableDragStartListener(
                      index: index,
                      child: Icon(
                        Icons.reorder,
                        color: Color(figmaColours!.highlight),
                      ),
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
                userService.currentUser!.groups!.removeAt(oldIndex);
            userService.currentUser!.groups!.insert(newIndex, group);
          });
        },
      ),
    );
  }
}
