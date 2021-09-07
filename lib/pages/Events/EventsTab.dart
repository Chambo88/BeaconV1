import 'package:beacon/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class EventsTab extends StatefulWidget {

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {

  String filterBy;
  DateTime filterStartDate;
  DateTime filterEndDate;
  FigmaColours figmaColours;

  @override
  void initState() {
    // TODO: implement initState
    filterBy = "Mutual";
    filterStartDate = DateTime.now();
    figmaColours = FigmaColours();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height:50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: ActionChip(
                  side: BorderSide(width: 0),
                  avatar: Padding(
                    padding: const EdgeInsets.only(left:6.0),
                    child: Icon(Icons.people_outline_outlined,
                      color: (filterBy == "Mutual")? Color(figmaColours.highlight) : Colors.white,
                    ),
                  ),

                  label: Text(" Mutual   ",
                    style: TextStyle(
                        color: (filterBy == "Mutual")? Color(figmaColours.highlight) : Colors.white
                    ),
                  ),
                  onPressed: () {
                    setState(() {filterBy = "Mutual";});
                  },
                  backgroundColor: Color(figmaColours.greyDark),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: ActionChip(
                  side: BorderSide(width: 0),
                  avatar: Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Icon(Icons.arrow_upward_outlined,
                      color: (filterBy == "Top")? Color(figmaColours.highlight) : Colors.white,
                    ),
                  ),
                  label: Text("Top   ",
                    style: TextStyle(
                      color: (filterBy == "Top")? Color(figmaColours.highlight) : Colors.white
                    ),
                  ),
                  onPressed: () {
                    setState(() {filterBy = "Top";});
                  },
                  backgroundColor: Color(figmaColours.greyDark),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: ActionChip(
                  labelPadding: EdgeInsets.only(left: 4),
                  padding: const EdgeInsets.only(left: 8.0),
                  side: BorderSide(width: 0),
                  avatar: Icon(Icons.date_range_outlined,
                    color: (filterEndDate != null)? Color(figmaColours.highlight) : Colors.white,
                  ),
                  label: Text('Date     ',
                    style: TextStyle(
                        color: (filterEndDate != null)? Color(figmaColours.highlight) : Colors.white
                    ),),
                  onPressed: () {},
                  backgroundColor: Color(figmaColours.greyDark),
                ),
              ),
            ],
          ),
        ),
        SfDateRangePicker(),
      ],
    );
  }
}
