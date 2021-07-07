import 'package:beacon/library/ColorHelper.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/BeaconBottomSheet.dart';
import 'package:beacon/widgets/buttons/GradientButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../SearchBar.dart';

class FriendSelectorSheet extends StatefulWidget {
  Function onContinue;
  Set<String> friendsSelected = Set();

  FriendSelectorSheet({
    Key key,
    this.onContinue,
    this.friendsSelected,
  }) : super(key: key);

  @override
  _FriendSelectorSheetState createState() => _FriendSelectorSheetState();
}

class _FriendSelectorSheetState extends State<FriendSelectorSheet> {
  UserService _userService;
  TextEditingController _searchController;
  final FocusNode _focusNode = FocusNode();
  List<String> _filteredFriends = [];
  Set<String> _friendsSelected;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _friendsSelected = widget.friendsSelected;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
    return _userService.currentUser.friends.where((friend) {
      return friend.toLowerCase().contains(filter.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_userService == null) {
      _userService = Provider.of<UserService>(context);
      _filteredFriends = _userService.currentUser.friends;
    }

    // Pop up Friend selector
    return BeaconBottomSheet(
      child: Column(
        children: [
          ListTile(
            leading: CloseButton(
              color: Color(0xFF444444),
            ),
            title: Text(
              'Friends',
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.headline4,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Name',
              onChanged: (filter) {
                setState(() {
                  _filteredFriends = getFilteredFriends(filter);
                });
              },
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
                    value: _friendsSelected.contains(friend),
                    onChanged: (v) {
                      setState(
                        () {
                          if (v) {
                            _friendsSelected.add(friend);
                          } else {
                            _friendsSelected.remove(friend);
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
                widget.onContinue(_friendsSelected);
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
