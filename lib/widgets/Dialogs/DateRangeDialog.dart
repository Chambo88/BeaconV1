import 'package:beacon/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class DateRangeDialog extends StatefulWidget {
  DateTime? initStart;
  DateTime? initEnd;

  DateRangeDialog({this.initStart, this.initEnd});

  @override
  _DateRangeDialogState createState() => _DateRangeDialogState();
}

class _DateRangeDialogState extends State<DateRangeDialog> {
  FigmaColours figmaColours = FigmaColours();
  PickerDateRange? initDateRange;

  @override
  void initState() {
    if (widget.initStart != null) {
      if (widget.initEnd != null) {
        initDateRange = PickerDateRange(widget.initStart, widget.initEnd);
      } else {
        initDateRange = PickerDateRange(widget.initStart, null);
      }
    }
    // initDateRange = PickerDateRange(widget.initStart, widget.initEnd);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Color(figmaColours.greyDark),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        height: MediaQuery.of(context).size.height * 0.70,
        width: MediaQuery.of(context).size.width * 0.9,
        child: SfDateRangePickerTheme(
          data: SfDateRangePickerThemeData(
            backgroundColor: Color(figmaColours.greyDark),
            selectionColor:
                Colors.white.withOpacity(0.3), // Set selection color
            rangeSelectionColor: Colors.white.withOpacity(0.15),
            todayHighlightColor: Colors.white,
            startRangeSelectionColor: Colors.white,
            endRangeSelectionColor: Colors.white,
            headerTextStyle: TextStyle(
                color: Colors.white, fontSize: 18), // Header text color
            viewHeaderTextStyle: TextStyle(
                color: Colors.white, fontSize: 16), // Month header text color
            selectionTextStyle:
                TextStyle(color: Colors.white), // Selected date text color
          ),
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: SfDateRangePicker(
                onSubmit: (object) {
                  Navigator.of(context).pop(object);
                },
                onCancel: () {
                  Navigator.of(context).pop();
                },
                selectionMode: DateRangePickerSelectionMode.range,
                initialSelectedRange: initDateRange,
                enablePastDates: false,
                showNavigationArrow: true,
                showActionButtons: true,
                allowViewNavigation: false,
                navigationMode: DateRangePickerNavigationMode.scroll,
                navigationDirection:
                    DateRangePickerNavigationDirection.vertical,
                headerStyle: DateRangePickerHeaderStyle(
                    backgroundColor: Color(figmaColours.greyDark),
                    textStyle: TextStyle(fontSize: 18)),
                monthViewSettings: DateRangePickerMonthViewSettings(
                    enableSwipeSelection: true,
                    viewHeaderHeight: 40,
                    viewHeaderStyle: DateRangePickerViewHeaderStyle(
                        textStyle: TextStyle(fontSize: 16))),
              )),
        ),
      ),
    );
  }
}
