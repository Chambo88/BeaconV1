import 'package:beacon/pages/HomeLoadPage.dart';
import 'package:beacon/services/BeaconService.dart';
import 'package:beacon/services/LoactionService.dart';
import 'package:beacon/services/AuthService.dart';
import 'package:beacon/pages/SignInPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/BeaconModel.dart';
import 'models/UserModel.dart';
import 'pages/HomePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

Color getCheckboxColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return Colors.blue;
  }
  return Colors.red;
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
            theme: ThemeData(
              primaryColorLight: Color(0xFF2A2929),
              primaryColor: Color(0xFF181818),
              primaryColorDark: Color(0xFF000000),
              bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: Colors.black,

              ),
              accentColor: Color(0xFFFF00CC),
              backgroundColor: Colors.black,
              inputDecorationTheme: InputDecorationTheme(
                counterStyle: TextStyle(color: Colors.white),
                labelStyle: TextStyle(
                  color: Color(0xFFC7C1C1),
                ),

                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6200EE)),
                ),
              ),
              iconTheme: IconThemeData(
                color: Colors.grey,
              ),
              textTheme: TextTheme(
                headline1: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,

                ),
                headline2: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                ),
                headline3: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
                headline4: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
                headline5: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
                headline6: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),

                bodyText1: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
                bodyText2: TextStyle(
                  color: Color(0xFF7E7E90),
                  fontSize: 14.0,
                ),
                caption:  TextStyle(
                  color: Color(0xFF7E7E90),
                  fontSize: 12.0,
                ),

              ),

            ),
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
