import 'package:beacon/models/UserLocationModel.dart';
import 'package:beacon/services/BeaconService.dart';
import 'package:beacon/services/CameraLocationService.dart';
import 'package:beacon/services/NotificationService.dart';
import 'package:beacon/services/UserLoactionService.dart';
import 'package:beacon/services/AuthService.dart';
import 'package:beacon/pages/SignInPage.dart';
import 'package:beacon/services/RemoteConfigService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'models/BeaconModel.dart';
import 'models/UserModel.dart';
import 'pages/HomePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().initialize();
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color(0xFF000000),
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
        Provider<RemoteConfigService>(
          create: (_) => RemoteConfigService(RemoteConfig.instance),
        ),
        Provider<UserService>(
          create: (_) => UserService(),
        ),
        Provider<BeaconService>(
          create: (_) => BeaconService(),
        ),
        Provider<UserLocationService>(
          create: (_) => UserLocationService(),
        ),
        StreamProvider<UserLocationModel>(
          create: (context) =>
              context.read<UserLocationService>().userLocationStream,
        ),
        Provider<CameraLocationService>(
          create: (_) => CameraLocationService(),
        ),
        StreamProvider<CameraPosition>(
          create: (context) =>
              context.read<CameraLocationService>().cameraLocationStream,
        ),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges,
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: CustomTheme.theme,
          home: AuthenticationWrapper()
          // MyHomePage(title: 'Beacon MVP'),
      ),
    );
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
        return FutureBuilder(
          future: context.read<UserService>().initUser(_currentUser.uid),
          builder: (context, snapshot) {
            while(!snapshot.hasData) {
              ///TODO return a loadingn screem akin to twitter on launch
              return Center(child: circularProgress(Theme.of(context).accentColor));
            }
            return BuildHomePage();
          },
        );
      }
    }
    return SignInPage();
  }
}
