import 'package:beacon/models/BeaconType.dart';
import 'package:beacon/services/BeaconService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/beacon_sheets/LiveBeaconSheet.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:beacon/widgets/side_drawer/FriendCasualItem.dart';
import 'package:beacon/widgets/side_drawer/FriendEventItem.dart';
import 'package:beacon/widgets/side_drawer/FriendLiveItem.dart';
import 'package:beacon/models/BeaconModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class BeaconSideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userService = Provider.of<UserService>(context);
    final beaconService = Provider.of<BeaconService>(context);
    beaconService.loadAllBeacons(userService.currentUser.id);

    return Drawer(
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 60,
            automaticallyImplyLeading: false,
            bottom: TabBar(
              labelColor: theme.accentColor,
              unselectedLabelColor: Colors.white,
              labelStyle: theme.textTheme.headline3,
              tabs: [
                Tab(
                  text: 'Friends',
                ),
                Tab(
                  text: 'Live Events',
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
                    Text("Place holder for Friend Event Beacons...."),
                    _divider(context: context, text: "Casual"),
                    Text("Place holder for Friend Casual Beacons...."),
                    _divider(context: context, text: "Live"),
                    StreamBuilder<List<LiveBeacon>>(
                      stream: beaconService.allLiveBeacons,
                      builder: (context, snapshot) {
                        while (!snapshot.hasData) {
                          return circularProgress();
                        }
                        List<FriendLiveItem> beacons = [];
                        snapshot.data.forEach((LiveBeacon beacon) {
                          beacons.add(FriendLiveItem(
                            beacon: beacon
                          ));
                        });
                        return Column(
                          children: beacons,
                        );
                      }
                    ),
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
