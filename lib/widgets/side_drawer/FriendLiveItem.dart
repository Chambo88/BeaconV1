import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/widgets/BeaconBottomSheet.dart';
import 'package:beacon/widgets/buttons/SmallOutlinedButton.dart';
import 'package:flutter/material.dart';
import 'BecaonItem.dart';

class FriendLiveItem extends StatelessWidget {
  final BeaconModel beacon;

  FriendLiveItem({@required this.beacon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BeaconItem(
      height: 80,
      onTap: () {
        Navigator.pop(context);
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) {
            return Container(
              height: 300,
              child: BeaconBottomSheet(child: Container()),
            );
          },
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.circle,
            size: 50,
            color: Colors.white,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: Text(
                    beacon.userName,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Text(
                  beacon.desc,
                  style: Theme.of(context).textTheme.bodyText2,
                )
              ],
            ),
          ),
          Center(
            child: SmallOutlinedButton(
              title: 'Summon',
              onPressed: () {}, // TODO
            ),
          )
        ],
      )
    );
  }
}
