import 'package:beacon/models/UserModel.dart';
import 'package:beacon/pages/Events/EventsTab.dart';
import 'package:beacon/pages/Events/FriendsTab.dart';
import 'package:beacon/pages/Events/GoingTab.dart';
import 'package:beacon/pages/Events/SearchPage.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/beacon_sheets/ChangeCitySheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beacon/util/theme.dart';

class EventsPage extends StatefulWidget {
  const EventsPage(this.context);
  final BuildContext context;
  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  FigmaColours _figmaColours;
  int currentIndex;
  Future<QuerySnapshot> eventData;

  @override
  void initState() {
    _figmaColours = FigmaColours();
    currentIndex = 0;
    String city = widget.context.read<UserService>().currentUser.city;
    eventData = getData(city);
    super.initState();
  }

  Future<QuerySnapshot> getData(String city) {
    return FirebaseFirestore.instance
        .collection('eventBeacons')
        .where('city', isEqualTo: city)
        .get();
  }

  Widget getTitle(UserModel currentUser) {
    if (currentIndex == 0) {
      return Row(
        children: [
          TextButton(
            style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 4),
                minimumSize: Size(50, 30),
                alignment: Alignment.centerLeft),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              text: TextSpan(
                  text: (currentUser.city == '')
                      ? "Select a city"
                      : "What's on in - ",
                  style: Theme.of(context).textTheme.headline2,
                  children: [
                    TextSpan(
                      text: currentUser.city,
                      style: TextStyle(
                        color: Color(_figmaColours.highlight),
                      ),
                    ),
                  ]),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) {
                  return ChangeCitySheet();
                },
              ).then((value) => setState(() {}));
            },
          ),
          IconButton(
              padding: EdgeInsets.all(4),
              constraints: BoxConstraints(),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) {
                    return ChangeCitySheet();
                  },
                ).then((value) => setState(() {}));
              },
              icon: Icon(Icons.arrow_drop_down))
        ],
      );
    } else if (currentIndex == 1) {
      return Text("Friends beacons");
    } else {
      return Text("I'm Going to");
    }
  }

  @override
  Widget build(BuildContext context) {
    UserService _userService = Provider.of<UserService>(context);
    UserModel currentUser = _userService.currentUser;
    ThemeData theme = Theme.of(context);
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: getTitle(currentUser),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 3, top: 5),
              child: Ink(
                decoration: ShapeDecoration(
                  color: Color(_figmaColours.greyDark),
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: const Icon(Icons.search),
                  color: Color(_figmaColours.highlight),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            SearchPage(eventData: eventData)));
                  },
                ),
              ),
            ),
          ],
          bottom: TabBar(
            labelColor: theme.accentColor,
            unselectedLabelColor: Colors.white,
            labelStyle: theme.textTheme.headline3,
            onTap: (index) {
              currentIndex = index;
              setState(() {});
            },
            tabs: [
              Tab(
                text: 'Events',
              ),
              Tab(
                text: 'Friends',
              ),
              Tab(
                text: 'Going',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            EventsTab(
              city: currentUser.city,
              eventData: eventData,
            ),
            FriendsTab(),
            GoingTab(),
          ],
        ),
      ),
    );
  }
}
