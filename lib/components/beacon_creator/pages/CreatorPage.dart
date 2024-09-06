import 'package:beacon/library/ColorHelper.dart';
import 'package:beacon/widgets/buttons/GradientButton.dart';
import 'package:flutter/material.dart';

class CreatorPage extends StatefulWidget {
  final String? title;
  final VoidCallback? onBackClick;
  final VoidCallback? onClose;
  final Widget? child;
  final String? continueText;
  final VoidCallback? onContinuePressed;
  final int? totalPageCount;
  final int? currentPageIndex;

  CreatorPage({
    @required this.title,
    @required this.onBackClick,
    @required this.onClose,
    @required this.onContinuePressed,
    @required this.child,
    this.totalPageCount,
    this.currentPageIndex,
    this.continueText = 'Continue',
  });

  @override
  State<CreatorPage> createState() => _CreatorPageState();
}

class _CreatorPageState extends State<CreatorPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(children: [
      Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 70,
            width: double.infinity,
            child: ListTile(
              leading: widget.onBackClick != null
                  ? IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.grey,
                      ),
                      onPressed: widget.onBackClick,
                    )
                  : Text(''),
              title: Text(
                widget.title!,
                style: Theme.of(context).textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: widget.onClose),
            ),
          ),
          Expanded(child: SingleChildScrollView(child: widget.child)),
          (widget.totalPageCount != null && widget.currentPageIndex != null)
              ? ProgressBar(
                  pageCount: widget.totalPageCount!,
                  currentPageIndex: widget.currentPageIndex!,
                )
              : Container(),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: GradientButton(
              child: Text(
                widget.continueText!,
                style: theme.textTheme.headlineMedium,
              ),
              gradient: ColorHelper.getBeaconGradient(),
              onPressed: widget.onContinuePressed,
            ),
          ),
        ],
      )
    ]);
  }
}

class ProgressBar extends StatelessWidget {
  final int? pageCount;
  final int? currentPageIndex;
  final List<ProgressBarSegment>? _segments = [];

  ProgressBar({
    @required this.pageCount,
    @required this.currentPageIndex,
  }) {
    for (var i = 0; i < this.pageCount!; i++) {
      Color color;
      if (i <= currentPageIndex!) {
        color = Color(0xFFAD00FF);
      } else {
        color = Color(0xFF868A8C);
      }
      _segments!.add(ProgressBarSegment(color: color));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8.0, 10, 0),
      child: Row(children: _segments!),
    );
  }
}

class ProgressBarSegment extends StatelessWidget {
  final Color? color;

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
