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

// class loadingHomePage extends StatefulWidget {
//   @override
//   _loadingHomePageState createState() => _loadingHomePageState();
// }
//
// class _loadingHomePageState extends State<loadingHomePage> {
//   @override
//   Widget FutureBuilder(
//       future: Provider.of<UserModel>(context),
//       builder:
//       )
// }


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
                                    Type.active)
                                ? Colors.lightBlueAccent
                                : (snapshot.data[index].type == Type.hosting)
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
          new BeaconSelector()
        ]));
  }
}
