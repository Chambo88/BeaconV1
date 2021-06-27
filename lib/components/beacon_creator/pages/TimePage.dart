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
  DateTimeRange _dateRange;

  @override
  void initState() {
    super.initState();
    if (widget.initDateTimeRange != null) {
      _dateRange = widget.initDateTimeRange;
    }
  }

  Future<DateTime> _selectDate(BuildContext context,
      {DateTime initDate}) async {
    var now = DateTime.now();
    final DateTime datePicked = await showDatePicker(
      context: context,
      initialDate: initDate,
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
    if (datePicked != null) {
      final TimeOfDay timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_startDate),
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
      return new DateTime(datePicked.year, datePicked.month, datePicked.day,
          timePicked.hour, timePicked.minute);
    }
    return null;
  }

  Widget _date(BuildContext context, {DateTime date, VoidCallback onTap}) {
    initializeDateFormatting();
    String languageCode = Localizations.localeOf(context).languageCode;
    String format = 'EEEE, d MMMM';
    return Container(
      color: Color(0xFF242424),
      child: InkWell(
        child: ListTile(
          leading: Icon(
            Icons.access_time,
            color: Colors.grey,
          ),
          title: Text('${new DateFormat(
            format,
            languageCode,
          ).format(date)}'),
          trailing: Text(
            new DateFormat.jm(languageCode).format(date),
            style: Theme.of(context).textTheme.headline4,
          ),
          onTap: onTap,
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
      onContinuePressed: () => widget.onContinue(
        new DateTimeRange(
          start: _startDate,
          end: _endDate,
        ),
      ),
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
            date: _endDate,
            onTap: () async {
              DateTime date = await _selectDate(context, initDate: _endDate);
              if (date != null) {
                setState(() {
                  _endDate = date;
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
            date: _startDate,
            onTap: () async {
              DateTime date = await _selectDate(context, initDate: _startDate);
              if (date != null) {
                setState(() {
                  _startDate = date;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
