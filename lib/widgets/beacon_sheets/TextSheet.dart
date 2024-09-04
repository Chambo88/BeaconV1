import 'package:flutter/material.dart';

import '../BeaconBottomSheet.dart';

class TextSheet extends StatelessWidget {
  final String? title;
  final String? body;

  TextSheet({
    @required this.title,
    @required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                      title!,
                      style: theme.textTheme.displaySmall,
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
                    child: Text(
                      body!,
                      style: theme.textTheme.bodyLarge,
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
