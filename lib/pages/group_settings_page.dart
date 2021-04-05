import 'package:beacon/models/group_model.dart';
import 'package:beacon/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_group_page.dart';


class group_settings extends StatefulWidget {

  @override
  _group_settingsState createState() => _group_settingsState();
}

class _group_settingsState extends State<group_settings> {

  bool _group_created = false;

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
                      GroupModel returned_group = new GroupModel(name: 'Name', members: [], icon: Icons.add);
                      _group_created = await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => Edit_groups(group: returned_group, is_new_group: true,))
                      );
                      setState(() {
                        if (_group_created) {
                          user.addGroupToList(returned_group);
                        }
                        _group_created = false;
                      });
                    },
                    child: Icon(Icons.person_add)
                ),
              )
            ]
        ),

        // body: buildListView(),
        // body: const MyStatefulWidget(),
        body: Column(
          children: [
            Expanded(child: buildReorderableListView(user)),
          ],
        )
    );
  }

  //Pop up dialog for removing groups
  AlertDialog remove_group_dialog(int index, UserModel user) {
    return AlertDialog(
      title: Text("remove group?"),
      actions: [
        TextButton(onPressed: () {
          setState(() {
            user.removeGroup(user.groups[index]);
            Navigator.of(context).pop();
          });

        }, child: Text("confirm"))
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
            // onTap: () {
            //   Navigator.of(context).push(MaterialPageRoute(
            //       builder: (context) => Edit_groups(group: widget.groups[index])));
            // },
            onLongPress: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return remove_group_dialog(index, user);
                  });
            },
            onTap: () async {
              await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => Edit_groups(group: user.groups[index], is_new_group: false))
              );
              setState(() {});
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
      },
    );
  }
}



