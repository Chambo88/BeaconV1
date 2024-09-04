import 'package:beacon/models/EventModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/Dialogs/DateRangeDialog.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:beacon/widgets/tiles/EventTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventsTab extends StatefulWidget {
  final String? city;
  final Future<QuerySnapshot>? eventData;

  EventsTab({this.city, this.eventData});

  @override
  State<EventsTab> createState() => _EventsTabState();
}

enum filterStates { mutual, top }

class _EventsTabState extends State<EventsTab> {
  filterStates? filterBy;
  DateTime? filterStartDate;
  DateTime? filterEndDate;
  FigmaColours? figmaColours;
  List<EventModel>? eventModelsFiltered = [];
  List<EventModel>? eventModelsAll = [];
  Future<QuerySnapshot>? _eventData;
  bool gotData = false;

  @override
  void initState() {
    filterBy = filterStates.mutual;
    figmaColours = FigmaColours();
    _eventData = widget.eventData;

    super.initState();
  }

  Column _buildEventList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getChips(context),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              return EventTile(
                key: ObjectKey(i),
                event: eventModelsFiltered![i],
                mutualFriendCount:
                    eventModelsFiltered![i].mutualFriends!.length.toString(),
                figmaColours: figmaColours!,
              );
            },
            itemCount: eventModelsFiltered!.length,
          ),
        ),
      ],
    );
  }

  void filterList() {
    print('ok');
    List<EventModel> eventModelsTemp = [...eventModelsAll!];

    if (filterStartDate != null) {
      if (filterEndDate != null) {
        print('theyre hoth  nulol');
        eventModelsTemp = eventModelsTemp
            .where((event) => (event.startTime!.isAfter(filterStartDate!) &&
                event.startTime!.isBefore(filterEndDate!)))
            .toList();
      } else {
        print('start is not nul');
        eventModelsTemp = eventModelsTemp
            .where((event) => event.startTime!.day == filterStartDate!.day)
            .toList();
      }
    }
    if (filterBy == filterStates.mutual) {
      print('we mutul');
      eventModelsTemp.sort(
          (a, b) => b.mutualFriends!.length.compareTo(a.mutualFriends!.length));
    } else if (filterBy == filterStates.top) {
      eventModelsTemp.sort((a, b) =>
          b.usersAttending!.length.compareTo(a.usersAttending!.length));
    }
    eventModelsFiltered = eventModelsTemp;
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
                  color: (filterBy == filterStates.mutual)
                      ? Color(figmaColours!.highlight)
                      : Colors.white,
                ),
              ),
              label: Text(
                " Mutual ",
                style: TextStyle(
                    color: (filterBy == filterStates.mutual)
                        ? Color(figmaColours!.highlight)
                        : Colors.white),
              ),
              onPressed: () {
                setState(() {
                  filterBy = filterStates.mutual;
                  filterList();
                });
              },
              backgroundColor: Color(figmaColours!.greyDark),
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
                  color: (filterBy == filterStates.top)
                      ? Color(figmaColours!.highlight)
                      : Colors.white,
                ),
              ),
              label: Text(
                "Top ",
                style: TextStyle(
                    color: (filterBy == filterStates.top)
                        ? Color(figmaColours!.highlight)
                        : Colors.white),
              ),
              onPressed: () {
                setState(() {
                  filterBy = filterStates.top;
                  filterList();
                });
              },
              backgroundColor: Color(figmaColours!.greyDark),
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
                    ? Color(figmaColours!.highlight)
                    : Colors.white,
              ),
              label: Text(
                'Date    ',
                style: TextStyle(
                    color: (filterStartDate != null)
                        ? Color(figmaColours!.highlight)
                        : Colors.white),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return DateRangeDialog(
                      initStart: filterStartDate!,
                      initEnd: filterEndDate!,
                    );
                  },
                ).then((args) {
                  setState(() {
                    if (args != null) {
                      filterStartDate = args.startDate;
                      filterEndDate = args.endDate;
                    } else {
                      filterStartDate = null;
                      filterEndDate = null;
                    }
                    filterList();
                  });
                });
              },
              backgroundColor: Color(figmaColours!.greyDark),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserService userService = Provider.of<UserService>(context, listen: false);
    return FutureBuilder<QuerySnapshot>(
        future: _eventData,
        builder: (context, dataSnapshot) {
          if (dataSnapshot.hasError) {
            print(dataSnapshot.error);
            return Text(dataSnapshot.error.toString());
          }

          if (dataSnapshot.connectionState != ConnectionState.done) {
            return circularProgress();
          }

          if (dataSnapshot.hasData) {
            if (!gotData) {
              dataSnapshot.data!.docs.forEach((document) {
                final data = document.data();
                if (data is Map<String, dynamic>) {
                  EventModel event = EventModel.fromJson(data);
                  List<UserModel> mutuals =
                      userService.getMutual(event.usersAttending!);
                  event.mutualFriends = mutuals;
                  eventModelsAll!.add(event);
                  eventModelsFiltered!.add(event);
                  // Do something with the beacon
                } else {
                  // Handle the case where the data is not of the expected type
                  print('Unexpected data format: $data');
                }
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
