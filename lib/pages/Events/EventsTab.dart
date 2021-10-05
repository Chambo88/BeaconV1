import 'package:beacon/models/EventModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/Dialogs/DateRangeDialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventsTab extends StatefulWidget {

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {

  String filterBy;
  DateTime filterStartDate;
  DateTime filterEndDate;
  FigmaColours figmaColours;
  List<EventModel> eventModelsTemp;

  @override
  void initState() {
    // TODO: implement initState
    filterBy = "Mutual";
    filterStartDate = DateTime.now();
    figmaColours = FigmaColours();
    eventModelsTemp = [EventModel.dummy()];
    eventModelsTemp[0].startTime = DateTime(2021, 9, 11, 10);
    eventModelsTemp[0].usersAttending.add("t4jJNxWBAXcHoX3V3vculWZJHfr1");
    super.initState();
  }

  String getDateText(DateTime startTime) {
    if(DateTime.now().day == startTime.day && DateTime.now().difference(startTime).inHours < 24 ) {
      if(startTime.hour > 16) {
        return "Tonight ${DateFormat.jm().format(startTime)}";
      } else {
        return "Today ${DateFormat.jm().format(startTime)}";
      }
    } else if (DateTime.now().add(Duration(days: 1)).day == startTime.day && DateTime.now().difference(startTime).inHours < 48 ){
      if(startTime.hour < 3) {
        return "Tonight ${DateFormat.jm().format(startTime)}";
      } else {
        return "This ${DateFormat.E().add_jm().format(startTime)}";
      }
    } else if (startTime.difference(DateTime.now()).inDays < 7 ){
      return "This ${DateFormat.E().add_jm().format(startTime)}";
    } else if (startTime.difference(DateTime.now()).inDays < 365){
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
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
            itemBuilder: (context, i) {
            String mutualFriendCount = userService.getMutual(eventModelsTemp[i].usersAttending).length.toString();
              return Dismissible(
                direction: DismissDirection.endToStart,
                key: Key(eventModelsTemp[i].eventId),
                onDismissed: (direction) {},
                background: Container(color: Colors.red,
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(eventModelsTemp[i].eventName + " -",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(eventModelsTemp[i].hostName,
                          style: Theme.of(context).textTheme.body2,
                        ),
                      ),
                      Row(
                        children: [Container(
                          width: 85,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: NetworkImage(eventModelsTemp[i].imageUrl),
                              fit: BoxFit.cover
                            )
                          ),
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
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Icon(Icons.date_range),
                                  ),
                                  Flexible(
                                    child: Container(
                                      child: Text(
                                        getDateText(eventModelsTemp[i].startTime).replaceAll("", "\u{200B}"),
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
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Icon(Icons.location_on_outlined),
                                  ),
                                  Flexible(
                                    child: Container(
                                      child: Text(
                                          eventModelsTemp[i].locationName.replaceAll("", "\u{200B}"),
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
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Icon(Icons.music_note_outlined),
                                    ),
                                    Text(
                                      eventModelsTemp[i].mainGenre,
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
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Icon(Icons.people_alt_outlined),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: (mutualFriendCount != '0') ? "${mutualFriendCount}m" : '',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(figmaColours.highlight),
                                        ),
                                        children: [
                                          TextSpan(
                                            text: (mutualFriendCount != '0') ? " | ${eventModelsTemp[i].usersAttending.length.toString()}" :
                                            "${eventModelsTemp[i].usersAttending.length.toString()}",
                                            style: Theme.of(context).textTheme.headline6,
                                          )
                                        ]
                                      ),
                                      textWidthBasis: TextWidthBasis.longestLine,
                                      overflow: TextOverflow.ellipsis,

                                    )
                                  ],
                                ),

                              ],
                            ),
                          )
                        ]
                      ),
                    ],
                  ),
                ),
              );
            },

          itemCount: 1,
        )
      ],
    );
  }

  Container getChips(BuildContext context) {
    return Container(
        height:50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ActionChip(
                side: BorderSide(width: 0),
                avatar: Padding(
                  padding: const EdgeInsets.only(left:6.0),
                  child: Icon(Icons.people_outline_outlined,
                    color: (filterBy == "Mutual")? Color(figmaColours.highlight) : Colors.white,
                  ),
                ),

                label: Text(" Mutual ",
                  style: TextStyle(
                      color: (filterBy == "Mutual")? Color(figmaColours.highlight) : Colors.white
                  ),
                ),
                onPressed: () {
                  setState(() {filterBy = "Mutual";});
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
                  child: Icon(Icons.arrow_upward_outlined,
                    color: (filterBy == "Top")? Color(figmaColours.highlight) : Colors.white,
                  ),
                ),
                label: Text("Top ",
                  style: TextStyle(
                    color: (filterBy == "Top")? Color(figmaColours.highlight) : Colors.white
                  ),
                ),
                onPressed: () {
                  setState(() {filterBy = "Top";});
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
                avatar: Icon(Icons.date_range_outlined,
                  color: (filterStartDate != null)? Color(figmaColours.highlight) : Colors.white,
                ),
                label: Text('Date    ',
                  style: TextStyle(
                      color: (filterStartDate != null)? Color(figmaColours.highlight) : Colors.white
                  ),),
                onPressed: () {
                  return showDialog(
                      context: context,
                      builder: (context) {
                        return DateRangeDialog(
                          initStart: filterStartDate,
                          initEnd: filterEndDate,
                        );
                      }).then((args) {
                        if(args != null) {
                          filterStartDate = args.startDate;
                          if(args.endDate != null) {
                            filterEndDate = args.endDate;
                          } else {
                            filterEndDate = null;
                          }

                        } else {
                          filterStartDate = null;
                          filterEndDate = null;
                        }
                        setState(() {
                        });
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
