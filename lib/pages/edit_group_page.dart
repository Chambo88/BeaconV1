import 'package:beacon/models/friend_model.dart';
import 'package:beacon/models/group_model.dart';
import 'package:flutter/material.dart';
import 'add_friends_page.dart';

class Edit_groups extends StatefulWidget {
  @override
  _Edit_groupsState createState() => _Edit_groupsState();

  GroupModel group;
  bool is_new_group;
  Edit_groups({
    this.group,
    this.is_new_group
  });

}

class _Edit_groupsState extends State<Edit_groups> {
  @override

  //RETRIEVE THE ICON LIST THAT WE ADD TO RESOURCES
  List<IconData> _icon_list = [
    Icons.remove_circle,
    Icons.eighteen_mp,
    (Icons.person_add),
    (Icons.article),
    (Icons.baby_changing_station),
    (Icons.height),
    Icons.remove_circle,
    Icons.eighteen_mp,
    (Icons.person_add),
    (Icons.article),
    (Icons.baby_changing_station),
    (Icons.height),
    Icons.remove_circle,
    Icons.eighteen_mp,
    (Icons.person_add),
    (Icons.article),
    (Icons.baby_changing_station),
    (Icons.height),
  ];

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

  void _removeFromGroup(Friend person) {
    setState(() {
      widget.group.remove(person);
    });
  }

  void _changeGroupIcon(IconData icon, GroupModel group)
  {
    setState(() {
      group.set_icon(icon);
    });
  }

  void _changeGroupName(String name, GroupModel group) {
    setState(() {
      group.set_name(name);
    });
  }

  String _getTitle() {
    return widget.is_new_group? 'New Group':'Edit Group' ;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: TextButton(
          style: TextButton.styleFrom(
              primary: Colors.white,
              textStyle: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)
          ),
          child: Text('cancel'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        title: Center(child: Text(_getTitle())),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
                onTap: () async {
                  await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => Add_friends(group: widget.group))
                  );
                  setState(() {});
                },
                child: Icon(Icons.person_add)
            ),
          )
        ],
      ),
      body:
      Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
                labelText: widget.group.name
            ),
            onSubmitted: (String value) {
              _changeGroupName(value, widget.group);
            },

          ),
          Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: 50,
              child: buildIconSelection()
          ),
          SizedBox(
              height: 200,
              width: 200,
              child: buildListView()
          ),
          confirmButtonIfNewGroup()
        ],
      ),
    );
  }



  ListView buildListView() {
    return ListView(
      shrinkWrap: true,
      children: widget.group.members.map((Friend person) {
        return Single_person(
          person: person,
          removeFromGroup: _removeFromGroup,
        );
      }).toList(),
    );
  }

  ListView buildIconSelection() {
    return ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: _icon_list.map((IconData icon) {
          return Icon_button(
            icon: icon,
            group: widget.group,
            group_icon_change: _changeGroupIcon,
          );
        }).toList()
    );
  }

  Widget confirmButtonIfNewGroup() {
    if (widget.is_new_group){
      return TextButton(
          child: Container(
            color: Colors.green,
            width: 100,
            height:100,
            child: Text('confirm'),
          ),
          onPressed: () {
            Navigator.pop(context, true);
          }
      );
    }
    else {
      return Container();
    }
  }
}

typedef void GroupIconChangeCallBack(IconData icon, GroupModel group);

//-----------------THE ICON BUTTONS-----------------------
class Icon_button extends StatelessWidget {

  const Icon_button({
    Key key,
    this.icon,
    this.group,
    this.group_icon_change,
  }) : super(key: key);

  final IconData icon;
  final GroupModel group;
  final GroupIconChangeCallBack group_icon_change;

  Color _get_color(IconData icon) {
    if (group.icon == icon) {
      return Colors.green;
    }
    else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          group_icon_change(icon, group);
        },
        child: Icon(
            this.icon,
            color: _get_color(icon)
        )
    );
  }
}


typedef void GroupRemoveCallBack(Friend person);

class Single_person extends StatelessWidget {
  Single_person({this.person, this.removeFromGroup})
      : super(key: ObjectKey(person));

  final Friend person;
  final GroupRemoveCallBack removeFromGroup;


  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(person.name),
      trailing: GestureDetector(
          onTap: () {
            removeFromGroup(person);
            print('clicked');
          },
          child: Icon(
            Icons.remove_circle,
            color: Colors.red,
          )
      ),
    );
  }
}

