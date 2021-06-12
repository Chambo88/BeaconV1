import 'package:beacon/components/FriendSelectorSheet.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/widgets/buttons/FlatArrowButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateGroupPage extends StatefulWidget {
  UserModel user;

  CreateGroupPage({Key key, this.user}) : super(key: key);

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {

  var _friendsList = Set<String>();

  void _updateFriendsList(Set<String> friendsList) {
    setState(() {
      _friendsList = friendsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Group"),
      ),
      body: Column(
        children: [
          section(theme: theme, title: "Name", child: TextField()),
          section(
            theme: theme,
            title: 'Customization',
            child: Container(),
          ),
          section(
            theme: theme,
            title: 'Members',
            child: Column(
              children: [
                FlatArrowButton(
                    title: 'Add Members', onTap: (){
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (context) {
                      return FriendSelectorSheet(
                        user: widget.user,
                        onContinue: _updateFriendsList,
                        friendsSelected: _friendsList,
                      );
                    },
                  );
                },)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget section({
    @required ThemeData theme,
    @required String title,
    @required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 2),
            child: Text(
              title,
              style: theme.textTheme.bodyText2,
            ),
          ),
          Container(
            color: theme.primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: child,
            ),
          )
        ],
      ),
    );
  }
}
