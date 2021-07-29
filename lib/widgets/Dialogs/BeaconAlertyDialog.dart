import 'package:beacon/library/ColorHelper.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/buttons/GradientButton.dart';
import 'package:flutter/material.dart';

class BeaconAlertDialog extends StatelessWidget {
  BeaconAlertDialog(
      {@required this.bodyText,
        this.title,
      });

  final String bodyText;
  final String title;
  FigmaColours figmaColours = FigmaColours();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Color(figmaColours.greyDark),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        height: 160,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (title == null)? Container() : Center(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  bodyText,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              Spacer(
                flex: 1,
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8 - 32,
                    child: GradientButton(
                        child: Text('close',
                            style: Theme.of(context).textTheme.headline5),
                        onPressed: () => Navigator.pop(context, true),
                        gradient: ColorHelper.getBeaconGradient()),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
