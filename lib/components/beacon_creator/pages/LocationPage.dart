import 'dart:io';

import 'package:beacon/models/LocationModel.dart';
import 'package:beacon/models/UserLocationModel.dart';
import 'package:beacon/widgets/beacon_sheets/LocationSelectorSheet.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_place/google_place.dart' as GooglePlace;
import 'package:provider/provider.dart';
import 'CreatorPage.dart';

typedef void LocationCallback(GooglePlace.AutocompletePrediction location);

class LocationPage extends StatefulWidget {
  final VoidCallback onBackClick;
  final VoidCallback onClose;
  final LocationCallback onContinue;
  final String continueText;
  final int totalPageCount;
  final int currentPageIndex;
  final LocationModel initLocation;

  LocationPage({
    @required this.onBackClick,
    @required this.onClose,
    @required this.onContinue,
    @required this.totalPageCount,
    @required this.currentPageIndex,
    this.continueText = 'Next',
    this.initLocation,
  });

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  GooglePlace.AutocompletePrediction _selectedPlace;
  List<Location> locations = [];
  UserLocationModel _userLocation;
  LocationModel _selectedLocation;

  @override
  void initState() {
    super.initState();
    if (widget.initLocation != null) {
      _selectedLocation = widget.initLocation;
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    _userLocation = Provider.of<UserLocationModel>(context);
    // _configService = Provider.of<RemoteConfigService>(context);
    var theme = Theme.of(context);

    // String apiKey;
    // if (Platform.isAndroid) {
    //   apiKey = _configService.remoteConfig.getString('androidGoogleMapsKey');
    // } else if (Platform.isIOS) {
    //   apiKey = _configService.remoteConfig.getString('iOSGoogleMapsKey');
    // }

    return CreatorPage(
      title: 'Place',
      onClose: widget.onClose,
      onBackClick: widget.onBackClick,
      continueText: widget.continueText,
      totalPageCount: widget.totalPageCount,
      currentPageIndex: widget.currentPageIndex,
      onContinuePressed: () {
        if (_selectedPlace == null) widget.onContinue(_selectedPlace);
      },
      child: _userLocation != null
          ? Column(
              children: [
                InkWell(
                  child: _selectedLocation != null
                      ? ListTile(
                          leading: Icon(
                            Icons.location_on,
                            color: Colors.grey,
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                '${_selectedLocation.name} ',
                                style: theme.textTheme.headline5,
                              ),
                              Text('${_selectedLocation.street}'),
                            ],
                          ),
                        )
                      : FutureBuilder<List<Placemark>>(
                          future: placemarkFromCoordinates(
                            _userLocation.latitude,
                            _userLocation.longitude,
                          ),
                          builder: (context, snapshot) {
                            while (!snapshot.hasData) {
                              return circularProgress();
                            }
                            LocationModel newLocation = LocationModel(
                              lat: _userLocation.latitude,
                              long: _userLocation.longitude,
                              name: snapshot.data[0].name,
                              street: snapshot.data[0].street,
                            );
                            print(snapshot.data[0].administrativeArea);
                            print(snapshot.data[0].country);
                            print(snapshot.data[0].subAdministrativeArea);
                            print(snapshot.data[0].name);
                            _selectedLocation = newLocation;
                            return ListTile(
                              leading: Icon(
                                Icons.location_on,
                                color: Colors.grey,
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Current Location',
                                    style: theme.textTheme.headline5,
                                  ),
                                  Text(
                                    '${snapshot.data[0].street}',
                                  ),
                                ],
                              ),
                            );
                          }),
                  onTap: () {
                    setState(() {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (context) {
                          return LocationSelectorSheet(
                            onSelected: (location) async {
                              locations = await locationFromAddress(
                                  location.description);
                              List<Placemark> placeMark =
                                  await placemarkFromCoordinates(
                                locations[0].latitude,
                                locations[0].longitude,
                              );
                              LocationModel newLocation = LocationModel(
                                lat: locations[0].latitude,
                                long: locations[0].longitude,
                                fullAdress: location.description,
                                name: isNumeric(location.terms[0].value)
                                    ? location.terms[1].value
                                    : location.terms[0].value,
                                street: placeMark[0].street,
                              );
                              _selectedLocation = newLocation;
                              setState(() {});
                            },
                          );
                        },
                      );
                    });
                  },
                ),
              ],
            )
          : circularProgress(),
    );
  }
}
