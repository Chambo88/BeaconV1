import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/Dialogs/BeaconAlertyDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'SmallGreyButton.dart';
import 'SmallOutlinedButton.dart';

class SummonButton extends StatefulWidget {
  const SummonButton({
    Key? key,
    @required this.currentUser,
    @required this.friend,
    @required this.small,
  }) : super(key: key);

  final UserModel? currentUser;
  final UserModel? friend;
  final bool? small;

  @override
  State<SummonButton> createState() => _SummonButtonState();
}

class _SummonButtonState extends State<SummonButton> {
  bool summonable = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final _userService = Provider.of<UserService>(context);

    ///Can only summon people with an active live beacon
    if (widget.currentUser!.liveBeaconActive == false) {
      return Container();
    }

    ///spam protection - currently set at 1 hour before summonable again,
    ///stored likely which might be shit if people jsut close and reopen app but
    ///figure this is probably enough
    if (widget.currentUser!.recentlySummoned!.containsKey(widget.friend!.id)) {
      Duration dur = DateTime.now().difference(
          widget.currentUser!.recentlySummoned![widget.friend!.id!]!);
      if (dur.inHours <= 1) {
        summonable = false;
      }
    }
    if (summonable && widget.currentUser!.liveBeaconActive == true) {
      return SmallOutlinedButton(
        child: Text(
          "Summon",
          style: widget.small!
              ? theme.textTheme.headlineSmall
              : theme.textTheme.headlineMedium,
        ),
        width: widget.small! ? 97 : 150,
        height: widget.small! ? 28 : 35,
        onPressed: () {
          setState(() {
            widget.currentUser!.recentlySummoned![widget.friend!.id!] =
                DateTime.now();
            _userService.summonUser(widget.friend!);
          });
        },
      );
    } else {
      return SmallGreyButton(
        child: Text(
          "Summon",
          style: widget.small!
              ? theme.textTheme.headlineSmall
              : theme.textTheme.headlineMedium,
        ),
        width: widget.small! ? 97 : 150,
        height: widget.small! ? 28 : 35,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext) {
                return BeaconAlertDialog(
                  title: widget.currentUser!.liveBeaconActive!
                      ? "Recently Summoned"
                      : "Live beacon ",
                  bodyText: widget.currentUser!.liveBeaconActive!
                      ? "Please wait an hour after summoning someone to try again"
                      : "Light a Live beacon to summon people!",
                );
              });
        },
      );
    }
  }
}
