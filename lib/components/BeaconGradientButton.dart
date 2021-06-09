import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BeaconGradientButton extends StatelessWidget {
  String title;
  Function onPressed;

  BeaconGradientButton({this.title, this.onPressed});

  List<Color> getBackgroundColors() {
    return onPressed != null ?
      [Color(0xFFB500E2), Color(0xFFFF6648)] :
      [Color(0xFF2A2929), Color(0xFF2A2929)];
  }

  Color getTextColor() {
    return onPressed != null ? Colors.white : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: double.infinity,
      height: 40,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: getBackgroundColors(),
        ),
      ),
      child: MaterialButton(
        child: Text(
          title,
          style: TextStyle(
            color: getTextColor(),
            fontSize: 18,
          ),
        ),
        onPressed: onPressed,
      ),
    ));
  }
}
