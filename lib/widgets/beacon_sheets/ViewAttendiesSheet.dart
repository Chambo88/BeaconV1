import 'package:beacon/library/ColorHelper.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/BeaconBottomSheet.dart';
import 'package:beacon/widgets/ProfilePicWidget.dart';
import 'package:beacon/widgets/buttons/GradientButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../BeaconSearchBar.dart';
import '../progress_widget.dart';

class ViewAttendiesSheet extends StatefulWidget {
  Function? onContinue;
  List<String>? attendiesIds;

  ViewAttendiesSheet({Key? key, this.onContinue, this.attendiesIds})
      : super(key: key);

  @override
  _ViewAttendiesSheetState createState() => _ViewAttendiesSheetState();
}

class _ViewAttendiesSheetState extends State<ViewAttendiesSheet> {
  UserService? _userService;
  TextEditingController? _searchController;
  List<UserModel> _filteredFriendsAttending = [];
  List<UserModel> _filteredAttendies = [];
  FigmaColours? figmaColours;
  List<UserModel>? attendies;
  List<UserModel>? friendsAttending;
  List<Future<QuerySnapshot>>? attendiesFromFB;
  bool? firstTime;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    figmaColours = FigmaColours();
    firstTime = true;
    if (widget.attendiesIds!.isNotEmpty) {
      attendiesFromFB = getSnapshots(widget.attendiesIds!);
    }
    attendies = [];
    friendsAttending = [];
  }

  List<Future<QuerySnapshot>> getSnapshots(List<String> attendiesIds) {
    var chunks = [];
    for (var i = 0; i < attendiesIds.length; i += 10) {
      chunks.add(attendiesIds.sublist(
          i, i + 10 > attendiesIds.length ? attendiesIds.length : i + 10));
    } //break a list of whatever size into chunks of 10. cos of firebase limit

    List<Future<QuerySnapshot>> combine = [];
    for (var i = 0; i < chunks.length; i++) {
      final result = FirebaseFirestore.instance
          .collection('users')
          .where('userId', whereIn: chunks[i])
          .get();
      combine.add(result);
    }
    return combine; //get a list of the Future, which will have 10 each.
  }

  @override
  void dispose() {
    _searchController!.dispose();
    super.dispose();
  }

  List<UserModel> getFilteredFriends(String filter) {
    return friendsAttending!.where((friend) {
      return ((friend.firstName!.toLowerCase() + friend.lastName!.toLowerCase())
              .startsWith(filter) ||
          friend.lastName!.toLowerCase().startsWith(filter));
    }).toList();
  }

  List<UserModel> getFilteredAttendies(String filter) {
    return attendies!.where((friend) {
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
    }

    // Pop up Friend selector
    return BeaconBottomSheet(
      color: Color(figmaColours!.greyDark),
      child: Column(
        children: [
          title(),
          searchBar(),
          FutureBuilder(
              future: Future.wait(attendiesFromFB!),
              builder:
                  (context, AsyncSnapshot<List<QuerySnapshot>> dataSnapshot) {
                while (!dataSnapshot.hasData) {
                  return Container(
                    height: 200,
                    child: Column(
                      children: [
                        Center(child: circularProgress()),
                      ],
                    ),
                  );
                }

                if (firstTime == true) {
                  dataSnapshot.data!.forEach((QuerySnapshot documentSet) {
                    documentSet.docs.forEach((document) {
                      UserModel user = UserModel.fromDocument(document);

                      if (!_userService!.currentUser!.friends!
                          .contains(user.id)) {
                        attendies!.add(user);
                      } else {
                        friendsAttending!.add(user);
                      }
                    });
                  });
                  _filteredFriendsAttending = friendsAttending!;
                  _filteredAttendies = attendies!;
                }
                firstTime = false;

                return listOfPeople(
                    filteredAttendies: _filteredAttendies,
                    theme: theme,
                    filteredFriendsAttending: _filteredFriendsAttending);
              }),
          Spacer(),
          continueButton(theme: theme)
        ],
      ),
    );
  }

  Container searchBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 0, 12, 5),
      child: BeaconSearchBar(
        autofocus: false,
        controller: _searchController,
        hintText: 'Name',
        onChanged: (filter) {
          setState(() {
            _filteredFriendsAttending = getFilteredFriends(filter);
            _filteredAttendies = getFilteredAttendies(filter);
          });
        },
      ),
    );
  }
}

class listOfPeople extends StatelessWidget {
  const listOfPeople({
    Key? key,
    @required List<UserModel>? filteredAttendies,
    @required this.theme,
    @required List<UserModel>? filteredFriendsAttending,
  })  : _filteredAttendies = filteredAttendies,
        _filteredFriendsAttending = filteredFriendsAttending,
        super(key: key);

  final List<UserModel>? _filteredAttendies;
  final ThemeData? theme;
  final List<UserModel>? _filteredFriendsAttending;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 20),
              child: Text('Friends', style: theme!.textTheme.bodyMedium),
            ),
            Column(
              children: _filteredFriendsAttending!.map((friend) {
                return ListTile(
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
                      style: theme!.textTheme.headlineMedium),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 20, top: 10),
              child: Text('Others', style: theme!.textTheme.bodyMedium),
            ),
            Column(
              children: _filteredAttendies!.map((friend) {
                return ListTile(
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
                      style: theme!.textTheme.headlineMedium),
                );
              }).toList(),
            )
          ]),
    );
  }
}

class continueButton extends StatelessWidget {
  const continueButton({
    Key? key,
    @required this.theme,
  }) : super(key: key);

  final ThemeData? theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
      child: GradientButton(
        child: Text(
          'Continue',
          style: theme!.textTheme.headlineMedium,
        ),
        gradient: ColorHelper.getBeaconGradient(),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class title extends StatelessWidget {
  const title({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              "Who's going",
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: CloseButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: Color(FigmaColours().greyLight),
            ),
          )
        ],
      ),
    );
  }
}
