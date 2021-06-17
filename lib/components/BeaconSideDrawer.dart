import 'package:beacon/models/BeaconType.dart';
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
                      beacon: EventBeacon(
                          '1',
                          '2',
                          'Cam',
                          BeaconType.event.toString(),
                          true,
                          'Come get just drunk enough to forget your problems but not quite end up in ICU Come get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICU',
                          'A Night of beacon breathers'),
                    ),
                    _divider(context: context, text: "Casual"),
                    FriendCasualItem(
                      beacon: CasualBeacon(
                          '1',
                          '2',
                          'Cam',
                          BeaconType.event.toString(),
                          true,
                          'Come get just drunk enough to forget your problems but not quite end up in ICU Come get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICU',
                          true,
                          'A Night of beacon breathers'),
                    ),
                    _divider(context: context, text: "Live"),
                    FriendLiveItem(
                      beacon: LiveBeacon(
                        '1',
                        '2',
                        'Cam',
                        BeaconType.event.toString(),
                        true,
                        "123",
                        "123",
                        'Come get just drunk enough to forget your problems but not quite end up in ICU Come get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICU',
                      ),
                    ),
                    FriendLiveItem(
                        beacon: LiveBeacon(
                      '1',
                      '2',
                      'Cam',
                      BeaconType.event.toString(),
                      true,
                      "123",
                      "123",
                      'Come get just drunk enough to forget your problems but not quite end up in ICU Come get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICU',
                    )),
                    FriendLiveItem(
                        beacon: LiveBeacon(
                      '1',
                      '2',
                      'Cam',
                      BeaconType.event.toString(),
                      true,
                      "123",
                      "123",
                      'Come get just drunk enough to forget your problems but not quite end up in ICU Come get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICUCome get just drunk enough to forget your problems but not quite end up in ICU',
                    ))
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
