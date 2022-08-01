import 'package:beacon/services/BeaconService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:beacon/widgets/side_drawer/FriendCasualItem.dart';
import 'package:beacon/widgets/side_drawer/FriendLiveItem.dart';
import 'package:beacon/models/BeaconModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class BeaconSideDrawer extends StatelessWidget {
  FigmaColours figmaColours = FigmaColours();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userService = Provider.of<UserService>(context);
    final beaconService = Provider.of<BeaconService>(context);
    beaconService.loadAllBeacons(userService.currentUser.id);

    return Container(
      width: MediaQuery.of(context).size.width * 0.825,
      child: Drawer(
        child: DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: Scaffold(
            appBar: TabBar(
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
            body: TabBarView(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _divider(context: context, text: "Venue"),
                      StreamBuilder<List<CasualBeacon>>(
                          stream: beaconService.allCasualBeacons,
                          builder: (context, snapshot) {
                            while (!snapshot.hasData) {
                              return circularProgress();
                            }
                            List<Widget> beacons = [];
                            snapshot.data.forEach((CasualBeacon beacon) {
                              if(beacon.endTime.isAfter(DateTime.now())) {
                                beacons.add(FriendCasualItem(
                                    beacon: beacon
                                ));
                                beacons.add(
                                    Divider(
                                      color: Color(figmaColours.greyMedium),
                                      height: 1,
                                    )
                                );
                              }
                            });
                            return Column(
                              children: beacons,
                            );
                          }
                      ),
                      _divider(context: context, text: "Live"),
                      StreamBuilder<List<LiveBeacon>>(
                        stream: beaconService.allLiveBeacons,
                        builder: (context, snapshot) {
                          while (!snapshot.hasData) {
                            return circularProgress();
                          }
                          List<Widget> beacons = [];
                          snapshot.data.forEach((LiveBeacon beacon) {
                            beacons.add(FriendLiveItem(
                              beacon: beacon
                            ));
                            beacons.add(
                                Divider(
                              color: Color(figmaColours.greyMedium),
                              height: 1,
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
      ),
    );
  }


  Widget _divider({BuildContext context, String text}) {
    return Container(
      height: 30,
      width: double.infinity,
      color: Theme.of(context).primaryColor,
      alignment: Alignment.center,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
