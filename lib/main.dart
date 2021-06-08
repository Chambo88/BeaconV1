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
              // basic colors
              backgroundColor: Colors.black,
              primaryColorLight: Color(0xFF2A2929),
              primaryColor: Color(0xFF181818),
              primaryColorDark: Color(0xFF000000),
              accentColor: Color(0xFFFF00CC),
              canvasColor: Colors.black,

              bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: Colors.black,
              ),

              switchTheme: SwitchThemeData(
                  trackColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return Color(0xFFB500E2);
                    }
                    return Color(0xFF323232);
                  }),
                  thumbColor: MaterialStateProperty.all(Colors.white)),

              // buttons
              buttonTheme: ButtonThemeData(
                disabledColor: Color(0xFF2A2929),
              ),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                  primary: Colors.purple,
                  backgroundColor: Colors.red,
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                  style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith((states) {
                  return (states.contains(MaterialState.disabled))
                      ? Color(0xFF716F6F)
                      : Color(0xFFFFFFFF);
                }),
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  return (states.contains(MaterialState.disabled))
                      ? Color(0xFF4B4B4B)
                      : Color(0xFFB928FF);
                }),
                textStyle: MaterialStateProperty.resolveWith((states) {
                  return (states.contains(MaterialState.disabled))
                      ? TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        )
                      : TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        );
                }),
              )),

              inputDecorationTheme: InputDecorationTheme(
                counterStyle: TextStyle(color: Colors.white),
                labelStyle: TextStyle(color: Color(0xFFC7C1C1), fontSize: 23),
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF6C6C6C),
                    width: 3,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFFFFFFF),
                    width: 3,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFFFFFFF),
                    width: 3,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF6200EE),
                    width: 3,
                  ),
                ),
              ),
              iconTheme: IconThemeData(
                color: Colors.grey,
              ),

              // text
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
                caption: TextStyle(
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
