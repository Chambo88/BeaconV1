import 'package:beacon/models/friend_model.dart';
import 'package:beacon/models/GroupModel.dart';
import 'package:flutter/material.dart';
import 'SettingsPage.dart';
import 'package:flutter/foundation.dart';

typedef void SelectedChangedCallback(Friend person);


class Add_friends extends StatefulWidget {
  @override
  _Add_friendsState createState() => _Add_friendsState();

  GroupModel group;
  Add_friends({this.group});
}

class _Add_friendsState extends State<Add_friends> {

  TextEditingController editingController = TextEditingController();

  //total friends list
  //This will have to be pulled from the server or passed here
  List<Friend> _friends = [
    Friend(name: 'john'),
    Friend(name: 'beth'),
    Friend(name: 'will'),
    Friend(name: 'Frankie'),
    Friend(name: 'Megan'),
    Friend(name: 'Richie'),
    Friend(name: 'Robbie'),
    Friend(name: 'Yive')
  ];

  List<Friend> _friends_not_added_yet;
  List<Friend> _friends_not_added_yet_duplicate = [];
  List<Friend> _selected_list = [];


  @override
  void initState() {
    super.initState();
    _friends_not_added_yet = get_unadded_friends(widget.group, _friends);
    _friends_not_added_yet_duplicate.addAll(_friends_not_added_yet);
  }


  //returns a new List<Person> with those that have not been added to the group yet
  List<Friend> get_unadded_friends(GroupModel group, List<Friend> _friends) {
    bool condition = false;
    List<Friend> return_list = [];

    for (int index = 0; index < _friends.length; index++) {
      condition = false;
      for (int index2 = 0; index2 < group.members.length; index2++) {
        if (group.members[index2].name == _friends[index].name ) {
          condition = true;
          break;
        }
      }
      if (condition == false) {
        return_list.add(_friends[index]);
      }
    }
    return return_list;
  }

  void _add_to_selected(Friend person) {
    setState(() {
      _selected_list.add(person);
    });
  }


  void filterSearchResults(String query) {
    List<Friend> dummySearchList = [];
    dummySearchList.addAll(_friends_not_added_yet_duplicate);
    if(query.isNotEmpty) {
      List<Friend> dummyListData = [];
      dummySearchList.forEach((person) {
        if(person.name.toLowerCase().contains(query)) {
          dummyListData.add(person);
        }
      });
      setState(() {
        _friends_not_added_yet.clear();
        _friends_not_added_yet.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _friends_not_added_yet.clear();
        _friends_not_added_yet.addAll(_friends_not_added_yet_duplicate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text('Add Friends')
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _friends_not_added_yet.length,
                itemBuilder: (context, index) {
                  return AddTile(
                    friends_not_added_yet: _friends_not_added_yet,
                    selected: _selected_list.contains(_friends_not_added_yet[index]),
                    selection_change: _add_to_selected,
                    index: index,
                    group: widget.group,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddTile extends StatelessWidget {
  const AddTile({
    Key key,
    @required List<Friend> friends_not_added_yet,
    this.index,
    this.selected,
    this.selection_change,
    this.group,
  }) : _friends_not_added_yet = friends_not_added_yet, super(key: key);

  final List<Friend> _friends_not_added_yet;
  final int index;
  final bool selected;
  final SelectedChangedCallback selection_change;
  final GroupModel group;

  Color _getColor(BuildContext context) {
    return selected ? Colors.black54 : Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(_friends_not_added_yet[index].name),
        trailing: GestureDetector(
          onTap: () {
            selection_change(_friends_not_added_yet[index]);
            group.add_person(_friends_not_added_yet[index]);
          },
          child: Icon(
            Icons.add,
            color: _getColor(context),
          ),
        )
    );
  }
}
