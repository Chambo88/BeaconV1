import 'package:beacon/components/BeaconSelector.dart';
import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/UserLocationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/pages/MapPage.dart';
import 'package:beacon/pages/menu/MenuPage.dart';
import 'package:beacon/services/BeaconService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../services/AuthService.dart';
import 'package:beacon/services/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:async/async.dart';
import 'package:beacon/pages/NotificationPage.dart';

import 'Notifications/NotificationPageRedo.dart';

class BuildHomePage extends StatefulWidget {
  @override
  _BuildHomePageState createState() => _BuildHomePageState();
}

class _BuildHomePageState extends State<BuildHomePage> {
  int _pageIndex = 0;
  final pages = [
    MapPage(),
    NotificationPageRedo(),
    // NotificationPage(),
    MenuPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  bool isUserNull(UserModel userFromFireStore) {
    if (userFromFireStore == null) {
      return true;
    } else {
      return false;
    }
  }

  Widget redCircleStuff(UserModel userFromFireStore) {
    return Positioned(
      right: 0,
      child: new Container(
        padding: EdgeInsets.all(1),
        decoration: new BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        constraints: BoxConstraints(
          minWidth: 12,
          minHeight: 12,
        ),
        child: new Text(
          userFromFireStore.notificationCount.toString(),
          style: new TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  BottomNavigationBarItem notificationsIcon(UserModel userFromFireStore) {
    if (userFromFireStore.notificationCount != 0) {
      return BottomNavigationBarItem(
        label: 'notification',
        icon: new Stack(
          children: <Widget>[
            new Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            redCircleStuff(userFromFireStore),
          ],
        ),
        activeIcon: new Stack(
          children: <Widget>[
            new Icon(
              Icons.notifications,
              color: Colors.purple,
            ),
            redCircleStuff(userFromFireStore),
          ],
        ),
      );
    } else {
      return BottomNavigationBarItem(
        label: 'notification',
        icon: new Stack(
          children: <Widget>[
            new Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ],
        ),
        activeIcon: new Stack(
          children: <Widget>[
            new Icon(
              Icons.notifications,
              color: Colors.purple,
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // final userOnline = Provider.of<DocumentSnapshot>(context);
    final _currentUser = context.read<AuthService>().getUserId;

    var userFromFireStore =
        context.read<UserService>().initUser(_currentUser.uid);

    return FutureBuilder(
        future: userFromFireStore,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: pages[_pageIndex],
              bottomNavigationBar: BottomNavigationBar(
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
                      Icons.local_fire_department_rounded,
                      color: Colors.white,
                    ),
                    activeIcon: Icon(
                      Icons.local_fire_department_rounded,
                      color: Colors.purple,
                    ),
                  ),
                  notificationsIcon(snapshot.data),
                  BottomNavigationBarItem(
                    label: 'settings',
                    icon: Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    activeIcon: Icon(
                      Icons.menu,
                      color: Colors.purple,
                    ),
                  )
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                ],
              ),
            );
          }
        });
  }
}
