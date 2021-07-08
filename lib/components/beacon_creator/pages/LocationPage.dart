import 'dart:io';

import 'package:beacon/models/UserLocationModel.dart';
import 'package:beacon/services/UserLoactionService.dart';
import 'package:beacon/services/RemoteConfigService.dart';
import 'package:beacon/widgets/beacon_sheets/LocationSelectorSheet.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_place/google_place.dart';
import 'package:provider/provider.dart';
import 'CreatorPage.dart';

typedef void LocationCallback(AutocompletePrediction location);

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
  AutocompletePrediction _selectedPlace;
  UserLocationModel _userLocation;
  RemoteConfigService _configService;

  @override
  Widget build(BuildContext context) {
    _userLocation = Provider.of<UserLocationModel>(context);
    _configService = Provider.of<RemoteConfigService>(context);
    var theme = Theme.of(context);

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
      child: _userLocation != null
          ? Column(
              children: [
                InkWell(
                  child: _selectedPlace != null
                      ? ListTile(
                          leading: Icon(
                            Icons.location_on,
                            color: Colors.grey,
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                '${_selectedPlace.terms[0].value} ${_selectedPlace.terms[1].value}',
                                style: theme.textTheme.headline5,
                              ),
                              Text('${_selectedPlace.description}'),
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
                              return circularProgress(Theme.of(context).accentColor);
                            }
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
                                    '${snapshot.data[0].street}, ${snapshot.data[0].subAdministrativeArea}',
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
                            onSelected: (location) {
                              _selectedPlace = location;
                            },
                          );
                        },
                      );
                    });
                  },
                ),
              ],
            )
          : circularProgress(Theme.of(context).accentColor),
    );
  }
}
