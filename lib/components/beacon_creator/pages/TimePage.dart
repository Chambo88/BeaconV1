import 'package:beacon/widgets/buttons/BeaconFlatButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //for date format
import 'package:intl/date_symbol_data_local.dart'; //for date locale

import 'CreatorPage.dart';

typedef void TimeCallback(
  DateTime startDateTime,
  DateTime endDateTime,
);

class TimePage extends StatefulWidget {
  final VoidCallback onBackClick;
  final VoidCallback onClose;
  final TimeCallback onContinue;
  final String continueText;
  final int totalPageCount;
  final int currentPageIndex;
  final DateTime initStartDateTime;
  final double initDuration;

  TimePage({
    @required this.onBackClick,
    @required this.onClose,
    @required this.onContinue,
    @required this.totalPageCount,
    @required this.currentPageIndex,
    this.initStartDateTime,
    this.initDuration,
    this.continueText = 'Next',
  });

  @override
  _TimePageState createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  DateTime _startDateTime = new DateTime.now();
  DateTime _endDateTime = new DateTime.now();
  double _duration = .5;

  @override
  void initState() {
    super.initState();
    if (widget.initStartDateTime != null) {
      _startDateTime = widget.initStartDateTime;
    }
    if (widget.initDuration != null) {
      _duration = widget.initDuration;
    }
  }

  Widget _date(BuildContext context,
      {DateTime date, VoidCallback onTimeTap, VoidCallback onDateTap}) {
    initializeDateFormatting();
    String languageCode = Localizations.localeOf(context).languageCode;
    String format = 'EEEE, d MMMM';
    return Container(
      color: Color(0xFF131313),
      child: ListTile(
        title: InkWell(
          child: Text(
            '${new DateFormat(format, languageCode).format(date)}',
            style: Theme.of(context).textTheme.headline5,
          ),
          onTap: onDateTap,
        ),
        trailing: InkWell(
          child: Text(
            new DateFormat.jm(languageCode).format(date),
            style: Theme.of(context).textTheme.headline5,
          ),
          onTap: onTimeTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final minDate = DateTime.now();
    var theme = Theme.of(context);

    return CreatorPage(
      title: 'Time',
      onClose: widget.onClose,
      onBackClick: widget.onBackClick,
      continueText: widget.continueText,
      totalPageCount: widget.totalPageCount,
      currentPageIndex: widget.currentPageIndex,
      onContinuePressed: () => widget.onContinue(
        _startDateTime,
        _endDateTime,
      ),
      child: Column(
        children: [
          _date(
            context,
            date: _startDateTime,
            onDateTap: () {},
            onTimeTap: () async {},
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, top: 10, bottom: 5),
            width: double.infinity,
            child: Text(
              'Start',
              style: theme.textTheme.bodyText2,
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(
            height: 130,
            child: CupertinoTheme(
              data: CupertinoThemeData(
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: TextStyle(
                    color: Color(0xFF868A8C),
                    fontSize: 18,
                  ),
                ),
              ),
              child: CupertinoDatePicker(
                backgroundColor: Color(0xFF131313),
                initialDateTime:
                    _startDateTime.isBefore(minDate) ? minDate : _startDateTime,
                mode: CupertinoDatePickerMode.dateAndTime,
                minimumDate: minDate,
                maximumDate: DateTime(DateTime.now().year + 5, 2, 1),
                use24hFormat: false,
                onDateTimeChanged: (newStartDate) {
                  setState(() {
                    _startDateTime = newStartDate;
                    _endDateTime = _startDateTime
                        .add(Duration(minutes: (_duration * 60).round()));
                  });
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, top: 10),
            width: double.infinity,
            child: Text(
              'Duration (Hours)',
              style: theme.textTheme.bodyText2,
              textAlign: TextAlign.start,
            ),
          ),
          Slider(
            value: _duration,
            min: 0,
            max: 12,
            divisions: 24,
            label: _duration.toStringAsFixed(1),
            onChanged: (double value) {
              setState(() {
                _duration = value;
                _endDateTime = _startDateTime
                    .add(Duration(minutes: (_duration * 60).round()));
              });
            },
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, top: 10, bottom: 5),
            width: double.infinity,
            child: Text(
              'Finish',
              style: theme.textTheme.bodyText2,
              textAlign: TextAlign.start,
            ),
          ),
          _date(
            context,
            date: _endDateTime,
            onDateTap: () {},
            onTimeTap: () async {},
          ),
        ],
      ),
    );
  }
}
