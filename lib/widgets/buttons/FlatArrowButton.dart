import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FlatArrowButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  FlatArrowButton({
    @required this.title,
    @required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey)
            ],
          ),
        ),
      ),
    );
  }
}
