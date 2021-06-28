import 'package:flutter/material.dart';

import 'CreatorPage.dart';

typedef void AttendanceCallback(int min, int max);

class AttendancePage extends StatefulWidget {
  final VoidCallback onBackClick;
  final VoidCallback onClose;
  final AttendanceCallback onContinue;
  final String continueText;
  final int totalPageCount;
  final int currentPageIndex;

  AttendancePage({
    @required this.onBackClick,
    @required this.onClose,
    @required this.onContinue,
    @required this.totalPageCount,
    @required this.currentPageIndex,
    this.continueText = 'Next',
  });

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {


  @override
  Widget build(BuildContext context) {
    return CreatorPage(
        title: 'Attendance',
        onClose: widget.onClose,
        onBackClick: widget.onBackClick,
        continueText: widget.continueText,
        onContinuePressed: () {
          widget.onContinue(0, 0);
        },
        totalPageCount: widget.totalPageCount,
        currentPageIndex: widget.currentPageIndex,
        child: Center(
          child: Text('TODO'),
        )
    );
  }
}
