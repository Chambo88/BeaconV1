import 'package:beacon/pages/HomeLoadPage.dart';
import 'package:beacon/services/BeaconService.dart';
import 'package:beacon/services/LoactionService.dart';
import 'package:beacon/services/AuthService.dart';
import 'package:beacon/pages/SignInPage.dart';
import 'package:beacon/util/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'models/BeaconModel.dart';
import 'models/UserModel.dart';
import 'pages/HomePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthService>(
            create: (_) => AuthService(FirebaseAuth.instance),
          ),
          StreamProvider(create: (context) => LocationService().locationStream),
          StreamProvider(
            create: (context) => context.read<AuthService>().authStateChanges,
          ),
          StreamProvider(
            create: (context) => context.read<AuthService>().userChanges,
          ),
        ],
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: CustomTheme.theme,
            home: AuthenticationWrapper()
            // MyHomePage(title: 'Beacon MVP'),
            ));
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _currentUser = context.watch<User>();
    if (_currentUser != null) {
      {
        return HomeLoadPage();
      }
    }
    return SignInPage();
  }
}
