import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditNamePage extends StatefulWidget {
  @override
  _EditNamePageState createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  FigmaColours figmaColours = FigmaColours();
  final _formKey = GlobalKey<FormState>();
  bool enabled = false;
  String? firstName;
  String? lastName;
  UserModel? user;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    user = context.read<UserService>().currentUser;
    firstName = user!.firstName;
    lastName = user!.lastName;
    firstNameController.text = user!.firstName!;
    lastNameController.text = user!.lastName!;
  }

  void setEnabledButton() {
    setState(() {
      enabled = _formKey.currentState!.validate() &&
          (firstName != user!.firstName || lastName != user!.lastName) &&
          (firstName != '' && lastName != '');
    });
  }

  @override
  Widget build(BuildContext context) {
    var userService = Provider.of<UserService>(context);
    final theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 70,
          leading: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "cancel",
                style: TextStyle(
                  color: theme.secondaryHeaderColor,
                ),
              )),
          title: Text("Name"),
          actions: [
            enabled
                ? TextButton(
                    onPressed: () {
                      userService.changeName(firstName!, lastName!);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(
                          color: theme.secondaryHeaderColor,
                          fontWeight: FontWeight.bold),
                    ))
                : TextButton(
                    onPressed: null,
                    child: Text(
                      "Save",
                      style: TextStyle(
                        color: Color(figmaColours.greyLight),
                        fontWeight: FontWeight.bold,
                      ),
                    ))
          ],
        ),
        body: Form(
          key: _formKey,
          onChanged: setEnabledButton,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: TextFormField(
                  style: TextStyle(color: theme.secondaryHeaderColor),
                  decoration: new InputDecoration(
                    prefixIconConstraints:
                        BoxConstraints(minWidth: 0, minHeight: 0),
                    // isDense: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child:
                          Text("First", style: theme.textTheme.headlineSmall),
                    ),
                    hintText: "Add your first name",
                  ),
                  autovalidateMode: AutovalidateMode.always,
                  controller: firstNameController,
                  onChanged: (value) {
                    firstName = value;
                    setEnabledButton();
                  },
                  validator: (value) {
                    if (value!.length > 20) {
                      return 'Name cannot be over 20 characters';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                child: TextFormField(
                  style: TextStyle(color: theme.secondaryHeaderColor),
                  decoration: new InputDecoration(
                    prefixIconConstraints:
                        BoxConstraints(minWidth: 0, minHeight: 0),
                    prefixIcon: Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Text("Last", style: theme.textTheme.headlineSmall),
                    ),
                    hintText: "Add your last name",
                  ),
                  autovalidateMode: AutovalidateMode.always,
                  controller: lastNameController,
                  onChanged: (value) {
                    lastName = value;
                    setEnabledButton();
                  },
                  validator: (value) {
                    if (value!.length > 20) {
                      return 'Name cannot be over 20 characters';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
