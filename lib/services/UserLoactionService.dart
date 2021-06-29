import 'dart:async';

import 'package:beacon/models/UserLocationModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class UserLocationService {
  UserLocationModel currentUserLocation;

  var location = Location();

  Future<UserLocationModel> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      currentUserLocation = UserLocationModel(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }
    return currentUserLocation;
  }

  var _userLocationController = StreamController<UserLocationModel>();

  Stream<UserLocationModel> get userLocationStream => _userLocationController.stream;

  UserLocationService() {
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
