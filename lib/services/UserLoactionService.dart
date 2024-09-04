import 'dart:async';
import 'package:beacon/models/UserLocationModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class UserLocationService {
  UserLocationModel? currentUserLocation;

  var location = Location();
  bool? active;
  String? userId;
  double? previousLat;
  double? previousLong;

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
    return currentUserLocation!;
  }

  var _userLocationController = StreamController<UserLocationModel>();

  Stream<UserLocationModel> get userLocationStream =>
      _userLocationController.stream;

  UserLocationService() {
    // Request permission to use location

    // _serviceEnabled = await location.serviceEnabled();
    // if (!_serviceEnabled) {
    //   _serviceEnabled = await location.requestService();
    //   if (!_serviceEnabled) {
    //     return;
    //   }
    // }
    location.requestPermission().then((PermissionStatus? granted) {
      if (granted != null) {
        if (granted == PermissionStatus.granted) {
          location.changeSettings(distanceFilter: 50);
          // If granted listen to the onLocationChanged stream and emit over our controller
          location.onLocationChanged.listen((LocationData? locationData) {
            if (locationData != null) {
              _userLocationController.add(
                UserLocationModel(
                  latitude: locationData.latitude,
                  longitude: locationData.longitude,
                ),
              );
              updateUserLocation(locationData);
            }
          });
        }
      }
    });
  }

  setActive(bool _enable) {
    active = _enable;
    location.enableBackgroundMode(enable: _enable);
  }

  updateUserLocation(LocationData? locationData) {
    if (userId != null && active == true) {
      FirebaseFirestore.instance.collection('liveBeacons').doc(userId).update({
        "lat": locationData!.latitude.toString(),
        "long": locationData.longitude.toString(),
        "lastUpdate": locationData.time!.toInt(),
      });
    }
  }
}
