import 'package:beacon/components/BeaconSelector.dart';
import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/UserLocationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/pages/SettingsPage.dart';
import 'package:beacon/services/BeaconService.dart';
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


class BuildHomePage extends StatefulWidget {
  @override
  _BuildHomePageState createState() => _BuildHomePageState();
}

class _BuildHomePageState extends State<BuildHomePage> {

  int _pageIndex = 0;
  final pages = [
    HomePage(),
    NotificationPage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    final userOnline = Provider.of<DocumentSnapshot>(context, listen: false);
  }


  bool isUserNull(UserModel userFromFireStore) {
    if(userFromFireStore == null) {
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

        icon: new Stack(
          children: <Widget>[
            new Icon(Icons.notifications),
            redCircleStuff(userFromFireStore),

          ],
        ),
      );
    }
    else {
      return BottomNavigationBarItem(
        icon: new Stack(
          children: <Widget>[
            new Icon(Icons.notifications),
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final userOnline = Provider.of<DocumentSnapshot>(context);
    UserModel userFromFireStore =  UserModel.fromDocument(userOnline);
    return Scaffold(
      body: pages[_pageIndex],
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _pageIndex,
        onTap: (index) {setState(() {
          _pageIndex = index;
        });},
        backgroundColor: Colors.black,
        activeColor: Colors.deepPurpleAccent,
        inactiveColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.local_fire_department_rounded)),
          notificationsIcon(userFromFireStore),
          BottomNavigationBarItem(icon: Icon(Icons.settings)),
        ],
      ),
    );
  }
}



class HomePage extends StatefulWidget {
  HomePage({Key key,}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override



  bool notEqualNull (UserModel user) {
    if (user == null) {
      return false;
    } else {
      return true;
    }
  }




  Widget build(BuildContext context) {
    //Why after calling this is it able to constantly be updated? DOes the stream builder recall it? how does this work
    var beaconList = BeaconService().getUserList();
    final AuthService _auth = context.watch<AuthService>();
    final UserModel _user = context.watch<UserModel>();

      return Scaffold(
          // appBar: AppBar(
          //   leading: IconButton(
          //       onPressed: () {
          //         Navigator.of(context).push(MaterialPageRoute(
          //             builder: (context) => SettingsPage()
          //         ));
          //       },
          //       icon: Icon(Icons.settings),
          //       color: Colors.white
          //   ),
          //   actions: [
          //     ElevatedButton(
          //       onPressed: () async {
          //         await _auth.signOut();
          //       },
          //       child: Text("Sign out"),
          //     ),
          //   ],
          // ),
          body: Stack(children: [

            Center(
                child: StreamBuilder(
                    stream: beaconList,
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }

                      return new ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new ListTile(
                              tileColor: (snapshot.data[index].type ==
                                  "active")
                                  ? Colors.lightBlueAccent
                                  : (snapshot.data[index].type == "hosting")
                                  ? Colors.lightGreenAccent
                                  : Colors.amberAccent,
                              title: new Text(snapshot.data[index].userName),
                              subtitle: new Text(snapshot.data[index].desc +
                                  "\n" +
                                  snapshot.data[index].lat +
                                  " + " +
                                  snapshot.data[index].long),
                            );
                          });
                    })),
            new BeaconSelector(user: _user)
          ]));
  }
}
