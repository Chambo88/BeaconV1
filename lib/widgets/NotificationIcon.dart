import 'package:beacon/util/theme.dart';
import 'package:provider/provider.dart';
import 'package:beacon/services/AuthService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationIcon extends StatefulWidget {
  @override
  _NotificationIconState createState() => _NotificationIconState();

  bool? active;
  NotificationIcon({this.active});
}

class _NotificationIconState extends State<NotificationIcon> {
  FigmaColours figmaColours = FigmaColours();

  Widget notificationCircleCounter(BuildContext context) {
    final currentUser = context.read<AuthService>().getUserId;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('notifications')
            .where("seen", isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          while (!snapshot.hasData) {
            return Positioned(child: Container());
          }
          if (snapshot.connectionState == ConnectionState.done) {}
          int notificationCount = snapshot.data!.docs.length;
          if (notificationCount == 0) {
            return Positioned(child: Container());
          }
          return Positioned(
            right: 0,
            top: -5,
            child: new Container(
              padding: EdgeInsets.all(1),
              decoration: new BoxDecoration(
                color: Color(FigmaColours().highlight),
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
              child: new Text(
                notificationCount.toString(),
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      child: new Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Center(
            child: new Icon(
              widget.active!
                  ? Icons.notifications
                  : Icons.notifications_outlined,
              color: widget.active!
                  ? Color(FigmaColours().highlight)
                  : Colors.white,
            ),
          ),
          notificationCircleCounter(context),
        ],
      ),
    );
  }
}
