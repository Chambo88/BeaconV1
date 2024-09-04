// import 'package:beacon/widgets/beacon_sheets/EventBeaconSheet.dart';

//
// class FriendEventItem extends StatelessWidget {
//   final EventBeacon beacon;
//
//   FriendEventItem({@required this.beacon});
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return BeaconItem(
//       height: 200,
//       onTap: () {
//       Navigator.pop(context);
//       showModalBottomSheet(
//         context: context,
//         backgroundColor: Colors.transparent,
//         isScrollControlled: true,
//         builder: (context) {
//           return EventBeaconSheet(
//             beacon: beacon,
//           );
//         },
//       );
//     },
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.circle,
//                       size: 50,
//                       color: Colors.white,
//                     ),
//                     Expanded(
//                       child: Center(
//                         child: Text(
//                           beacon.id,
//                           style: theme.textTheme.displaySmall,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 5),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         beacon.userName,
//                         style: theme.textTheme.headlineSmall,
//                       ),
//                       Text('17:00 - 20:00', // TODO replace with time,
//                           style: theme.textTheme.labelLarge)
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   // alignment: Alignment.centerLeft,
//                   // padding: const EdgeInsets.only(top: 5),
//                   child: Container(
//                     padding: const EdgeInsets.only(bottom: 5),
//                     child: Text(
//                       beacon.desc,
//                       style: theme.textTheme.bodyMedium,
//                       textAlign: TextAlign.left,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(right: 3),
//                     child: Text(
//                       '16',
//                       style: theme.textTheme.labelLarge,
//                     ),
//                   ),
//                   Text(
//                     'Mutual',
//                     style: theme.textTheme.bodyMedium,
//                   )
//                 ],
//               ),
//               SmallOutlinedButton(
//                 title: 'Going?',
//                 onPressed: () {},
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
