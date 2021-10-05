import 'package:beacon/models/EventModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/HostProfilePicWidget.dart';
import 'package:beacon/widgets/ProfilePicWidget.dart';
import 'package:beacon/widgets/beacon_sheets/ViewAttendiesSheet.dart';
import 'package:beacon/widgets/buttons/OutlinedGradientButton.dart';
import 'package:beacon/widgets/buttons/SmallGradientButton.dart';
import 'package:beacon/widgets/buttons/SmallOutlinedButton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventDetailsPage extends StatefulWidget {

  EventModel event;

  EventDetailsPage({this.event});

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {

  EventModel event;
  FigmaColours figmaColours;
  String genreString;
  List<UserModel> friendsAttending = [];

  @override
  void initState() {
    // TODO: implement initState
    this.event = widget.event;
    figmaColours = FigmaColours();
    genreString = generateGenresString();
    super.initState();
  }

  String generateGenresString() {
    String returnMe = '';
    for(String genre in event.genres) {
      returnMe += genre + ', ';
    }
    returnMe = returnMe.substring(0, returnMe.length - 2);
    return returnMe;
  }

  @override
  Widget build(BuildContext context) {
    UserService userService = Provider.of<UserService>(context);
    UserModel currentUser = userService.currentUser;
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(event.eventName),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(event.imageUrl),
                          fit: BoxFit.cover
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${DateFormat('E, MMM d').format(event.startTime)}, ${DateFormat('Hm').format(event.startTime)} - '
                        '${DateFormat('Hm').format(event.endTime)}',
                    style: TextStyle(
                        color: Color(figmaColours.highlight),
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      HostProfilePicture(
                        picURL: event.hostLogoUrl,
                        hostName: event.hostName,
                        size: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text('Host - ',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      Text(event.hostName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis
                        ),
                      ),
                      Spacer(),
                      currentUser.hostsFollowed.contains(event.hostId)? SmallGradientButton(
                        width: 110,
                        height: 30,
                        onPressed: () {
                          userService.changeFollowHost(event.hostId);
                          setState(() {});
                        },
                        child: Text("Following",
                        style: Theme.of(context).textTheme.headline5),
                      ) : SmallOutlinedButton(
                        width: 110,
                        height: 30,
                        onPressed: () {userService.changeFollowHost(event.hostId);
                        setState(() {});
                        },
                        title: "Follow",
                      )

                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(
                    height: 1,
                    color: Color(figmaColours.greyMedium),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.music_note_outlined),
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          "Genre's - ",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      Text(
                        genreString,
                        style: Theme.of(context).textTheme.headline5,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(
                    height: 1,
                    color: Color(figmaColours.greyMedium),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: attendingTile(currentUser, event, theme, context),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(
                    height: 1,
                    color: Color(figmaColours.greyMedium),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: getLocationRow(event, theme),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(
                    height: 1,
                    color: Color(figmaColours.greyMedium),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                      event.desc,
                      style: theme.textTheme.headline5,
                    ),
                ),

              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              color: Color(figmaColours.greyDark),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: Text(
                      "Price - ",
                      style: theme.textTheme.headline4,
                    ),
                  ),
                  Text(
                    "\$${event.price.toString()}",
                    style: TextStyle(
                      color: Color(figmaColours.highlight),
                      fontSize: 18
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SmallGradientButton(
                      width: 115,
                      height: 30,
                      onPressed: () {},
                      child: Text(
                        "Get Tickets",
                        style: theme.textTheme.headline5,
                      ),
                    ),
                  ),
                  currentUser.eventsAttending.contains(event.eventId)?
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SmallGradientButton(
                      width: 115,
                      height: 30,
                      onPressed: () {
                        userService.changeEventAttending(event.eventId);
                        setState(() {});
                      },
                      child: Text("Going",
                          style: Theme.of(context).textTheme.headline5),
                    ),
                  ) : Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SmallOutlinedButton(
                      width: 110,
                      height: 30,
                      onPressed: () {userService.changeEventAttending(event.eventId);
                      setState(() {});
                      },
                      title: "Going?",
                    ),
                  )

                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Row getLocationRow(EventModel event, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.location_on_outlined, size: 30),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.locationName,
                  style: theme.textTheme.headline4,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(event.fullAddress,
                      style: TextStyle(
                        color: Color(figmaColours.greyLight),
                        fontSize: 16,
                      )),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget attendingTile(UserModel currentUser, EventModel event,
      ThemeData theme, BuildContext context) {
    String numPeopleGoing = event.usersAttending.length.toString();
    friendsAttending.clear();
    for (UserModel friend in currentUser.friendModels) {
      if (event.usersAttending.contains(friend.id)) {
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
              attendiesIds: event.usersAttending,
            );
          },
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline_outlined,
            size: 30,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          )
        ],
      ),
    );
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

  List<Widget> getProfilePicStack() {
    List<Widget> profPics = [];
    double count = 0;
    for (UserModel friend in friendsAttending) {
      profPics.add(Padding(
          padding: EdgeInsets.only(left: count * 25),
          child: ProfilePicture(user: friend)));
      count += 1;
      if (count == 8) {
        break;
      }
    }
    profPics = profPics.reversed.toList();
    return profPics;
  }


}
