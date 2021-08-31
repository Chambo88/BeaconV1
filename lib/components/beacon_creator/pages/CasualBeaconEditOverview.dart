import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/BeaconService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/Dialogs/TwoButtonDialog.dart';
import 'package:beacon/widgets/ProfilePicWidget.dart';
import 'package:beacon/widgets/beacon_sheets/ViewAttendiesSheet.dart';
import 'package:beacon/widgets/buttons/BeaconFlatButton.dart';
import 'package:beacon/widgets/tiles/BeaconCreatorSubTitle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CasualBeaconEdit.dart';

// enum CasualBeaconEditStage {
//   overview,
//   whoCanSee,
//   description,
//   time,
//   location,
//   notifyNewUsers,
// }

class CasualBeaconEditOverview extends StatefulWidget {
  CasualBeacon beacon;
  final VoidCallback onBack;
  final void Function(CasualBeaconEditStage) setStage;
  CasualBeaconEditOverview({
    @required this.beacon,
    @required this.onBack,
    @required this.setStage,
  });

  @override
  _CasualBeaconEditOverviewState createState() => _CasualBeaconEditOverviewState();
}

class _CasualBeaconEditOverviewState extends State<CasualBeaconEditOverview> {
  CasualBeacon beacon;
  FigmaColours figmaColours = FigmaColours();
  BeaconService beaconService = BeaconService();
  List<UserModel> friendsAttending = [];

  @override
  void initState() {
    beacon = widget.beacon;
    super.initState();
  }

  List<Widget> getProfilePicStack() {
    List<Widget> profPics = [];
    double count = 0;
    for (UserModel friend in friendsAttending) {
      profPics.add(Padding(
          padding: EdgeInsets.only(left: count * 25),
          child: ProfilePicture(user: friend)));
      count += 1;
      if (count == 5) {
        break;
      }
    }
    profPics = profPics.reversed.toList();
    return profPics;
  }

  RichText getTextForPeopleGoing(
      String numPeopleGoing, ThemeData theme, String numFriendsGoing) {
    return RichText(
        overflow: TextOverflow.ellipsis,
        text: TextSpan(children: [
          TextSpan(
            text: '$numPeopleGoing ',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(figmaColours.highlight), fontSize: 18),
          ),
          TextSpan(
              text: 'going',
              style: theme.textTheme.headline4,
              children: (numFriendsGoing == '0')
              ? []
                  : [
              TextSpan(
              text: ', including ', style: theme.textTheme.headline4),
          TextSpan(
            text: '$numFriendsGoing ',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(figmaColours.highlight),
                fontSize: 18),
          ),
          TextSpan(text: 'friends', style: theme.textTheme.headline4),
        ])
        ]),
    );
  }

  Widget attendingTile(UserModel currentUser, CasualBeacon _beacon,
      ThemeData theme, BuildContext context) {
    String numPeopleGoing = _beacon.peopleGoing.length.toString();
    friendsAttending.clear();
    for (UserModel friend in currentUser.friendModels) {
      if (_beacon.peopleGoing.contains(friend.id)) {
        friendsAttending.add(friend);
      }
    }
    String numFriendsGoing = friendsAttending.length.toString();

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) {
            return ViewAttendiesSheet(
              onContinue: () {
                Navigator.of(context).pop();
              },
              attendiesIds: _beacon.peopleGoing,
            );
          },
        );
      },
      child: Container(

        color: Color(figmaColours.greyDark),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Icon(
                Icons.people_outline_outlined,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12 ,vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    friendsAttending.isNotEmpty
                        ? Stack(
                      children: getProfilePicStack(),
                    )
                        : Container(),
                    Padding(
                      padding: EdgeInsets.only(
                          top: (friendsAttending.isNotEmpty) ? 6 : 0),
                      child: getTextForPeopleGoing(
                          numPeopleGoing, theme, numFriendsGoing),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 18,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserModel currentUser = Provider.of<UserService>(context).currentUser;
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Container(
          height: 70,
          width: double.infinity,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey,
                    ),
                    onPressed: widget.onBack,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Text(
                    "${beacon.eventName}",
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(child: SingleChildScrollView(
            child: Column(
              children: [
                BeaconCreatorSubTitle("Who's coming"),
                attendingTile(currentUser, beacon, theme, context),
                BeaconCreatorSubTitle("Edit"),
                BeaconFlatButton(icon: Icons.description_outlined, title: "Title & description",onTap: () {
                  widget.setStage(CasualBeaconEditStage.description);
                }, arrow: true,),
                Container(height: 6,),
                BeaconFlatButton(icon: Icons.remove_red_eye_outlined, title: "Who's welcome",onTap: () {
                  widget.setStage(CasualBeaconEditStage.whoCanSee);
                }, arrow: true,),
                Container(height: 6,),
                BeaconFlatButton(icon: Icons.access_time_outlined, title: "Time", onTap: () {
                  widget.setStage(CasualBeaconEditStage.time);
                }, arrow: true,),
                Container(height: 6,),
                BeaconFlatButton(icon: Icons.location_on_outlined, title: "Location", onTap: () {
                  widget.setStage(CasualBeaconEditStage.location);
                }, arrow:true,),
                Container(height: 6,),
                BeaconFlatButton(icon: Icons.delete_outline, title: "Cancel", onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return TwoButtonDialog(
                          title: "Cancel beacon",
                          bodyText: "Are you sure you want Cancel this beacon?",
                          onPressedGrey: () => Navigator.pop(context, false),
                          onPressedHighlight: () => Navigator.pop(context, true),
                          buttonGreyText: "No",
                          buttonHighlightText: "Yes",
                        );
                      }).then((value) {
                        if(value == true)  {
                          beaconService.deleteCasualBeacon(beacon, currentUser);
                          widget.onBack();
                        }
                  });
                }, arrow:false,),
              ],
            )
        )),
      ],
    );
  }
}
