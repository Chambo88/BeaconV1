import 'package:beacon/models/EventModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/Dialogs/DateRangeDialog.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import 'EventDetailsPage.dart';

class EventsTab extends StatefulWidget {
  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  String filterBy;
  DateTime filterStartDate;
  DateTime filterEndDate;
  FigmaColours figmaColours;
  List<EventModel> eventModelsFiltered = [];
  List<EventModel> eventModelsAll = [];

  @override
  void initState() {
    // TODO: implement initState
    filterBy = "Mutual";
    filterStartDate = DateTime.now();
    figmaColours = FigmaColours();
    super.initState();
  }

  String getDateText(DateTime startTime) {
    if (DateTime.now().day == startTime.day &&
        DateTime.now().difference(startTime).inHours < 24) {
      if (startTime.hour > 16) {
        return "Tonight ${DateFormat.jm().format(startTime)}";
      } else {
        return "Today ${DateFormat.jm().format(startTime)}";
      }
    } else if (DateTime.now().add(Duration(days: 1)).day == startTime.day &&
        DateTime.now().difference(startTime).inHours < 48) {
      if (startTime.hour < 3) {
        return "Tonight ${DateFormat.jm().format(startTime)}";
      } else {
        return "This ${DateFormat.E().add_jm().format(startTime)}";
      }
    } else if (startTime.difference(DateTime.now()).inDays < 7) {
      return "This ${DateFormat.E().add_jm().format(startTime)}";
    } else if (startTime.difference(DateTime.now()).inDays < 365) {
      return "${DateFormat('EEE, MMM d h:mm a').format(startTime)}";
    } else {
      return "${DateFormat('MMM d, yyyy').format(startTime)}";
    }
  }

  @override
  Widget build(BuildContext context) {
    UserService userService = Provider.of<UserService>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getChips(context),
        FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('eventBeacons')
                .where('city', isEqualTo: userService.currentUser.city)
                .get(),
            builder: (context, dataSnapshot) {
              if (dataSnapshot.hasError) {
                print(dataSnapshot.error);
                return Text(dataSnapshot.error);
              }

              if (dataSnapshot.connectionState != ConnectionState.done) {
                return circularProgress();
              }

              if (dataSnapshot.hasData) {
                print('haveData');
                print(userService.currentUser.city);
                dataSnapshot.data.docs.forEach((document) {
                  EventModel event = EventModel.fromJson(document.data());
                  eventModelsAll.add(event);
                  eventModelsFiltered.add(event);
                });

                return _buildEventList(userService);
              }
              return TextButton(
                  child: Text('bla'),
                  onPressed: () => print(EventModel.dummy().toString()));
            }),
      ],
    );
  }

  ListView _buildEventList(UserService userService) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, i) {
        return eventTile(i, context, userService);
      },
      itemCount: eventModelsFiltered.length,
    );
  }

  Dismissible eventTile(int i, BuildContext context, UserService userService) {
    String mutualFriendCount = userService
        .getMutual(eventModelsFiltered[i].usersAttending)
        .length
        .toString();
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: Key(eventModelsFiltered[i].eventId),
      onDismissed: (direction) {},
      background: Container(
        color: Colors.red,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.archive_outlined,
                    color: Colors.white,
                  ),
                  Text(
                    "Archive",
                    style: Theme.of(context).textTheme.headline4,
                  )
                ],
              ),
            )
          ],
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  EventDetailsPage(event: eventModelsFiltered[i])));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  eventModelsFiltered[i].eventName + " -",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  eventModelsFiltered[i].hostName,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              Row(children: [
                Container(
                  width: 85,
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          image: NetworkImage(eventModelsFiltered[i].imageUrl),
                          fit: BoxFit.cover)),
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(Icons.date_range),
                          ),
                          Flexible(
                            child: Container(
                              child: Text(
                                getDateText(eventModelsFiltered[i].startTime)
                                    .replaceAll("", "\u{200B}"),
                                style: Theme.of(context).textTheme.headline6,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(Icons.location_on_outlined),
                          ),
                          Flexible(
                            child: Container(
                              child: Text(
                                eventModelsFiltered[i]
                                    .locationName
                                    .replaceAll("", "\u{200B}"),
                                style: Theme.of(context).textTheme.headline6,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(Icons.music_note_outlined),
                          ),
                          Text(
                            eventModelsFiltered[i].mainGenre,
                            style: Theme.of(context).textTheme.headline6,
                          )
                        ],
                      ),
                      Container(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(Icons.people_alt_outlined),
                          ),
                          RichText(
                            text: TextSpan(
                                text: (mutualFriendCount != '0')
                                    ? "${mutualFriendCount}m"
                                    : '',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(figmaColours.highlight),
                                ),
                                children: [
                                  TextSpan(
                                    text: (mutualFriendCount != '0')
                                        ? " | ${eventModelsFiltered[i].usersAttending.length.toString()}"
                                        : "${eventModelsFiltered[i].usersAttending.length.toString()}",
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  )
                                ]),
                            textWidthBasis: TextWidthBasis.longestLine,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Container getChips(BuildContext context) {
    return Container(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: ActionChip(
              side: BorderSide(width: 0),
              avatar: Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Icon(
                  Icons.people_outline_outlined,
                  color: (filterBy == "Mutual")
                      ? Color(figmaColours.highlight)
                      : Colors.white,
                ),
              ),
              label: Text(
                " Mutual ",
                style: TextStyle(
                    color: (filterBy == "Mutual")
                        ? Color(figmaColours.highlight)
                        : Colors.white),
              ),
              onPressed: () {
                setState(() {
                  filterBy = "Mutual";
                });
              },
              backgroundColor: Color(figmaColours.greyDark),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: ActionChip(
              side: BorderSide(width: 0),
              avatar: Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Icon(
                  Icons.arrow_upward_outlined,
                  color: (filterBy == "Top")
                      ? Color(figmaColours.highlight)
                      : Colors.white,
                ),
              ),
              label: Text(
                "Top ",
                style: TextStyle(
                    color: (filterBy == "Top")
                        ? Color(figmaColours.highlight)
                        : Colors.white),
              ),
              onPressed: () {
                setState(() {
                  filterBy = "Top";
                });
              },
              backgroundColor: Color(figmaColours.greyDark),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: ActionChip(
              labelPadding: EdgeInsets.only(left: 4),
              padding: const EdgeInsets.only(left: 8.0),
              side: BorderSide(width: 0),
              avatar: Icon(
                Icons.date_range_outlined,
                color: (filterStartDate != null)
                    ? Color(figmaColours.highlight)
                    : Colors.white,
              ),
              label: Text(
                'Date    ',
                style: TextStyle(
                    color: (filterStartDate != null)
                        ? Color(figmaColours.highlight)
                        : Colors.white),
              ),
              onPressed: () {
                return showDialog(
                    context: context,
                    builder: (context) {
                      return DateRangeDialog(
                        initStart: filterStartDate,
                        initEnd: filterEndDate,
                      );
                    }).then((args) {
                  if (args != null) {
                    filterStartDate = args.startDate;
                    if (args.endDate != null) {
                      filterEndDate = args.endDate;
                    } else {
                      filterEndDate = null;
                    }
                  } else {
                    filterStartDate = null;
                    filterEndDate = null;
                  }
                  setState(() {});
                });
              },
              backgroundColor: Color(figmaColours.greyDark),
            ),
          ),
        ],
      ),
    );
  }
}
