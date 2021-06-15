import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/UserLocationModel.dart';
import 'package:beacon/services/BeaconService.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapComponent extends StatefulWidget {
  MapComponent({Key key, this.userLocation}) : super(key: key);
  UserLocationModel userLocation;

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MapComponent> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  _updateMarkers(List<BeaconModel> beaconList) {
    BitmapDescriptor beaconIcon;
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(12, 12)), 'assets/active_marker.png')
        .then((onValue) {
      beaconList.forEach((beacon) {
        beaconIcon = onValue;

        final Marker marker = Marker(
            markerId: MarkerId(beacon.id),
            position:
                LatLng(double.parse(beacon.lat), double.parse(beacon.long)),
            icon: beaconIcon);

        setState(() {
          // adding a new marker to map
          markers[MarkerId(beacon.id)] = marker;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();

    var beaconList = BeaconService().getUserList();
    beaconList.listen(_updateMarkers);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: widget.userLocation == null
            ? Container()
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(widget.userLocation.latitude,
                        widget.userLocation.longitude),
                    zoom: 12.0),
                zoomControlsEnabled: false,
                markers: Set<Marker>.of(markers.values),
              ));
  }
}
