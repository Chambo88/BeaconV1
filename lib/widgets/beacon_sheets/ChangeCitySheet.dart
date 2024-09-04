import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../BeaconBottomSheet.dart';

class ChangeCitySheet extends StatelessWidget {
  ChangeCitySheet();
  FigmaColours figmaColours = FigmaColours();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    UserService userService = Provider.of<UserService>(context);
    return Container(
      height: MediaQuery.of(context).size.height,
      child: BeaconBottomSheet(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Stack(children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "See events in",
                      style: theme.textTheme.displayMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.close_rounded),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ]),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SingleChildScrollView(
                    ///Eventually replace this with listview builder and search
                    /// functionality to select a city
                    child: Column(
                      children: [
                        Divider(
                          color: Color(figmaColours.greyLight),
                          height: 1,
                        ),
                        ListTile(
                          title: Text("Christchurch",
                              style: theme.textTheme.displaySmall),
                          onTap: () {
                            userService.setCity("Christchurch");
                            Navigator.of(context).pop();
                          },
                        ),
                        Divider(
                          color: Color(figmaColours.greyLight),
                          height: 1,
                        ),
                        Container(
                          height: 200,
                        ),
                        Center(
                          child: Text(
                            "More coming soon!",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
