import 'dart:async';

import 'package:beacon/models/UserLocationModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationService {
  UserLocationModel currentLocation;

  var location = Location();

  Future<UserLocationModel> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      currentLocation = UserLocationModel(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }
    return currentLocation;
  }

  var _userLocationController = StreamController<UserLocationModel>.broadcast();

  var _cameraLocationController = StreamController<CameraPosition>.broadcast();

  Stream<UserLocationModel> get userLocationStream => _userLocationController.stream;
  Stream<CameraPosition> get cameraLocationStream => _cameraLocationController.stream;

  setCameraPosition({@required CameraPosition cameraPosition}) {
    _cameraLocationController.add(cameraPosition);
  }

  LocationService() {
    // Request permission to use location
    location.requestPermission().then((granted) {
      if (granted != null) {
        // If granted listen to the onLocationChanged stream and emit over our controller
        location.onLocationChanged.listen((locationData) {
          if (locationData != null) {
            _userLocationController.add(
              UserLocationModel(
                latitude: locationData.latitude,
                longitude: locationData.longitude,
              ),
            );

          }
        });
      }
    });
  }
}
