import 'package:beacon/models/GroupModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/GreyCircleCheckBox.dart';
import 'package:beacon/widgets/ProfilePicWidget.dart';
import 'package:beacon/widgets/buttons/BeaconFlatButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CreatorPage.dart';

typedef void NotifyCallback(List<UserModel> users);
typedef void NotifyCallback2(Set<UserModel> friends, bool notifyAll);

class NotifyPage extends StatefulWidget {
  final NotifyCallback2 onBackClick;
  final VoidCallback onClose;
  final NotifyCallback onContinue;
  final String continueText;
  final int totalPageCount;
  final int currentPageIndex;
  final Set<GroupModel> initGroups;
  final Set<String> initFriends;
  final bool initNotifyAll;
  final Set<UserModel> initNotifyFriends;
  final List<UserModel> fullList;

  NotifyPage({
    @required this.onBackClick,
    @required this.onClose,
    @required this.onContinue,
    @required this.totalPageCount,
    @required this.currentPageIndex,
    this.initNotifyFriends,
    this.initGroups,
    this.initFriends,
    this.initNotifyAll,
    this.continueText = 'Next',
    this.fullList,
  });

  @override
  _NotifyPageState createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage> {
  var _notifyFriends = Set<UserModel>();
  var _notifyAll = true;
  var _groupsToChoseFrom = Set<GroupModel>();
  var _initFriends = Set<UserModel>();
  var _initFriendsIds = Set<String>();

  @override
  void initState() {
    super.initState();
    _initFriendsIds = widget.initFriends;
    _groupsToChoseFrom = widget.initGroups;
    Set<String> IdsFromGroups = _groupsToChoseFrom
        .map((GroupModel g) => g.members)
        .expand((friend) => friend)
        .toSet();
    _initFriendsIds.addAll(IdsFromGroups);
    _initFriends = _initFriendsIds.map((friend) {
      for (UserModel user in widget.fullList) {
        if (user.id == friend) {
          return user;
        }
      }
    }).toSet();
    _notifyFriends = widget.initNotifyFriends;
    _notifyAll = widget.initNotifyAll;
  }

  @override
  Widget build(BuildContext context) {
    return CreatorPage(
        title: 'Notify',
        onClose: widget.onClose,
        onBackClick: () {
          widget.onBackClick(_notifyFriends, _notifyAll);
        },
        continueText: widget.continueText,
        onContinuePressed: () {
          if(_notifyAll) {
            widget.onContinue(_initFriends.toList());
          }
          else {
            widget.onContinue(_notifyFriends.toList());
          }
        },
        totalPageCount: widget.totalPageCount,
        currentPageIndex: widget.currentPageIndex,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          BeaconFlatButton(
            arrow: false,
            icon: Icons.notifications_outlined,
            title: 'Notify all?',
            trailing: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Switch(
                value: _notifyAll,
                onChanged: (value) {
                  setState(() {
                    _notifyAll = value;
                  });
                },
              ),
            ),
            onTap: () {
              setState(() {
                _notifyAll = !_notifyAll;
              });
            },
          ),
          if (!_notifyAll && _groupsToChoseFrom.isNotEmpty)
            _leftSubHeader(context, 'Notify group members'),
          if (!_notifyAll && _groupsToChoseFrom.isNotEmpty) _groupSelector(),
          if (!_notifyAll) _leftSubHeader(context, 'Notify friends'),
          if (!_notifyAll)
            Column(
              children: _selectedFriendTiles(context),
            )
        ]));
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

  void _handleGroupSelectionChanged(bool selected, GroupModel group, StateSetter setState, BuildContext context) {
    List<UserModel> idToUserModel = [];
    UserService userService = Provider.of<UserService>(context, listen: false);
    group.members.forEach((member) {
      UserModel friend = userService.getAFriendModelFromId(member);
      idToUserModel.add(friend);
    });
    setState(() {
      if (!selected) {
        _notifyFriends.addAll(idToUserModel);
      } else {
        _notifyFriends.removeAll(idToUserModel);
      }
    });
  }

  Container _groupSelector() {
    Set<String> notifyIds = {};
    _notifyFriends.forEach((e) {notifyIds.add(e.id);});
    return Container(
      height: 85.0,
      padding: EdgeInsets.symmetric(vertical: 5.0),
      color: Theme.of(context).primaryColor,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _groupsToChoseFrom.map((GroupModel group) {
          return SingleGroup(
            group: group,
            selected: notifyIds.containsAll(group.members.toSet()),
            onGroupChanged: _handleGroupSelectionChanged,
            setState: setState,
          );
        }).toList(),
      ),
    );
  }


  List<Widget> _selectedFriendTiles(BuildContext context) {
    return _initFriends.map((friend) {
      return GestureDetector(
        onTap: () {
          setState(() {
            if (_notifyFriends.contains(friend)) {
              _notifyFriends.remove(friend);
            }
            else {_notifyFriends.add(friend);}
          });
        },
        child: ListTile(
            title: Text(
              "${friend.firstName} ${friend.lastName}",
              style: Theme.of(context).textTheme.headline5,
            ),
            leading: ProfilePicture(
              user: friend,
              size: 18,
            ),
            trailing: Padding(
              padding: EdgeInsets.only(right: 10),
              child:
                  GreyCircleCheckBox(toggle: _notifyFriends.contains(friend)),
            )),
      );
    }).toList();
  }
}

typedef void GroupListChangeCallBack(
  bool selected,
  GroupModel group,
  StateSetter setState,
    BuildContext context,
);

class SingleGroup extends StatelessWidget {
  SingleGroup({
    this.group,
    this.onGroupChanged,
    this.setState,
    this.selected,
  }) : super(key: ObjectKey(group));

  final GroupModel group;
  final StateSetter setState;
  final GroupListChangeCallBack onGroupChanged;
  final bool selected;

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
                    selected,
                    group,
                    setState,
                    context,
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
