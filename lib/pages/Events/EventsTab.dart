import 'package:beacon/util/theme.dart';
import 'package:flutter/material.dart';

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
      children: [
        Container(
          height:50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              ActionChip(
                avatar: Icon(Icons.people_outline_outlined,
                  color: (filterBy == "Mutual")? Color(figmaColours.highlight) : Colors.white,
                ),

                label: Text("Mutual   ",
                  style: TextStyle(
                      color: (filterBy == "Mutual")? Color(figmaColours.highlight) : Colors.white
                  ),
                ),
                onPressed: () {
                  setState(() {filterBy = "Mutual";});
                },
                backgroundColor: Color(figmaColours.greyDark),
              ),
              ActionChip(
                avatar: Icon(Icons.arrow_upward_outlined,
                  color: (filterBy == "Top")? Color(figmaColours.highlight) : Colors.white,
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
              ActionChip(
                avatar: Icon(Icons.date_range_outlined,
                  color: (filterEndDate != null)? Color(figmaColours.highlight) : Colors.white,
                ),
                label: Text('Date   ',
                  style: TextStyle(
                      color: (filterEndDate != null)? Color(figmaColours.highlight) : Colors.white
                  ),),
                onPressed: () {},
                backgroundColor: Color(figmaColours.greyDark),
              )
            ],
          ),
        )
      ],
    );
  }
}
