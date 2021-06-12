import 'package:beacon/library/ColorHelper.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/widgets/BeaconBottomSheet.dart';
import 'package:beacon/widgets/buttons/GradientButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FriendSelectorSheet extends StatefulWidget {
  UserModel user;
  Function onContinue;
  Set<String> friendsSelected = Set();

  FriendSelectorSheet({
    Key key,
    this.user,
    this.onContinue,
    this.friendsSelected,
  }) : super(key: key);

  @override
  _FriendSelectorSheetState createState() =>
      _FriendSelectorSheetState(this.user.friends);
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
    final theme = Theme.of(context);
    // Pop up Friend selector
    return BeaconBottomSheet(
      child: Column(
        children: [
          ListTile(
            leading: CloseButton(
              color: Colors.white,
            ),
            title: Text('Friends',
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headline4),
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
              ).applyDefaults(theme.inputDecorationTheme),
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
                    fillColor:
                        MaterialStateProperty.resolveWith(getCheckboxColor),
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
            padding: const EdgeInsets.all(16),
            child: GradientButton(
              child: Text(
                'Continue',
                style: theme.textTheme.headline4,
              ),
              gradient: ColorHelper.getBeaconGradient(),
              onPressed: () {
                widget.onContinue(widget.friendsSelected);
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
