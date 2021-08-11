import 'package:beacon/components/beacon_creator/pages/CasualBeaconEditOverview.dart';
import 'package:beacon/components/beacon_creator/pages/DescriptionPage.dart';
import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/BeaconService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/ProfilePicWidget.dart';
import 'package:beacon/widgets/beacon_sheets/ViewAttendiesSheet.dart';
import 'package:beacon/widgets/buttons/BeaconFlatButton.dart';
import 'package:beacon/widgets/tiles/BeaconCreatorSubTitle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum CasualBeaconEditStage {
  overview,
  whoCanSee,
  description,
  time,
  location,
  notifyNewUsers,
}


class CasualBeaconEdit extends StatefulWidget {
  CasualBeacon beacon;
  final VoidCallback onBack;
  final VoidCallback onClose;

  CasualBeaconEdit({
    @required this.beacon,
    @required this.onBack,
    @required this.onClose,
  });

  @override
  _CasualBeaconEditState createState() => _CasualBeaconEditState();
}

class _CasualBeaconEditState extends State<CasualBeaconEdit> {
  CasualBeacon beacon;
  FigmaColours figmaColours = FigmaColours();
  CasualBeaconEditStage _stage;
  BeaconService beaconService = BeaconService();

  @override
  void initState() {
    beacon = widget.beacon;
    _setStage(CasualBeaconEditStage.overview);
    super.initState();
  }

  void _setStage(CasualBeaconEditStage newStage) {
    setState(() {
      _stage = newStage;
    });
  }


  @override
  Widget build(BuildContext context) {
    UserModel currentUser = Provider.of<UserService>(context).currentUser;
    ThemeData theme = Theme.of(context);
    switch(_stage) {
      case CasualBeaconEditStage.overview:
        return CasualBeaconEditOverview(
          onBack: widget.onBack,
          beacon: beacon,
          setStage: _setStage,
        );
      case CasualBeaconEditStage.description:
        return DescriptionPage(
            onBackClick: () {
              setState(() {
                _stage = CasualBeaconEditStage.overview;
              });
            },
          hasTitleField: true,
            continueText: "Update",
            onClose: widget.onClose,
            onContinue: (title, desc) async {
              await beaconService.updateCasualTitleAndDesc(beacon, title, desc, currentUser);

            },
            totalPageCount: null,
            currentPageIndex: null,
          initTitle: beacon.eventName,
          initDesc: beacon.desc,
        );
      case CasualBeaconEditStage.whoCanSee:
        return Column(
          children: [Container(
            height: 30,
            color: Colors.red,
          )],
        );
      case CasualBeaconEditStage.notifyNewUsers:
        return Column(
          children: [Container(
            height: 30,
            color: Colors.red,
          )],
        );
      case CasualBeaconEditStage.location:
        return Column(
          children: [Container(
            height: 30,
            color: Colors.red,
          )],
        );
      case CasualBeaconEditStage.time:
        return Column(
          children: [Container(
            height: 30,
            color: Colors.red,
          )],
        );
    }
  }
}
