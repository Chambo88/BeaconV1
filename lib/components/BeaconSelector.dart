import 'dart:ui';

import 'package:beacon/Assests/Icons.dart';
import 'package:beacon/components/FriendSelectorSheet.dart';
import 'package:beacon/library/ColorHelper.dart';
import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/BeaconType.dart';
import 'package:beacon/models/GroupModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/buttons/FlatArrowButton.dart';
import 'package:beacon/widgets/buttons/GradientButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class BeaconSelector extends StatefulWidget {
  BeaconSelector({Key key, this.user}) : super(key: key);
  UserModel user;

  @override
  _BeaconSelectorState createState() => _BeaconSelectorState();
}

class _BeaconSelectorState extends State<BeaconSelector> {
  var _showBeaconEditor = false;
  var _displayToAll = false;
  BeaconType _beaconTypeSelected;
  GetIcons iconStuff = GetIcons();

  var _groupList = Set<GroupModel>();
  var _friendsList = Set<String>();

  final TextEditingController _beaconDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (_showBeaconEditor) _beaconEditor(context),
        _beaconButton()
      ],
    );
  }

  void _reset() {
    setState(() {
      _beaconTypeSelected = null;
      _groupList = new Set();
      _friendsList = new Set();
      _displayToAll = false;
    });
  }

  void _toggleBeaconEditor() {
    _showBeaconEditor = !_showBeaconEditor;
  }

  Widget _beaconButton() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: RawMaterialButton(
          onPressed: () {
            _reset();
            _toggleBeaconEditor();
          },
          elevation: 2.0,
          fillColor: _getBeaconColor(),
          constraints: BoxConstraints.tight(Size(80, 80)),
          shape: CircleBorder(),
        ),
      ),
    );
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

  Color _getBeaconColor() {
    if (!widget.user.beacon.active) {
      return Colors.grey;
    } else {
      return Color(0xFFFF00CC);
    }
  }

  Widget _eventBeacon(BuildContext context) {
    return Container(
      child: _whoCanSeeMyBeaconPage(context),
    );
  }

  Widget _casualBeacon(BuildContext context) {
    return Container(
      child: _whoCanSeeMyBeaconPage(context),
    );
  }

  Widget _friendsButton(BuildContext context) {
    return FlatArrowButton(
      title: 'Friends',
      onTap: () {
        setState(() {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context) {
              return FriendSelectorSheet(
                user: widget.user,
                updateFriendsList: _updateFriendsList,
                friendsSelected: _friendsList,
              );
            },
          );
        });
      },
    );
  }

  Widget _whoCanSeeMyBeaconPage(BuildContext context) {
    return _mainEditorPage(
      context: context,
      title: 'Who can see my\nBeacon?',
      onBackClick: _reset,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: 50,
              color: Theme.of(context).primaryColor,
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
          if (!_displayToAll) groups(setState, iconStuff),
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

  Container _leftSubHeader(BuildContext context, String text) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyText2,
          textAlign: TextAlign.start,
        ));
  }

  Set<String> _getAllFriendsSelectedAndGroups() {
    Set<String> allFriends = _groupList
        .map((GroupModel g) => g.userIds)
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

  // TODO need to build description page
  Widget _descriptionPage(BuildContext context) {
    return _mainEditorPage(
        context: context,
        title: 'Beacon\ndescription',
        onBackClick: _reset,
        child: Text('Description Place Holder',
            style: Theme.of(context).textTheme.headline1));
  }

  Widget _liveBeacon(BuildContext context) {
    return Container(child: _whoCanSeeMyBeaconPage(context));
  }

  Text _beaconHeader(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline2,
      textAlign: TextAlign.center,
    );
  }

  Widget _beaconSelectorHeader(
      {BuildContext context, String title, Function onBackClick}) {
    return Container(
      height: 70,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          onBackClick != null
              ? IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey,
                  ),
                  onPressed: onBackClick,
                )
              : Container(),
          _beaconHeader(context, title),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: () {
              setState(() {
                _showBeaconEditor = false;
              });
            },
          ),
        ],
      ),
    );
  }

  // Wraps the child in a ScrollView with a back, close & next button
  // and a header
  // TODO need to create dynamic next button
  Widget _mainEditorPage(
      {BuildContext context,
      String title,
      Function onBackClick,
      Widget child}) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _beaconSelectorHeader(
          context: context,
          title: title,
          onBackClick: onBackClick,
        ),
        Expanded(child: SingleChildScrollView(child: child)),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: GradientButton(
            child: Text(
              'Next',
              style: theme.textTheme.headline4,
            ),
            gradient: ColorHelper.getBeaconGradient(),
            onPressed: () {
              // Mock data
              context.read<UserService>().updateBeacon(LiveBeacon(
                      "1234",
                      "userId",
                      "userName",
                      BeaconType.live.toString(),
                      true,
                      "1234",
                      "123",
                      "ABCBeacon Description",
                      users: [
                        "4P1t6GqRIPVRzgX0X9dX35cl1462",
                        "2ipQa6HgvVSSeSFOzkMPUM7LUgR2"
                      ]));
            },
          ),
        ),
      ],
    );
  }

  Widget _beaconType(BuildContext context, BeaconType type) {
    return InkWell(
      onTap: () {
        setState(() {
          _beaconTypeSelected = type;
        });
      },
      child: Container(
        height: 80,
        margin: EdgeInsets.only(top: 3),
        color: const Color(0xFF181818),
        child: Container(
          margin: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 50.0,
                height: 50.0,
                decoration: new BoxDecoration(
                  color: type.color,
                  shape: BoxShape.circle,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    type.title,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Container(
                    width: 200,
                    child: Text(
                      type.description,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  )
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).iconTheme.color,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _beaconTypeSelector(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 70,
          child: Center(child: _beaconHeader(context, 'Beacon Type')),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _beaconType(context, BeaconType.live),
                _beaconType(context, BeaconType.casual),
                _beaconType(context, BeaconType.event)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _getBeaconEditorChild(BuildContext context) {
    switch (_beaconTypeSelected) {
      case BeaconType.live:
        return _liveBeacon(context);
      case BeaconType.casual:
        return _casualBeacon(context);
      case BeaconType.event:
        return _eventBeacon(context);
      default:
        return _beaconTypeSelector(context);
    }
  }

  Widget _beaconEditor(BuildContext context) {
    return Flexible(
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 30),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          border: Border.all(
            color: Theme.of(context).backgroundColor,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Container(child: _getBeaconEditorChild(context)),
      ),
    );
  }

  TextField textField() {
    return TextField(
      controller: _beaconDescriptionController,
      decoration: InputDecoration(
        labelText: "Description",
      ),
    );
  }

  Container groups(StateSetter setState, GetIcons iconStuff) {
    return Container(
      height: 85.0,
      padding: EdgeInsets.symmetric(vertical: 5.0),
      color: Theme.of(context).primaryColor,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: widget.user.groups.map((GroupModel group) {
          return SingleGroup(
            group: group,
            selected: _groupList.contains(group),
            onGroupChanged: _handleGroupSelectionChanged,
            setState: setState,
            iconStuff: iconStuff,
          );
        }).toList(),
      ),
    );
  }
}

typedef void GroupListChangeCallBack(
    GroupModel group, bool selected, StateSetter setState);

class SingleGroup extends StatelessWidget {
  SingleGroup({
    this.group,
    this.selected,
    this.onGroupChanged,
    this.setState,
    this.iconStuff,
  }) : super(key: ObjectKey(group));

  final GroupModel group;
  final bool selected;
  final StateSetter setState;
  final GroupListChangeCallBack onGroupChanged;
  final GetIcons iconStuff;

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
                    width: 2),
              ), // button color
              child: InkWell(
                splashColor: Colors.greenAccent, //
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: Icon(
                    iconStuff.getIconFromString(group.icon),
                  ),
                ),
                onTap: () {
                  onGroupChanged(group, selected, setState);
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
