import 'package:beacon/library/ColorHelper.dart';
import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/BeaconType.dart';
import 'package:beacon/services/LoactionService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/buttons/GradientButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreatorPage extends StatelessWidget {
  final String title;
  final VoidCallback onBackClick;
  final VoidCallback onClose;
  final Widget child;
  final String continueText;
  final VoidCallback onContinuePressed;
  final int totalPageCount;
  final int currentPageIndex;

  CreatorPage(
      {@required this.title,
      @required this.onBackClick,
      @required this.onClose,
      @required this.onContinuePressed,
      @required this.child,
      @required this.totalPageCount,
      @required this.currentPageIndex,
      this.continueText = 'Next'});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _beaconSelectorHeader(
          context: context,
          title: title,
          onBackClick: onBackClick,
        ),
        Expanded(child: SingleChildScrollView(child: child)),
        ProgressBar(
          pageCount: totalPageCount,
          currentPageIndex: currentPageIndex,
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: GradientButton(
            child: Text(
              continueText,
              style: theme.textTheme.headline4,
            ),
            gradient: ColorHelper.getBeaconGradient(),
            onPressed: onContinuePressed,
          ),
        ),
      ],
    );
  }

  Widget _beaconSelectorHeader(
      {BuildContext context, String title, Function onBackClick}) {
    return Container(
      height: 70,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          onBackClick != null
              ? IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey,
                  ),
                  onPressed: onBackClick,
                )
              : Container(),
          Text(
            title,
            style: Theme.of(context).textTheme.headline2,
            textAlign: TextAlign.center,
          ),
          IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: onClose),
        ],
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  final int pageCount;
  final int currentPageIndex;
  final List<ProgressBarSegment> _segments = [];

  ProgressBar({
    @required this.pageCount,
    @required this.currentPageIndex,
  }) {
    for (var i = 0; i < this.pageCount; i++) {
      Color color;
      if (i <= currentPageIndex) {
        color = Color(0xFFAD00FF);
      } else {
        color = Color(0xFF868A8C);
      }
      _segments.add(ProgressBarSegment(color: color));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(children: _segments),
    );
  }
}

class ProgressBarSegment extends StatelessWidget {
  final Color color;

  ProgressBarSegment({@required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          height: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: color,
          ),
        ),
      ),
    );
  }
}
