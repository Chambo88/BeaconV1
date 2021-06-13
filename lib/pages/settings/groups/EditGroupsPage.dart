import 'package:beacon/models/GroupModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../friends/AddFriendsToGroupsPage.dart';
import 'package:beacon/Assests/Icons.dart';

typedef void GroupIconChangeCallBack(String icon, GroupModel group);
typedef void GroupRemoveCallBack(String person);

class EditGroups extends StatefulWidget {
  @override
  _EditGroupsState createState() => _EditGroupsState();

  GroupModel group;
  bool isNewGroup;
  List<UserModel> groupMembers;
  EditGroups({
    this.group,
    this.isNewGroup,
    this.groupMembers,
  });
}

class _EditGroupsState extends State<EditGroups> {
  @override
  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _removeFromGroup(String userId) {
    setState(() {
      widget.group.remove_id(userId);
    });
  }

  void _changeGroupIcon(String icon, GroupModel group) {
    setState(() {
      group.set_icon(icon);
    });
  }

  void _changeGroupName(String name, GroupModel group, UserModel user) {
    bool groupNameTaken = false;
    user.groups.forEach(
      (element) {
        if (element.name == name) {
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupDialog(context, name),
          );
          groupNameTaken = true;
        }
      },
    );
    setState(
      () {
        if (!groupNameTaken) {
          group.set_name(name);
        } else {
          _controller.clear();
        }
      },
    );
  }

  Widget _buildPopupDialog(BuildContext context, String text) {
    return new AlertDialog(
      title: const Text('POP!'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("A group is already called ${text}. Chose a differemt name "),
        ],
      ),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Ok"),
        ),
      ],
    );
  }

  String _getTitle() {
    return widget.isNewGroup ? 'New Group' : 'Edit Group';
  }

  //checks if the group list is empty or not
  doesUserHaveFriends(UserModel user) {
    if (widget.group.userIds.isEmpty) {
      return Text('no friends in this group yet');
    } else {
      return HaveFriends(user);
    }
  }

  //Gets the data from friends users then builds the friendlist search add thingy
  FutureBuilder<QuerySnapshot> HaveFriends(UserModel user) {
    return FutureBuilder(
      future: _fireStoreDataBase
          .collection('users')
          .where('userId', whereIn: widget.group.userIds)
          .get(),
      builder: (context, dataSnapshot) {
        while (!dataSnapshot.hasData) {
          return circularProgress();
        }
        List<UserModel> _groupMembers = [];
        dataSnapshot.data.docs.forEach((document) {
          UserModel users = UserModel.fromDocument(document);
          _groupMembers.add(users);
        });

        return UserList(
          groupMembers: _groupMembers,
          group: widget.group,
          removeFromFriendsCallBack: _removeFromGroup,
        );
      },
    );
  }

  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: TextButton(
          style: TextButton.styleFrom(
              primary: Colors.white,
              textStyle: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
          child: Text('cancel'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        title: Center(child: Text(_getTitle())),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20),
              child: TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      textStyle:
                          TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                  child: Text('save'),
                  onPressed: () {
                    if (widget.group.name == '') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupDialog(context, 'Name cant be empty'),
                      );
                    } else {
                      Navigator.pop(context, true);
                    }
                  }))
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: widget.group.name),
            onSubmitted: (String value) {
              _changeGroupName(value, widget.group, user);
            },
          ),
          Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: 50,
              child: buildIconSelection()),
          SizedBox(height: 200, width: 200, child: doesUserHaveFriends(user)),
          getFriendsButton()
        ],
      ),
    );
  }

  ListView buildIconSelection() {
    return ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: BeaconIcons.iconMap.entries.map((entry) {
          return CustomIconButton(
            icon: entry.key,
            group: widget.group,
            group_icon_change: _changeGroupIcon,
          );
        }).toList());
  }

  Widget getFriendsButton() {
    return TextButton(
      child: Container(
        color: Colors.green,
        width: 100,
        height: 100,
        child: Text('Add Friends'),
      ),
      onPressed: () async {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Add_friends(group: widget.group)));
        setState(() {});
      },
    );
  }
}

class UserList extends StatefulWidget {
  GroupModel group;
  List<UserModel> groupMembers;
  GroupRemoveCallBack removeFromFriendsCallBack;

  UserList({this.group, this.groupMembers, this.removeFromFriendsCallBack});

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  ListView userList() {
    return ListView(
      shrinkWrap: true,
      children: widget.groupMembers.map((UserModel person) {
        return Single_person(
          person: person,
          removeFromGroup: widget.removeFromFriendsCallBack,
        );
      }).toList(),
    );
  }

  Widget build(BuildContext context) {
    return userList();
  }
}

//-----------------THE ICON BUTTONS-----------------------
class CustomIconButton extends StatefulWidget {
  const CustomIconButton(
      {Key key, this.icon, this.group, this.group_icon_change})
      : super(key: key);

  final String icon;
  final GroupModel group;
  final GroupIconChangeCallBack group_icon_change;

  @override
  _CustomIconButtonState createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  Color _get_color(IconData icon) {
    if (widget.group.icon == icon) {
      return Colors.green;
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          widget.group_icon_change(widget.icon, widget.group);
          setState(() {});
        },
        child: Icon(BeaconIcons.getIconFromString(widget.icon),
            color:
                _get_color(BeaconIcons.getIconFromString(widget.icon))));
  }
}

//----------------tiles for the userlist--------------------------

class Single_person extends StatelessWidget {
  Single_person({
    this.person,
    this.removeFromGroup,
  }) : super(key: ObjectKey(person));

  final UserModel person;
  final GroupRemoveCallBack removeFromGroup;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${person.firstName} ${person.lastName}'),
      trailing: GestureDetector(
          onTap: () {
            removeFromGroup(person.id);
          },
          child: Icon(
            Icons.remove_circle,
            color: Colors.red,
          )),
    );
  }
}
