import 'package:flutter/material.dart';

import 'CreatorPage.dart';

typedef void InvitesCallback(int min, int max);

class InvitesPage extends StatefulWidget {
  final VoidCallback onBackClick;
  final VoidCallback onClose;
  final InvitesCallback onContinue;
  final String continueText;
  final int totalPageCount;
  final int currentPageIndex;

  InvitesPage({
    @required this.onBackClick,
    @required this.onClose,
    @required this.onContinue,
    @required this.totalPageCount,
    @required this.currentPageIndex,
    this.continueText = 'Next',
  });

  @override
  _InvitesPageState createState() => _InvitesPageState();
}

class _InvitesPageState extends State<InvitesPage> {


  @override
  Widget build(BuildContext context) {
    return CreatorPage(
        title: 'Invites',
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
