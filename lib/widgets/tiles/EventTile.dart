import 'package:beacon/models/EventModel.dart';
import 'package:beacon/pages/Events/EventDetailsPage.dart';
import 'package:beacon/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventTile extends StatelessWidget {
  const EventTile(
      {Key? key, this.event, this.mutualFriendCount, this.figmaColours})
      : super(key: key);
  final EventModel? event;
  final String? mutualFriendCount;
  final FigmaColours? figmaColours;

  String getDateText(DateTime startTime) {
    if (DateTime.now().day == startTime.day &&
        DateTime.now().difference(startTime).inHours < 24) {
      if (startTime.hour > 16) {
        return "Tonight ${DateFormat.jm().format(startTime)}";
      } else {
        return "Today ${DateFormat.jm().format(startTime)}";
      }
    } else if (DateTime.now().add(Duration(days: 1)).day == startTime.day &&
        DateTime.now().difference(startTime).inHours < 48) {
      if (startTime.hour < 3) {
        return "Tonight ${DateFormat.jm().format(startTime)}";
      } else {
        return "This ${DateFormat.E().add_jm().format(startTime)}";
      }
    } else if (startTime.difference(DateTime.now()).inDays < 7) {
      return "This ${DateFormat.E().add_jm().format(startTime)}";
    } else if (startTime.difference(DateTime.now()).inDays < 365) {
      return "${DateFormat('EEE, MMM d h:mm a').format(startTime)}";
    } else {
      return "${DateFormat('MMM d, yyyy').format(startTime)}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: Key(event!.eventId!),
      onDismissed: (direction) {},
      background: Container(
        color: Colors.red,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.archive_outlined,
                    color: Colors.white,
                  ),
                  Text(
                    "Archive",
                    style: Theme.of(context).textTheme.headlineMedium,
                  )
                ],
              ),
            )
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EventDetailsPage(event: event)));
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        event!.eventName! + " -",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        event!.hostName!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Row(children: [
                      Container(
                        width: 85,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                image: NetworkImage(event!.imageUrl!),
                                fit: BoxFit.cover)),
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Icon(Icons.date_range),
                                ),
                                Flexible(
                                  child: Container(
                                    child: Text(
                                      getDateText(event!.startTime!)
                                          .replaceAll("", "\u{200B}"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Icon(Icons.location_on_outlined),
                                ),
                                Flexible(
                                  child: Container(
                                    child: Text(
                                      event!.locationName!
                                          .replaceAll("", "\u{200B}"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Icon(Icons.music_note_outlined),
                                ),
                                Text(
                                  event!.mainGenre!,
                                  style: Theme.of(context).textTheme.titleLarge,
                                )
                              ],
                            ),
                            Container(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Icon(Icons.people_alt_outlined),
                                ),
                                RichText(
                                  text: TextSpan(
                                      text: (mutualFriendCount != '0')
                                          ? "${mutualFriendCount}m"
                                          : '',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(figmaColours!.highlight),
                                      ),
                                      children: [
                                        TextSpan(
                                          text: (mutualFriendCount != '0')
                                              ? " | ${event!.usersAttending!.length.toString()}"
                                              : "${event!.usersAttending!.length.toString()}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        )
                                      ]),
                                  textWidthBasis: TextWidthBasis.longestLine,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ]),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Divider(
                  height: 1,
                  color: Color(figmaColours!.greyLight),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
