import 'package:beacon/models/GroupModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/beacon_sheets/FriendSelectorSheet.dart';
import 'package:beacon/widgets/buttons/BeaconFlatButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CreatorPage.dart';

typedef void InviteCallback(
  bool displayToAll,
  Set<GroupModel> groupList,
  Set<String> friendsList,
);

class WhoCanSeePage extends StatefulWidget {
  final VoidCallback onBackClick;
  final VoidCallback onClose;
  final InviteCallback onContinue;
  final String continueText;
  final int totalPageCount;
  final int currentPageIndex;
  final Set<GroupModel> initGroups;
  final Set<String> initFriends;
  final bool initDisplayToAll;

  WhoCanSeePage({
    @required this.onBackClick,
    @required this.onClose,
    @required this.onContinue,
    @required this.totalPageCount,
    @required this.currentPageIndex,
    this.initGroups,
    this.initFriends,
    this.initDisplayToAll,
    this.continueText = 'Next',
  });

  @override
  _WhoCanSeePageState createState() => _WhoCanSeePageState();
}

class _WhoCanSeePageState extends State<WhoCanSeePage> {
  UserService _userService;

  var _displayToAll = false;
  var _groupList = Set<GroupModel>();
  var _friendsList = Set<String>();

  @override
  void initState() {
    super.initState();
    _groupList = widget.initGroups;
    _friendsList = widget.initFriends;
    _displayToAll = widget.initDisplayToAll;
  }

  bool enableButton() {
    return _displayToAll || _groupList.isNotEmpty || _friendsList.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _userService = Provider.of<UserService>(context);

    return CreatorPage(
      title: 'Who can see my\nBeacon?',
      onClose: widget.onClose,
      onBackClick: widget.onBackClick,
      continueText: widget.continueText,
      totalPageCount: widget.totalPageCount,
      currentPageIndex: widget.currentPageIndex,
      onContinuePressed: enableButton()
          ? () => widget.onContinue(_displayToAll, _groupList, _friendsList)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: 50,
              color: theme.primaryColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Display to all?',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Switch(
                      value: _displayToAll,
                      onChanged: (value) {
                        setState(() {
                          _displayToAll = value;
                        });
                      },
                    ),
                  ],
                ),
              )),
          if (!_displayToAll) _leftSubHeader(context, 'Groups'),
          if (!_displayToAll) _groupSelector(),
          if (!_displayToAll) _leftSubHeader(context, 'Friends'),
          if (!_displayToAll) _friendsButton(context),
          if (!_displayToAll)
            Column(
              children: _selectedFriendTiles(context),
            )
        ],
      ),
    );
  }

  Set<String> _getAllFriendsSelectedAndGroups() {
    Set<String> allFriends = _groupList
        .map((GroupModel g) => g.members)
        .expand((friend) => friend)
        .toSet();
    allFriends.addAll(_friendsList);
    return allFriends;
  }

  List<Widget> _selectedFriendTiles(BuildContext context) {
    return _getAllFriendsSelectedAndGroups().map((friend) {
      return ListTile(
        title: Text(
          friend,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        leading: Icon(Icons.account_circle_rounded, color: Colors.grey),
      );
    }).toList();
  }

  void _updateFriendsList(Set<String> friendsList) {
    setState(() {
      _friendsList = friendsList;
    });
  }

  void _handleGroupSelectionChanged(
      GroupModel group, bool selected, StateSetter setState) {
    setState(() {
      if (!selected) {
        _groupList.add(group);
      } else {
        _groupList.remove(group);
      }
    });
  }

  Widget _friendsButton(BuildContext context) {
    return BeaconFlatButton(
      title: 'Friends',
      onTap: () {
        setState(() {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context) {
              return FriendSelectorSheet(
                onContinue: _updateFriendsList,
                friendsSelected: _friendsList,
              );
            },
          );
        });
      },
    );
  }

  Container _leftSubHeader(BuildContext context, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, top: 7, bottom: 7),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyText1,
        textAlign: TextAlign.start,
      ),
    );
  }

  Container _groupSelector() {
    return Container(
      height: 85.0,
      padding: EdgeInsets.symmetric(vertical: 5.0),
      color: Theme.of(context).primaryColor,
      child: _userService.currentUser.groups.isEmpty
          ? Center(
              child: Text(
                "You have no groups",
              ),
            )
          : ListView(
              scrollDirection: Axis.horizontal,
              children: _userService.currentUser.groups.map((GroupModel group) {
                return SingleGroup(
                  group: group,
                  selected: _groupList.contains(group),
                  onGroupChanged: _handleGroupSelectionChanged,
                  setState: setState,
                );
              }).toList(),
            ),
    );
  }
}

typedef void GroupListChangeCallBack(
  GroupModel group,
  bool selected,
  StateSetter setState,
);

class SingleGroup extends StatelessWidget {
  SingleGroup({
    this.group,
    this.selected,
    this.onGroupChanged,
    this.setState,
  }) : super(key: ObjectKey(group));

  final GroupModel group;
  final bool selected;
  final StateSetter setState;
  final GroupListChangeCallBack onGroupChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          ClipOval(
            child: Material(
              color: Color(0xFF4FE30B),
              shape: CircleBorder(
                side: BorderSide(
                  color: selected ? Colors.purple : Color(0xFF4FE30B),
                  width: 2,
                ),
              ), // button color
              child: InkWell(
                splashColor: Colors.greenAccent, //
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: Icon(
                    group.icon,
                  ),
                ),
                onTap: () {
                  onGroupChanged(
                    group,
                    selected,
                    setState,
                  );
                },
              ),
            ),
          ),
          Text(
            group.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
