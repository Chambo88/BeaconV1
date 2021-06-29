import 'dart:async';

import 'package:beacon/models/UserLocationModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class CameraLocationService {

  var _cameraLocationController = StreamController<CameraPosition>.broadcast();

  Stream<CameraPosition> get cameraLocationStream => _cameraLocationController.stream;

  setCameraPosition({@required CameraPosition cameraPosition}) {
    _cameraLocationController.add(cameraPosition);
  }
}
