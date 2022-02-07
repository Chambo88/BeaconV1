import 'package:beacon/pages/Events/EventsPage.dart';
import 'package:beacon/pages/MapPage.dart';
import 'package:beacon/pages/menu/MenuPage.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/NotificationIcon.dart';
import 'package:flutter/material.dart';

import 'Notifications/NotificationPage.dart';

class BuildHomePage extends StatefulWidget {
  @override
  _BuildHomePageState createState() => _BuildHomePageState();
}

class _BuildHomePageState extends State<BuildHomePage> {
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      MapPage(),
      EventsPage(context),
      NotificationPage(),
      MenuPage(),
    ];
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: pages[_pageIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _pageIndex,
          onTap: (index) {
            setState(() {
              _pageIndex = index;
            });
          },
          backgroundColor: Colors.black,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              label: 'beacon',
              icon: Icon(
                Icons.local_fire_department_outlined,
                color: Colors.white,
              ),
              activeIcon: Icon(
                Icons.local_fire_department_rounded,
                color: Color(FigmaColours().highlight),
              ),
            ),
            BottomNavigationBarItem(
              label: 'events',
              icon: Icon(
                Icons.event_outlined,
                color: Colors.white,
              ),
              activeIcon: Icon(
                Icons.event_rounded,
                color: Color(FigmaColours().highlight),
              ),
            ),
            BottomNavigationBarItem(
                label: 'notification',
                icon: NotificationIcon(active: false),
                activeIcon: NotificationIcon(active: true)),
            BottomNavigationBarItem(
              label: 'settings',
              icon: Icon(
                Icons.menu_outlined,
                color: Colors.white,
              ),
              activeIcon: Icon(
                Icons.menu,
                color: Color(FigmaColours().highlight),
              ),
            )
          ],
        ),
      ),
    );
  }
}
