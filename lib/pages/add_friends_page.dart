import 'package:beacon/models/user_model.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddFriendsPage extends StatefulWidget {
  @override
  _AddFriendsPageState createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> with AutomaticKeepAliveClientMixin<AddFriendsPage>
{
  TextEditingController searchTextEditingController = TextEditingController();
  Future<QuerySnapshot> futureSearchResults;

  void filterSearchResults(String query) {

    if(query.isNotEmpty) {
      Future<QuerySnapshot> allUsers = FirebaseFirestore.instance.collection(
          "users").where("nameSearch", arrayContains: query).get();
      setState(() {
        futureSearchResults = allUsers;
        // searchTextEditingController.text = query;
      }

      );
    } else {
      setState(() {
        futureSearchResults = null;
        // searchTextEditingController.text = '';
      });
    }
  }


  TextField searchBar() {
    return TextField(
        controller: searchTextEditingController,
        // decoration: InputDecoration(
        //     prefixIcon: Icon(Icons.person_pin),
        //     suffix: IconButton(
        //       icon: Icon(Icons.clear),
        //       onPressed: emptyTheTextFormField(),
        //     )
        // ),
        onChanged: (value) {
          filterSearchResults(value);
        }

      );
  }

  emptyTheTextFormField() {
    searchTextEditingController.clear();
  }


  Container displayNoSearchResultsScreen() {
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Text('Search friends')
          ],
        ),
      )
    );
  }

  FutureBuilder displayUsersFoundScreen() {
   return FutureBuilder(
      future: futureSearchResults,
      builder: (context, dataSnapshot) {

        while(!dataSnapshot.hasData)
        {
          return circularProgress();
        }

        List<UserResult> searchUsersResult = [];
        dataSnapshot.data.docs.forEach((document)
        {
          UserModel users = UserModel.fromDocument(document);
          UserResult userResult = UserResult(user: users);
          searchUsersResult.add(userResult);
        });

        return ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: searchUsersResult,
        );
      },
    );
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Friends'),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
              height: 200,
              child: searchBar(),
          ),
          Expanded(child: futureSearchResults == null? displayNoSearchResultsScreen(): displayUsersFoundScreen()),
      ]

      ),
    );
  }

}

class UserResult extends StatelessWidget {
  final UserModel user;
  UserResult({this.user});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white54,
        child: Column(
          children: [
            GestureDetector(
              onTap: ()=> print("this is where the add friend bit goes"),
              child: ListTile(
                title: Text(user.firstName)
              ),
            )
          ],
        ),
      ),
    );
  }
}
