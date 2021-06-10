import 'package:beacon/components/BeaconInfoBottomSheet.dart';
import 'package:beacon/library/ColorHelper.dart';
import 'package:beacon/widgets/buttons/OutlinedGradientButton.dart';
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
                    // TODO put real data
                    for (var i = 0; i < 4; i++)
                      BeaconBar(
                        child: _friendEventBeaconContent(
                          context: context,
                          title: 'A Night of beacon breathers',
                          hostedBy: 'SickCunt420',
                          description:
                              'Come get just drunk enough to forget your problems but not quite end up in ICU',
                          friendsGoing: ['Will', 'Chambo', 'Richie', 'Jelly'],
                        ),
                      ),
                    _divider(context: context, text: "Casual"),
                    for (var i = 0; i < 3; i++)
                      BeaconBar(
                        child: _friendCasualBeaconContent(
                          context: context,
                          friend: 'Ben Chamberlain',
                          description:
                              'Sting like a butterfly, pimp like a bee',
                        ),
                      ),
                    _divider(context: context, text: "Live"),
                    for (var i = 0; i < 3; i++)
                      BeaconBar(
                        child: _friendLiveBeaconContent(
                          context: context,
                          friend: 'Ben Chamberlain',
                          description:
                              'Sting like a butterfly, pimp like a bee',
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

  Widget _friendCasualBeaconContent({
    BuildContext context,
    String friend,
    String description,
  }) {
    final theme = Theme.of(context);
    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
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
                  style: theme.textTheme.bodyText2,
                ),
              ),
              Container(
                width: 220,
                padding: const EdgeInsets.only(top: 10, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _smallOutLinedButton(
                      context: context,
                      title: 'Going?',
                      onPressed: () {},
                    ),
                    _smallOutLinedButton(
                      context: context,
                      title: 'Summon',
                      onPressed: () {},
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _friendLiveBeaconContent({
    BuildContext context,
    String friend,
    String description,
  }) {
    final theme = Theme.of(context);
    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
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
                  style: theme.textTheme.bodyText2,
                ),
              ),
              Container(
                width: 220,
                padding: const EdgeInsets.only(top: 10, bottom: 4, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _smallOutLinedButton(
                      context: context,
                      title: 'Summon',
                      onPressed: () {},
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _friendEventBeaconContent({
    BuildContext context,
    String title,
    String hostedBy,
    String description,
    List<String> friendsGoing,
    DateTimeRange datetime,
  }) {
    final theme = Theme.of(context);
    return Expanded(
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

  Widget _smallOutLinedButton({
    BuildContext context,
    String title,
    VoidCallback onPressed,
  }) {
    return Container(
      height: 25,
      width: 85,
      child: OutlinedGradientButton(
        strokeWidth: 1,
        radius: 6,
        gradient: ColorHelper.getBeaconGradient(),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline5,
        ),
        onPressed: onPressed,
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


class BeaconBar extends StatelessWidget {
  final Widget child;

  BeaconBar({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      padding: const EdgeInsets.only(top: 3, bottom: 3),
      child: InkWell(
          onTap: () {
            Navigator.pop(context);
            showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) {
                  return BeaconInfoBottomSheet(child: child);
                });
          },
          child: child),
    );
  }

}