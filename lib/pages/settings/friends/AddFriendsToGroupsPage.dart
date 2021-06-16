// import 'package:beacon/models/GroupModel.dart';
// import 'package:beacon/models/UserModel.dart';
// import 'package:beacon/widgets/progress_widget.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import '../SettingsPage.dart';
// import 'package:flutter/foundation.dart';
// import 'package:provider/provider.dart';
//
// typedef void SelectedChangedCallback(UserModel person, bool isSelected);
//
// class Add_friends extends StatefulWidget {
//   @override
//   _Add_friendsState createState() => _Add_friendsState();
//
//   GroupModel group;
//   Add_friends({this.group});
// }
//
// class _Add_friendsState extends State<Add_friends> {
//   FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;
//
//   List<UserModel> _friends = [];
//   List<UserModel> _friends_not_added_yet = [];
//   List<UserModel> _friends_not_added_yet_duplicate = [];
//
//   //
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   final user = Provider.of<UserModel>(context);
//   // }
//
//   //returns a new List<Person> with those that have not been added to the group yet
//   List<UserModel> get_unadded_friends(List<UserModel> _friends) {
//     bool condition = false;
//     List<UserModel> return_list = [];
//
//     for (int index = 0; index < _friends.length; index++) {
//       condition = false;
//       for (int index2 = 0; index2 < widget.group.userIds.length; index2++) {
//         if (widget.group.userIds[index2] == _friends[index].getId) {
//           condition = true;
//           break;
//         }
//       }
//       if (condition == false) {
//         return_list.add(_friends[index]);
//       }
//     }
//     return return_list;
//   }
//
//   //Gets the data from friends users then builds the friendlist search add thingy
//   FutureBuilder<QuerySnapshot> HaveFriends(UserModel user) {
//     return FutureBuilder(
//       future: _fireStoreDataBase
//           .collection('users')
//           .where('userId', whereIn: user.friends)
//           .get(),
//       builder: (context, dataSnapshot) {
//         while (!dataSnapshot.hasData) {
//           return circularProgress();
//         }
//         dataSnapshot.data.docs.forEach((document) {
//           UserModel users = UserModel.fromDocument(document);
//           _friends.add(users);
//         });
//
//         _friends_not_added_yet = get_unadded_friends(_friends);
//         _friends_not_added_yet_duplicate.addAll(_friends_not_added_yet);
//         return AddUsersToGroupMain(
//           friends: _friends,
//           group: widget.group,
//           friends_not_added_yet: _friends_not_added_yet,
//           friends_not_added_yet_duplicate: _friends_not_added_yet_duplicate,
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<UserModel>(context, listen: false);
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(child: Text('Add Friends')),
//       ),
//       body: doesUserHaveFriends(user),
//     );
//   }
//
//   //checks if the user list is empty or not
//   doesUserHaveFriends(UserModel user) {
//     if (user.friends.isEmpty) {
//       return Container(child: Text('no friends lol'));
//     } else
//       return HaveFriends(user);
//   }
// }
//
// ///-------------This is the main search stuff after the users are loaded----------
// class AddUsersToGroupMain extends StatefulWidget {
//   List<UserModel> friends;
//   GroupModel group;
//   List<UserModel> friends_not_added_yet;
//   List<UserModel> friends_not_added_yet_duplicate;
//   AddUsersToGroupMain(
//       {this.group,
//       this.friends_not_added_yet,
//       this.friends_not_added_yet_duplicate,
//       this.friends});
//
//   @override
//   _AddUsersToGroupMainState createState() => _AddUsersToGroupMainState();
// }
//
// class _AddUsersToGroupMainState extends State<AddUsersToGroupMain> {
//   TextEditingController editingController = TextEditingController();
//   // List<UserModel> _friends_not_added_yet = [];
//   // List<UserModel> _friends_not_added_yet_duplicate = [];
//   List<UserModel> _selected_list = [];
//
//   void filterSearchResults(String query) {
//     List<UserModel> dummySearchList = [];
//     dummySearchList.addAll(widget.friends_not_added_yet_duplicate);
//     if (query.isNotEmpty) {
//       List<UserModel> dummyListData = [];
//       dummySearchList.forEach((person) {
//         if (person.getFirstName.toLowerCase().contains(query) ||
//             person.getLastName.toLowerCase().contains(query)) {
//           dummyListData.add(person);
//         }
//       });
//       setState(() {
//         widget.friends_not_added_yet.clear();
//         widget.friends_not_added_yet.addAll(dummyListData);
//       });
//       return;
//     } else {
//       setState(() {
//         widget.friends_not_added_yet.clear();
//         widget.friends_not_added_yet
//             .addAll(widget.friends_not_added_yet_duplicate);
//       });
//     }
//   }
//
//   void _add_to_selected(UserModel person, bool isSelected) {
//     setState(() {
//       if (!isSelected) {
//         _selected_list.add(person);
//       } else {
//         _selected_list.remove(person);
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return Container(
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               onChanged: (value) {
//                 filterSearchResults(value);
//               },
//               style: TextStyle(color: Colors.white),
//               controller: editingController,
//               decoration: InputDecoration(
//                 labelText: "Search",
//                 hintText: "Search",
//
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(25.0),
//                   ),
//                 ),
//               ).applyDefaults(theme.inputDecorationTheme),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: widget.friends_not_added_yet.length,
//               itemBuilder: (context, index) {
//                 return AddTile(
//                   friends_not_added_yet: widget.friends_not_added_yet,
//                   selected: _selected_list
//                       .contains(widget.friends_not_added_yet[index]),
//                   selection_change: _add_to_selected,
//                   index: index,
//                   group: widget.group,
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//     ;
//   }
// }
//
// class AddTile extends StatefulWidget {
//   AddTile({
//     Key key,
//     @required List<UserModel> friends_not_added_yet,
//     this.index,
//     this.selected,
//     this.selection_change,
//     this.group,
//   })  : _friends_not_added_yet = friends_not_added_yet,
//         super(key: key);
//
//   List<UserModel> _friends_not_added_yet;
//   int index;
//   bool selected;
//   SelectedChangedCallback selection_change;
//   GroupModel group;
//
//   @override
//   _AddTileState createState() => _AddTileState();
// }
//
// class _AddTileState extends State<AddTile> {
//   Color _getColor(BuildContext context) {
//     return widget.selected ? Colors.red : Colors.green;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//         title: Text(widget._friends_not_added_yet[widget.index].getFirstName +
//             " " +
//             widget._friends_not_added_yet[widget.index].getLastName),
//         trailing: widget.selected
//             ? buildSubtractButton(context)
//             : buildAddButton(context));
//   }
//
//   GestureDetector buildAddButton(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         widget.selection_change(
//             widget._friends_not_added_yet[widget.index], false);
//         widget.group.add_id(widget._friends_not_added_yet[widget.index].getId);
//         widget.selected = true;
//         setState(() {});
//       },
//       child: Icon(
//         Icons.add,
//         color: _getColor(context),
//       ),
//     );
//   }
//
//   GestureDetector buildSubtractButton(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         widget.selection_change(
//             widget._friends_not_added_yet[widget.index], true);
//         widget.group
//             .remove_id(widget._friends_not_added_yet[widget.index].getId);
//         widget.selected = false;
//         setState(() {});
//       },
//       child: Icon(
//         Icons.add,
//         color: _getColor(context),
//       ),
//     );
//   }
// }
