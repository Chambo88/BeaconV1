import 'dart:developer';
import 'package:beacon/library/ColorHelper.dart';
import 'package:beacon/widgets/buttons/OutlinedGradientButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BeaconSideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Drawer(
      child: DefaultTabController(
        initialIndex: 1,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
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
                    _friendEvent(
                      context: context,
                      title: 'A Night of beacon breathers',
                      hostedBy: 'SickCunt420',
                      description:
                          'Come get just drunk enough to forget your problems but not quite end up in ICU',
                      friendsGoing: ['Will', 'Chambo', 'Richie', 'Jelly'],
                    ),
                    _friendEvent(
                      context: context,
                      title: 'A Night of beacon breathers',
                      hostedBy: 'SickCunt420',
                      description:
                          'Come get just drunk enough to forget your problems but not quite end up in ICU',
                      friendsGoing: ['Will', 'Chambo', 'Richie', 'Jelly'],
                    ),
                    _friendEvent(
                      context: context,
                      title: 'A Night of beacon breathers',
                      hostedBy: 'SickCunt420',
                      description:
                          'Come get just drunk enough to forget your problems but not quite end up in ICU',
                      friendsGoing: ['Will', 'Chambo', 'Richie', 'Jelly'],
                    ),
                    _friendEvent(
                      context: context,
                      title: 'A Night of beacon breathers',
                      hostedBy: 'SickCunt420',
                      description:
                          'Come get just drunk enough to forget your problems but not quite end up in ICU',
                      friendsGoing: ['Will', 'Chambo', 'Richie', 'Jelly'],
                    ),
                    _divider(context: context, text: "Casual"),
                    _friendCasual(
                      context: context,
                      friend: 'Ben Chamberlain',
                      description: 'Sting like a butterfly, pimp like a bee',
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Text("Events"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _friendCasual(
      {BuildContext context, String friend, String description}) {
    final theme = Theme.of(context);
    return Container(
      height: 130,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 3, bottom: 3),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Icon(
              Icons.circle,
              size: 70,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 4),
                child: Text(
                  friend,
                  style: theme.textTheme.headline4,
                ),
              ),
              Container(
                width: 220,
                child: Text(
                  description,
                  // overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyText2,
                ),
              ),
              Container(
                width: 180,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 30,
                      width: 75,
                      child: OutlinedGradientButton(
                        strokeWidth: 2,
                        radius: 6,
                        gradient: ColorHelper.getBeaconGradient(),
                        child: Text(
                          'Going?',
                          style: theme.textTheme.headline5,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 75,
                      child: OutlinedGradientButton(
                        strokeWidth: 2,
                        radius: 6,
                        gradient: ColorHelper.getBeaconGradient(),
                        child: Text(
                          'Going?',
                          style: theme.textTheme.headline5,
                        ),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  List<Widget> _getFriendEvent({BuildContext context}) {}

  Widget _friendEvent({
    BuildContext context,
    String title,
    String hostedBy,
    String description,
    List<String> friendsGoing,
    DateTimeRange datetime,
  }) {
    final theme = Theme.of(context);
    return Container(
      height: 130,
      padding: const EdgeInsets.only(top: 3, bottom: 3),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              title,
              style: theme.textTheme.headline3,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Icon(
                  Icons.circle,
                  size: 50,
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Hosted by - ',
                            textAlign: TextAlign.left,
                            style: theme.textTheme.bodyText2,
                          ),
                          Text(
                            hostedBy,
                            style: theme.textTheme.headline5,
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 220,
                      child: Text(
                        description,
                        // overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyText2,
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
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
      ),
    );
  }
}
