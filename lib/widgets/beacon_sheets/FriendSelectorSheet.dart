import 'package:beacon/library/ColorHelper.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/BeaconBottomSheet.dart';
import 'package:beacon/widgets/GreyCircleCheckBox.dart';
import 'package:beacon/widgets/ProfilePicWidget.dart';
import 'package:beacon/widgets/buttons/GradientButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../BeaconSearchBar.dart';

class FriendSelectorSheet extends StatefulWidget {
  Function? onContinue;
  Set<String>? friendsSelected = Set();
  // Set<String> selectedFromGroups = Set();

  FriendSelectorSheet({
    Key? key,
    this.onContinue,
    this.friendsSelected,
    // this.selectedFromGroups,
  }) : super(key: key);

  @override
  _FriendSelectorSheetState createState() => _FriendSelectorSheetState();
}

class _FriendSelectorSheetState extends State<FriendSelectorSheet> {
  UserService? _userService;
  TextEditingController? _searchController;
  final FocusNode _focusNode = FocusNode();
  List<UserModel> _filteredFriends = [];
  Set<String> _friendsSelected = {};
  FigmaColours? figmaColours;
  Set<String> _friendsSelectedForClose = {};
  // Set<String> _selectedFromGroups = {};

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _friendsSelected = widget.friendsSelected ?? {};
    _friendsSelectedForClose = {};
    _friendsSelectedForClose.addAll(_friendsSelected);
    // _selectedFromGroups = widget.selectedFromGroups?? {};
    figmaColours = FigmaColours();
  }

  @override
  void dispose() {
    _searchController!.dispose();
    super.dispose();
  }

  Color getCheckboxColor(Set<WidgetState> states) {
    const Set<WidgetState> interactiveStates = <WidgetState>{
      WidgetState.pressed,
      WidgetState.hovered,
      WidgetState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Color(figmaColours!.greyLight);
  }

  List<UserModel> getFilteredFriends(String filter) {
    return _userService!.currentUser!.friendModels!.where((friend) {
      return ((friend.firstName!.toLowerCase() + friend.lastName!.toLowerCase())
              .startsWith(filter) ||
          friend.lastName!.toLowerCase().startsWith(filter));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_userService == null) {
      _userService = Provider.of<UserService>(context);
      _filteredFriends = _userService!.currentUser!.friendModels!;
    }

    // Pop up Friend selector
    return BeaconBottomSheet(
      color: Color(figmaColours!.greyDark),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Friends",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: CloseButton(
                    onPressed: () {
                      widget.onContinue!(_friendsSelectedForClose);
                      Navigator.pop(context);
                    },
                    color: Color(FigmaColours().greyLight),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 5),
            child: BeaconSearchBar(
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
            child: ListView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: _filteredFriends.map((friend) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_friendsSelected.contains(friend.id)) {
                        _friendsSelected.remove(friend.id);
                      } else {
                        _friendsSelected.add(friend.id!);
                      }
                    });
                  },
                  child: ListTile(
                      leading: Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: ProfilePicture(
                          user: friend,
                          size: 20,
                        ),
                      ),
                      title: Text("${friend.firstName} ${friend.lastName}",
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.headlineSmall),
                      trailing: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: GreyCircleCheckBox(
                          toggle: _friendsSelected.contains(friend.id),
                        ),
                      )),
                );
              }).toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
            child: GradientButton(
              child: Text(
                'Continue',
                style: theme.textTheme.headlineMedium,
              ),
              gradient: ColorHelper.getBeaconGradient(),
              onPressed: () {
                widget.onContinue!(_friendsSelected);
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
