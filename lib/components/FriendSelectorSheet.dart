import 'package:beacon/models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FriendSelectorSheet extends StatefulWidget {
  FriendSelectorSheet({Key key, this.user, this.updateFriendsList, this.friendsSelected}) : super(key: key);
  UserModel user;
  Function updateFriendsList;
  Set<String> friendsSelected = Set();
  @override
  _FriendSelectorSheetState createState() => _FriendSelectorSheetState(this.user.friends);
}

class _FriendSelectorSheetState extends State<FriendSelectorSheet> {
  List<String> _filteredFriends = [];

  _FriendSelectorSheetState(List<String> friends) {
    _filteredFriends = friends;
  }


  Color getCheckboxColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  List<String> getFilteredFriends(String filter) {
    return widget.user.friends.where((friend) {
      return friend.toLowerCase().contains(filter.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // Pop up Friend selector
      return Container(
        height: MediaQuery.of(context).size.height * 0.75,
        margin: EdgeInsets.only(top: 70),
        decoration: new BoxDecoration(
          color: Colors.black,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(25.0),
            topRight: const Radius.circular(25.0),
          ),
        ),
        child: Column(
          children: [
            ListTile(
              leading: CloseButton(
                color: Colors.white,
              ),
              title: Text(
                'Friends',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline4
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: TextFormField(
                maxLength: 20,
                style: TextStyle(color: Colors.white),
                onChanged: (filter) {
                  setState(() {
                    _filteredFriends = getFilteredFriends(filter);
                  });
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  labelText: 'Name',
                ).applyDefaults(Theme.of(context).inputDecorationTheme),
              ),
            ),
            Expanded(
              child: Column(
                children: _filteredFriends.map((friend) {
                  return ListTile(
                    key: Key(friend),
                    title: Text(
                      friend,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),

                    trailing: Checkbox(
                      key: Key(friend),
                      fillColor: MaterialStateProperty.resolveWith(getCheckboxColor),
                      checkColor: Colors.black,
                      value: widget.friendsSelected.contains(friend),
                      onChanged: (v) {
                        setState(
                          () {
                            if (v) {
                              widget.friendsSelected.add(friend);
                            } else {
                              widget.friendsSelected.remove(friend);
                            }
                          },
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            Container(
              width: 350,
              padding: const EdgeInsets.all(6),
              child: OutlinedButton(
                onPressed: () {
                  widget.updateFriendsList(widget.friendsSelected);
                  Navigator.pop(context);
                },
                child: Container(
                  child: Text('Continue'),
                ),
              ),
            ),
          ],
        ),
      );
  }
}
