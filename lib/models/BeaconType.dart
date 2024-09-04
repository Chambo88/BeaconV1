import 'package:flutter/material.dart';

enum BeaconType { live, casual, event }

extension BeaconTypeEx on BeaconType {
  String? get title {
    switch (this) {
      case BeaconType.live:
        return 'Live';
      case BeaconType.casual:
        return 'Host';
      case BeaconType.event:
        return 'Event';
      default:
        return null;
    }
  }

  String? get description {
    switch (this) {
      case BeaconType.live:
        return 'Let your friends know where you are and what you’re up to';
      case BeaconType.casual:
        return 'Welcome your friends come and join you at a location and time';
      case BeaconType.event:
        return 'Send invites to friends for an event at a location and time';
      default:
        return null;
    }
  }

  Color? get color {
    switch (this) {
      case BeaconType.live:
        return Color(0xFF00C365);
      case BeaconType.casual:
        return Color(0xFFFF6648);
      case BeaconType.event:
        return Color(0xFFFF00CC);
      default:
        return Colors.white;
    }
  }
}
