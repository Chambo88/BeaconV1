import 'package:flutter/material.dart';

import 'CreatorPage.dart';

typedef void LocationCallback(String loc);

class LocationPage extends StatefulWidget {
  final VoidCallback onBackClick;
  final VoidCallback onClose;
  final LocationCallback onContinue;
  final String continueText;
  final int totalPageCount;
  final int currentPageIndex;

  LocationPage({
    @required this.onBackClick,
    @required this.onClose,
    @required this.onContinue,
    @required this.totalPageCount,
    @required this.currentPageIndex,
    this.continueText = 'Next',
  });

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {


  @override
  Widget build(BuildContext context) {
    return CreatorPage(
      title: 'Place',
      onClose: widget.onClose,
      onBackClick: widget.onBackClick,
      continueText: widget.continueText,
      totalPageCount: widget.totalPageCount,
      currentPageIndex: widget.currentPageIndex,
      onContinuePressed: () {
        widget.onContinue('');
      },
      child: Center(
        child: Text('TODO'),
      )
    );
  }
}
