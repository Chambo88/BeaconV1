import 'package:beacon/models/EventModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/Dialogs/DateRangeDialog.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:beacon/widgets/tiles/EventTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventsTab extends StatefulWidget {
  final String city;
  Future<QuerySnapshot> eventData;

  EventsTab({this.city, this.eventData});

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
  Future<QuerySnapshot> _eventData;
  bool gotData = false;

  @override
  void initState() {
    filterBy = "Mutual";
    figmaColours = FigmaColours();
    _eventData = widget.eventData;

    super.initState();
  }

  Column _buildEventList() {
    UserService userService = Provider.of<UserService>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getChips(context),
        SingleChildScrollView(
          physics: ScrollPhysics(),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              String mutualFriendCount = userService
                  .getMutual(eventModelsFiltered[i].usersAttending)
                  .length
                  .toString();
              return EventTile(
                key: ObjectKey(i),
                event: eventModelsFiltered[i],
                mutualFriendCount: mutualFriendCount,
                figmaColours: figmaColours,
              );
            },
            itemCount: eventModelsFiltered.length,
          ),
        ),
      ],
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _eventData,
        builder: (context, dataSnapshot) {
          if (dataSnapshot.hasError) {
            print(dataSnapshot.error);
            return Text(dataSnapshot.error);
          }

          if (dataSnapshot.connectionState != ConnectionState.done) {
            return circularProgress();
          }

          if (dataSnapshot.hasData) {
            if (!gotData) {
              dataSnapshot.data.docs.forEach((document) {
                EventModel event = EventModel.fromJson(document.data());
                eventModelsAll.add(event);
                eventModelsFiltered.add(event);
              });
              gotData = true;
            }

            return _buildEventList();
          }
          return TextButton(
              child: Text('bla'),
              onPressed: () => print(EventModel.dummy().toString()));
        });
  }
}
