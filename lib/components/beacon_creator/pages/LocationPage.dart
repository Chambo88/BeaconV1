import 'dart:io';

import 'package:beacon/models/UserLocationModel.dart';
import 'package:beacon/services/UserLoactionService.dart';
import 'package:beacon/services/RemoteConfigService.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
import 'CreatorPage.dart';

typedef void LocationCallback(PickResult location);

class LocationPage extends StatefulWidget {
  final VoidCallback onBackClick;
  final VoidCallback onClose;
  final LocationCallback onContinue;
  final String continueText;
  final int totalPageCount;
  final int currentPageIndex;

  LocationPage({
    @required this.onBackClick,
    @required this.onClose,
    @required this.onContinue,
    @required this.totalPageCount,
    @required this.currentPageIndex,
    this.continueText = 'Next',
  });

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  PickResult _selectedPlace;
  UserLocationModel _userLocation;
  RemoteConfigService _configService;

  @override
  Widget build(BuildContext context) {
    _userLocation = Provider.of<UserLocationModel>(context);
    _configService = Provider.of<RemoteConfigService>(context);

    String apiKey;
    if (Platform.isAndroid) {
      apiKey = _configService.remoteConfig.getString('androidGoogleMapsKey');
    } else if (Platform.isIOS) {
      apiKey = _configService.remoteConfig.getString('iOSGoogleMapsKey');
    }

    return CreatorPage(
      title: 'Place',
      onClose: widget.onClose,
      onBackClick: widget.onBackClick,
      continueText: widget.continueText,
      totalPageCount: widget.totalPageCount,
      currentPageIndex: widget.currentPageIndex,
      onContinuePressed: () {
        widget.onContinue(_selectedPlace);
      },
      child: Column(
        children: [
          InkWell(
            child: _selectedPlace != null
                ? ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: Colors.grey,
                    ),
                    title: Text(_selectedPlace.formattedAddress),
                  )
                : ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: Colors.grey,
                    ),
                    title: Text('Current Location'),
                  ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Theme(
                      data: ThemeData(
                        // Define the default brightness and colors.
                        brightness: Brightness.dark,
                        primaryColor: Colors.lightBlue[800],
                        accentColor: Colors.cyan[600],
                        textTheme: TextTheme(
                          headline1: TextStyle(
                            fontSize: 72.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          headline6: TextStyle(
                            fontSize: 36.0,
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                          ),
                          bodyText2: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontFamily: 'Hind',
                          ),
                        ),
                      ),
                      child: PlacePicker(
                        apiKey: apiKey,
                        initialPosition: LatLng(
                          _userLocation.latitude,
                          _userLocation.longitude,
                        ),
                        useCurrentLocation: true,
                        selectInitialPosition: true,
                        onPlacePicked: (result) {
                          _selectedPlace = result;
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
