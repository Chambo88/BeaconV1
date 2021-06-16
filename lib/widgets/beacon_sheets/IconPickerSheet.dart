import 'package:beacon/Assests/Icons.dart';
import 'package:flutter/material.dart';

import '../BeaconBottomSheet.dart';

typedef void iconSelected(IconData icon);

class IconPickerSheet extends StatelessWidget {
  final iconSelected onSelected;

  IconPickerSheet({@required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 400,
      child: BeaconBottomSheet(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                leading: CloseButton(
                  color: Colors.white,
                ),
                title: Text('Icons',
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headline4),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 4,
                      childAspectRatio: 1.0,
                      padding: const EdgeInsets.all(4.0),
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      children: BeaconIcons.iconDataList.map((e) {
                        return InkWell(
                            onTap: () {
                              onSelected(e);
                              Navigator.pop(context);
                            },
                            child: Icon(e));
                      }).toList())),
            ],
          ),
        ),
      ),
    );
  }
}