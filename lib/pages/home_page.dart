import 'package:beacon/components/beacon_selector.dart';
import 'package:beacon/models/beacon_model.dart';
import 'package:beacon/models/user_model.dart';
import 'package:beacon/pages/settings_page.dart';
import 'package:beacon/services/beacon_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'package:beacon/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:async/async.dart';




//////////////////////////////////////////////////////////
class Load_Home extends StatefulWidget {
  @override
  _Load_HomeState createState() => _Load_HomeState();
}

class _Load_HomeState extends State<Load_Home> {

  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;
  Future<String> myFuture;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final _currentUser = Provider.of<User>(context, listen: false);
    final _authService = Provider.of<AuthService>(context, listen: false);
    myFuture = _fetchData(_currentUser, _authService);
  }


  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: myFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {

          return HomePage();
        }
        else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        else {
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
      },
    );
  }

  Future<String> _fetchData(User _currentUser, AuthService _authService) async {
      var doc = await _fireStoreDataBase.collection('users').doc(
          _currentUser.uid).get();
      print('ok');
      _authService.addUserModelToController(doc);
      return "";
  }

}



class HomePage extends StatefulWidget {
  HomePage({Key key,}) : super(key: key);

  BuildContext previousContext;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override


  Widget build(BuildContext context) {
    //Why after calling this is it able to constantly be updated? DOes the stream builder recall it? how does this work
    var beaconList = BeaconService().getUserList();
    final AuthService _auth = context.watch<AuthService>();
    final UserModel _user = context.watch<UserModel>();


    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => settingsScreen()
              ));
            },
            icon:Icon(Icons.settings),
            color: Colors.white
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await _auth.signOut();
              },
              child: Text("Sign out"),
            )
          ],
        ),
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
