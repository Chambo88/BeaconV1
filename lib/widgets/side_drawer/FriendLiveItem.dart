import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/CameraLocationService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/beacon_sheets/LiveBeaconSheet.dart';
import 'package:beacon/widgets/buttons/SummonButton.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../ProfilePicWidget.dart';
import 'BeaconItem.dart';

class FriendLiveItem extends StatelessWidget {
  final LiveBeacon? beacon;
  final figmaColours = FigmaColours();

  FriendLiveItem({@required this.beacon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locationService = Provider.of<CameraLocationService>(context);
    final userService = Provider.of<UserService>(context);

    UserModel user = userService.getAFriendModelFromId(beacon!.userId!);

    if (beacon!.userId == userService.currentUser!.id) {
      return Container();
    }

    return BeaconItem(
      height: 125,
      onTap: () {
        locationService.setCameraPosition(
          cameraPosition: CameraPosition(
            zoom: 12,
            target: LatLng(
              beacon!.lat!,
              beacon!.long!,
            ),
          ),
        );
        Navigator.pop(context);
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) {
            return LiveBeaconSheet(
              beacon: beacon!,
            );
          },
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ProfilePicture(user: user, size: 24),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "${user.firstName} ${user.lastName}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.headlineMedium,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            beacon!.desc!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: SummonButton(
                                currentUser: userService.currentUser,
                                friend: user,
                                small: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: Color(figmaColours.greyMedium),
          )
        ],
      ),
    );
  }
}
