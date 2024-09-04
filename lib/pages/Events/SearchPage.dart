import 'package:beacon/models/EventModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/BeaconSearchBar.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:beacon/widgets/tiles/EventTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  final Future<QuerySnapshot>? eventData;

  SearchPage({this.eventData});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  List<EventModel> events = [];
  List<EventModel> filteredEvents = [];
  String searchText = "";
  final FigmaColours figmaColours = FigmaColours();
  bool gotData = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void onChanged(String searchQuery) {
    String query = "";
    String eventNameCleaned = "";
    Set<EventModel> newResults = {};
    if (searchQuery.isNotEmpty) {
      query = searchQuery.replaceAll(" ", "").toLowerCase();
      events.forEach((event) {
        //event name check
        eventNameCleaned = event.eventName!.toLowerCase().replaceAll(" ", "");
        if (eventNameCleaned.contains(query)) {
          newResults.add(event);
        } else if (event.locationName! // location check
            .toLowerCase()
            .replaceAll(" ", "")
            .contains(query)) {
          newResults.add(event);
        } else {
          //genre check
          event.genres!.forEach((element) {
            if (element.toLowerCase().contains(query)) {
              newResults.add(event);
            }
          });
        }
      });
      setState(() {
        filteredEvents = List.from(newResults);
      });
    } else {
      setState(() {
        filteredEvents.clear();
      });
    }
  }

  Widget getLoadedWidgets() {
    UserService userService = Provider.of<UserService>(context, listen: false);
    return Container(
        child: SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: [
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                String mutualFriendCount = userService
                    .getMutual(filteredEvents[index].usersAttending!)
                    .length
                    .toString();
                return EventTile(
                  key: ObjectKey(index),
                  mutualFriendCount: mutualFriendCount,
                  figmaColours: figmaColours,
                  event: filteredEvents[index],
                );
              }),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: BeaconSearchBar(
            controller: searchController,
            onChanged: onChanged,
            hintText: "Name, genre, place.. ",
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: widget.eventData,
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
                    events.add(event);
                  } else {
                    // Handle the case where the data is not of the expected type.
                    throw Exception('Unexpected data format');
                  }
                });
                gotData = true;
              }

              return getLoadedWidgets();
            }
            return Text("No Events found");
          },
        ));
  }
}
