import 'dart:io';

import 'package:beacon/library/ColorHelper.dart';
import 'package:beacon/services/RemoteConfigService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/BeaconBottomSheet.dart';
import 'package:beacon/widgets/buttons/GradientButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_place/google_place.dart';
import 'package:provider/provider.dart';

import '../SearchBar.dart';

typedef LocationSelectedCallback(AutocompletePrediction prediction);

class LocationSelectorSheet extends StatefulWidget {
  LocationSelectedCallback onSelected;

  LocationSelectorSheet({
    Key key,
    this.onSelected,
  }) : super(key: key);

  @override
  _LocationSelectorSheetState createState() => _LocationSelectorSheetState();
}

class _LocationSelectorSheetState extends State<LocationSelectorSheet> {
  TextEditingController _searchController;
  final FocusNode _focusNode = FocusNode();
  RemoteConfigService _configService;
  GooglePlace _googlePlace;
  List<AutocompletePrediction> _predictions = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void autoCompleteSearch(String value) async {
    var result = await _googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        _predictions = result.predictions;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _configService = Provider.of<RemoteConfigService>(context);

    if (_googlePlace == null) {
      String apiKey;
      if (Platform.isAndroid) {
        apiKey = _configService.remoteConfig.getString('androidGoogleMapsKey');
      } else if (Platform.isIOS) {
        apiKey = _configService.remoteConfig.getString('iOSGoogleMapsKey');
      }
      _googlePlace = GooglePlace(apiKey);
    }

    // Pop up Friend selector
    return BeaconBottomSheet(
      child: Column(
        children: [
          ListTile(
            leading: CloseButton(
              color: Color(0xFF666666),
            ),
            title: Text('Location',
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headline4),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Smash Palace',
              onChanged: (value) {
                if (value.isNotEmpty) {
                  autoCompleteSearch(value);
                } else {
                  if (_predictions.length > 0 && mounted) {
                    setState(() {
                      _predictions = [];
                    });
                  }
                }
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _predictions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      Icons.pin_drop,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(_predictions[index].description),
                  onTap: () {
                    widget.onSelected(_predictions[index]);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
