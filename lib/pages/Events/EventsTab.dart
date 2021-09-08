import 'package:beacon/models/EventModel.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/Dialogs/DateRangeDialog.dart';
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
  List<EventModel> eventModelsTemp;

  @override
  void initState() {
    // TODO: implement initState
    filterBy = "Mutual";
    filterStartDate = DateTime.now();
    figmaColours = FigmaColours();
    eventModelsTemp = [EventModel.dummy()];
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

                  label: Text(" Mutual ",
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
                  label: Text("Top ",
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
                    color: (filterStartDate != null)? Color(figmaColours.highlight) : Colors.white,
                  ),
                  label: Text('Date    ',
                    style: TextStyle(
                        color: (filterStartDate != null)? Color(figmaColours.highlight) : Colors.white
                    ),),
                  onPressed: () {
                    return showDialog(
                        context: context,
                        builder: (context) {
                          return DateRangeDialog(
                            initStart: filterStartDate,
                            initEnd: filterEndDate,
                          );
                        }).then((args) {
                          if(args != null) {
                            filterStartDate = args.startDate;
                            if(args.endDate != null) {
                              filterEndDate = args.endDate;
                            } else {
                              filterEndDate = null;
                            }

                          } else {
                            filterStartDate = null;
                            filterEndDate = null;
                          }
                          setState(() {
                          });
                    });
                  },
                  backgroundColor: Color(figmaColours.greyDark),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
            itemBuilder: (context, i) {
              return Row(
                children: [Container(
                  width: 100,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(eventModelsTemp[i].imageUrl),
                      fit: BoxFit.cover
                    )
                  ),
                ),]
              );
            },

          itemCount: 1,
        )
      ],
    );
  }
}
