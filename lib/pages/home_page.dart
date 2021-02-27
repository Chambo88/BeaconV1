import 'package:beacon/components/beacon_selector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference users = FirebaseFirestore.instance.collection('beacons');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
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
              child: StreamBuilder<QuerySnapshot>(
            stream: users.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return new ListView(
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  return new ListTile(
                    tileColor: (document.data()['color'].toString() == "Orange")
                        ? Colors.orange
                        : Colors.green,
                    title: new Text(document.data()['userName']),
                    subtitle: new Text(document.data()['description'] +
                        "\n" +
                        document.data()['lat'].toString() +
                        " + " +
                        document.data()['long'].toString()),
                  );
                }).toList(),
              );
            },
          )),
          new BeaconSelector()
        ]));
  }
}
