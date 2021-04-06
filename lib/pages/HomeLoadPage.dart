import 'package:beacon/models/UserLocationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/AuthService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'HomePage.dart';

//////////////////////////////////////////////////////////
class HomeLoadPage extends StatefulWidget {
  @override
  _HomeLoadPageState createState() => _HomeLoadPageState();
}

class _HomeLoadPageState extends State<HomeLoadPage> {

  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;
  Future<DocumentSnapshot> myFuture;


  @override
  void initState() {
    super.initState();
    final _currentUser = Provider.of<User>(context, listen: false);
    final _authService = Provider.of<AuthService>(context, listen: false);
    final _locationService = Provider.of<UserLocationModel>(context, listen: false);
    final _userModel = Provider.of<UserModel>(context, listen: false);
    myFuture = _fetchData(_currentUser, _authService);
  }


  @override
  Widget build(BuildContext context) {
    final _currentUser = Provider.of<User>(context);
    return FutureBuilder(
      future: myFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          //Creates the stream for the firebase user connection
          return StreamProvider<DocumentSnapshot>(
              create: (context) {
                return _fireStoreDataBase.collection('users').doc(_currentUser.uid).snapshots();

              },
              initialData: snapshot.data,
              builder: (BuildContext context, snapshot) {
                return BuildHomePage();
              });
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

  Future<DocumentSnapshot> _fetchData(User _currentUser, AuthService _authService) async {
    var doc = await _fireStoreDataBase.collection('users').doc(
        _currentUser.uid).get();
    _authService.addUserModelToController(doc);

    return doc;
  }

}
