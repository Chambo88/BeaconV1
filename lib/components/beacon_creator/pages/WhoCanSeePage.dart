import 'package:beacon/models/GroupModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/ProfilePicWidget.dart';
import 'package:beacon/widgets/beacon_sheets/FriendSelectorSheet.dart';
import 'package:beacon/widgets/buttons/BeaconFlatButton.dart';
import 'package:beacon/widgets/tiles/BeaconCreatorSubTitle.dart';
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
  final InviteCallback onBackClick;
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
    this.totalPageCount,
    this.currentPageIndex,
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
    _groupList = {};
    _friendsList = widget.initFriends;
    _displayToAll = widget.initDisplayToAll;
  }

  bool enableButton() {
    // return _displayToAll || _groupList.isNotEmpty || _friendsList.isNotEmpty;
    return _displayToAll ||  _friendsList.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _userService = Provider.of<UserService>(context);

    return CreatorPage(
      title: "Who's welcome?",
      onClose: widget.onClose,
      onBackClick: () {return widget.onBackClick(_displayToAll, _groupList, _friendsList);},
      continueText: widget.continueText,
      totalPageCount: widget.totalPageCount,
      currentPageIndex: widget.currentPageIndex,
      onContinuePressed: enableButton()
          ? () {
        // return widget.onContinue(_displayToAll, _friendsList);
        return widget.onContinue(_displayToAll, _groupList, _friendsList);
      }
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BeaconFlatButton(
            arrow: false,
            icon: Icons.remove_red_eye_outlined,
            title: 'Display to all?',
            trailing: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Switch(
                  value: _displayToAll,
                  onChanged: (value) {
                    setState(() {
                      _displayToAll = value;
                    });
                  },
              ),
            ),
            onTap: () {
              setState(() {
                _displayToAll = !_displayToAll;
              });
            },
          ),
          if (!_displayToAll) _leftSubHeader(context, 'Groups'),
          if (!_displayToAll) _groupSelector(),
          if (!_displayToAll) _leftSubHeader(context, 'Friends'),
          if (!_displayToAll) _friendsButton(context),
          if (!_displayToAll) _leftSubHeader(context, 'Selected friends'),
          if (!_displayToAll)
            Column(
              children: _selectedFriendTiles(context),
            )
        ],
      ),
    );
  }

  // Set<String> _getAllFriendsSelectedAndGroups() {
  //   Set<String> allFriends = _groupList
  //       .map((GroupModel g) => g.members)
  //       .expand((friend) => friend)
  //       .toSet();
  //   allFriends.addAll(_friendsList);
  //   return allFriends;
  // }


  List<Widget> _selectedFriendTiles(BuildContext context) {
    UserService userService = Provider.of<UserService>(context);
    return _friendsList.map((friend) {
      UserModel friendModel = userService.getAFriendModelFromId(friend, user: userService.currentUser);
      if(friendModel.id == userService.currentUser.id) {
        return Container();
      }
      return ListTile(
        title: Text(
          "${friendModel.firstName} ${friendModel.lastName}",
          style: Theme.of(context).textTheme.headline5,
          overflow: TextOverflow.ellipsis,
        ),
        leading: ProfilePicture(user: friendModel, size: 18,),
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
        // _groupList.add(group);
        _friendsList.addAll(group.members);
      } else {
        // _groupList.remove(group);
        _friendsList.removeAll(group.members);
      }
    });
  }

  Widget _friendsButton(BuildContext context) {
    return BeaconFlatButton(
      icon: Icons.person_add_outlined,
      title: 'Add friends',
      onTap: () {
        setState(() {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            barrierColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context) {
              return FriendSelectorSheet(
                onContinue: _updateFriendsList,
                friendsSelected: _friendsList,
                // selectedFromGroups: _groupList
                //     .map((GroupModel g) => g.members)
                //     .expand((friend) => friend)
                //     .toSet()
              );
            },
          );
        });
      },
    );
  }

  Widget _leftSubHeader(BuildContext context, String text) {
    return BeaconCreatorSubTitle(text);
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
                if(_friendsList.containsAll(group.members)) {
                  _groupList.add(group);
                } else {
                  if(_groupList.contains(group)) {
                    _groupList.remove(group);
                  }
                }
                return SingleGroup(
                  group: group,
                  selected: _friendsList.containsAll(group.members),
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
