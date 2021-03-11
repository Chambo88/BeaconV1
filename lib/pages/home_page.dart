import 'package:beacon/components/beacon_selector.dart';
import 'package:beacon/models/beacon_model.dart';
import 'package:beacon/models/user_model.dart';
import 'package:beacon/services/beacon_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.user}) : super(key: key);

  UserModel user;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var beaconList = BeaconService().getUserList();

    return Scaffold(
        appBar: AppBar(
          actions: [
            ElevatedButton(
              onPressed: () {
                context.read<AuthService>().signOut();
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
          new BeaconSelector(user: widget.user)
        ]));
  }
}
