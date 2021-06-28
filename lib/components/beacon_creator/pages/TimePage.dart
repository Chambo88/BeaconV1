import 'package:beacon/widgets/buttons/BeaconFlatButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //for date format
import 'package:intl/date_symbol_data_local.dart'; //for date locale

import 'CreatorPage.dart';

typedef void TimeCallback(DateTimeRange dateTimeRange);

class TimePage extends StatefulWidget {
  final VoidCallback onBackClick;
  final VoidCallback onClose;
  final TimeCallback onContinue;
  final String continueText;
  final int totalPageCount;
  final int currentPageIndex;
  final DateTimeRange initDateTimeRange;

  TimePage({
    @required this.onBackClick,
    @required this.onClose,
    @required this.onContinue,
    @required this.totalPageCount,
    @required this.currentPageIndex,
    this.initDateTimeRange,
    this.continueText = 'Next',
  });

  @override
  _TimePageState createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  DateTimeRange _dateRange = DateTimeRange(
    start: new DateTime.now(),
    end: new DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    if (widget.initDateTimeRange != null) {
      _dateRange = widget.initDateTimeRange;
    }
  }

  Future<void> _selectDates(BuildContext context) async {
    var now = DateTime.now();
    DateTimeRange dateTimeRange = await showDateRangePicker(
      context: context,
      initialDateRange: _dateRange,
      firstDate: now,
      lastDate: new DateTime(now.year + 5),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Theme.of(context).primaryColor,
            accentColor: Theme.of(context).accentColor,
            backgroundColor: Theme.of(context).primaryColor,
            colorScheme:
                ColorScheme.light(primary: Theme.of(context).accentColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    setState(() {
      _dateRange = new DateTimeRange(
        start: new DateTime(
          dateTimeRange.start.year,
          dateTimeRange.start.month,
          dateTimeRange.start.day,
          _dateRange.start.hour,
          _dateRange.start.minute,
        ),
        end: new DateTime(
          dateTimeRange.end.year,
          dateTimeRange.end.month,
          dateTimeRange.end.day,
          _dateRange.end.hour,
          _dateRange.end.minute,
        ),
      );
    });
  }

  Future<DateTime> _selectTime(BuildContext context,
      {DateTime dateTime}) async {
    final TimeOfDay timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(dateTime),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Theme.of(context).primaryColor,
            accentColor: Theme.of(context).accentColor,
            backgroundColor: Theme.of(context).primaryColor,
            colorScheme:
                ColorScheme.light(primary: Theme.of(context).accentColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    return new DateTime(dateTime.year, dateTime.month, dateTime.day,
        timePicked.hour, timePicked.minute);
  }

  Widget _date(BuildContext context,
      {DateTime date, VoidCallback onTimeTap, VoidCallback onDateTap}) {
    initializeDateFormatting();
    String languageCode = Localizations.localeOf(context).languageCode;
    String format = 'EEEE, d MMMM';
    return Container(
      color: Color(0xFF242424),
      child: ListTile(
        leading: Icon(
          Icons.access_time,
          color: Colors.grey,
        ),
        title: InkWell(
          child: Text('${new DateFormat(
            format,
            languageCode,
          ).format(date)}'),
          onTap: onDateTap,
        ),
        trailing: InkWell(
          child: Text(
            new DateFormat.jm(languageCode).format(date),
            style: Theme.of(context).textTheme.headline4,
          ),
          onTap: onTimeTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CreatorPage(
      title: 'Time',
      onClose: widget.onClose,
      onBackClick: widget.onBackClick,
      continueText: widget.continueText,
      totalPageCount: widget.totalPageCount,
      currentPageIndex: widget.currentPageIndex,
      onContinuePressed: () => widget.onContinue(_dateRange),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
            child: Text(
              'From',
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.start,
            ),
          ),
          _date(
            context,
            date: _dateRange.start,
            onDateTap: () { _selectDates(context); },
            onTimeTap: () async {
              DateTime date =
                  await _selectTime(context, dateTime: _dateRange.start);
              if (date != null) {
                setState(() {
                  _dateRange =
                      new DateTimeRange(start: date, end: _dateRange.end);
                });
              }
            },
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
            child: Text(
              'To',
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.start,
            ),
          ),
          _date(
            context,
            date: _dateRange.end,
            onDateTap: () { _selectDates(context); },
            onTimeTap: () async {
              DateTime date =
                  await _selectTime(context, dateTime: _dateRange.end);
              if (date != null) {
                setState(() {
                  _dateRange =
                      new DateTimeRange(start: _dateRange.start, end: date);
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
