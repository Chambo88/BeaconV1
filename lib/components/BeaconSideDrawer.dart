import 'package:beacon/widgets/side_drawer/FriendCasualItem.dart';
import 'package:beacon/widgets/side_drawer/FriendEventItem.dart';
import 'package:beacon/widgets/side_drawer/FriendLiveItem.dart';
import 'package:beacon/models/BeaconModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BeaconSideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      child: DefaultTabController(
        initialIndex: 1,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 60,
            automaticallyImplyLeading: false,
            bottom: TabBar(
              labelColor: theme.accentColor,
              unselectedLabelColor: Colors.white,
              tabs: [
                Tab(
                  text: 'Friends',
                ),
                Tab(
                  text: 'Events',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    _divider(context: context, text: "Friends Events"),
                    FriendEventItem(
                      beacon: BeaconModel(
                        '1',
                        '2',
                        'Come get just drunk enough to forget your problems but not quite end up in ICU Come get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICU',
                        'Event',
                        true,
                        userName: 'Cam',
                        id: 'A Night of beacon breathers',
                      ),
                    ),
                    _divider(context: context, text: "Casual"),
                    FriendCasualItem(
                      beacon: BeaconModel(
                        '1',
                        '2',
                        'Come get just drunk enough to forget your problems but not quite end up in ICU Come get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICU',
                        'Event',
                        true,
                        userName: 'Cam',
                        id: 'Town Pres',
                      ),
                    ),
                    _divider(context: context, text: "Live"),
                    FriendLiveItem(
                      beacon: BeaconModel(
                        '1',
                        '2',
                        'Fdsfdsfdsfsdfsdfsdffsddfdfsdfdfsdfsdfsdfsdfs',
                        'Live',
                        true,
                        userName: 'Cam',
                        id: 'Town Pres',
                      ),
                    ),
                    FriendLiveItem(
                      beacon: BeaconModel(
                        '1',
                        '2',
                        'Fdsfdsfdsfsdfsdfsdffsddfdfsdfdfsdfsdfsdfsdfs',
                        'Live',
                        true,
                        userName: 'Cam',
                        id: 'Town Pres',
                      ),
                    ),
                    FriendLiveItem(
                      beacon: BeaconModel(
                        '1',
                        '2',
                        'Fdsfdsfdsfsdfsdfsdffsddfdfsdfdfsdfsdfsdfsdfs',
                        'Live',
                        true,
                        userName: 'Cam',
                        id: 'Town Pres',
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Text("Events Placeholder.."),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getFriendEvent({BuildContext context}) {}

  Widget _divider({BuildContext context, String text}) {
    return Container(
      height: 30,
      width: double.infinity,
      color: Theme.of(context).primaryColor,
      alignment: Alignment.center,
      child: Text(
        text,
      ),
    );
  }
}
