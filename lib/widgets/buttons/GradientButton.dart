import 'package:beacon/library/ColorHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final LinearGradient gradient;
  final LinearGradient disabledGradient;
  final Widget child;

  GradientButton({
    @required this.child,
    @required this.onPressed,
    @required this.gradient,
    this.disabledGradient = const LinearGradient(
      colors: [Color(0xFF2A2929), Color(0xFF2A2929)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    )
  });

  LinearGradient _getGradient() {
    return onPressed == null ? disabledGradient : gradient;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: ShapeDecoration(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        gradient: _getGradient(),

      ),
      child: MaterialButton(
        elevation: 15,
        child: child,
        onPressed: onPressed,
      ),
    );
  }
}
