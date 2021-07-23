import 'package:beacon/util/theme.dart';
import 'package:flutter/material.dart';

class GreyCircleCheckBox extends StatelessWidget {
  bool toggle;
  bool unTogglable;
  GreyCircleCheckBox({@required this.toggle, this.unTogglable=false});
  FigmaColours figmaColours = FigmaColours();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 27,
      height: 27 ,
      child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Color(figmaColours.greyLight),
                      width: 2
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),

            ),
            (toggle || unTogglable)? Align(
              alignment: Alignment.center,
              child: Container(
                width: 17,
                height: 17,
                decoration: new BoxDecoration(
                  color: (unTogglable)? Colors.black : Color(figmaColours.greyLight),
                  shape: BoxShape.circle,
                ),),
            ) : Container(),
          ]
      ),
    );
  }
}