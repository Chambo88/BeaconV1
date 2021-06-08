import 'package:beacon/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var isSignUp = false;

  Widget _signUpFields(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        TextField(
          controller: firstNameController,
          style: theme.textTheme.bodyText1,
          decoration: InputDecoration(labelText: "First Name")
        ),
        TextField(
          controller: lastNameController,
          style: theme.textTheme.bodyText1,
          decoration: InputDecoration(labelText: "Last Name")
        ),
        TextField(
          controller: emailController,
          style: theme.textTheme.bodyText1,
          decoration: InputDecoration(labelText: "Email")
        ),
        TextField(
          controller: passwordController,
          style: theme.textTheme.bodyText1,
          decoration: InputDecoration(labelText: "Password")
        ),
        ElevatedButton(
          onPressed: () async {
            var text = await context.read<AuthService>().signUp(
                firstName: firstNameController.text.trim(),
                lastName: lastNameController.text.trim(),
                email: emailController.text.trim(),
                password: passwordController.text.trim());
            if (text != "") {
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    _buildPopupDialog(context, text),
              );
            }
          },
          child: Text("Create Account"),
        ),
        Center(child: Text("Or")),
        ElevatedButton(
            onPressed: () {
              setState(() {
                isSignUp = !isSignUp;
              });
            },
            child: Text("Sign in"))
      ],
    );
  }

  Widget _signInFields(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        TextField(
          style: theme.textTheme.bodyText1,
          controller: emailController,
          decoration: InputDecoration(labelText: "Email")
        ),
        TextField(
          style: theme.textTheme.bodyText1,
          controller: passwordController,
          decoration: InputDecoration(labelText: "Password")
        ),
        ElevatedButton(
          onPressed: () async {
            var text = await context.read<AuthService>().signIn(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                );
            if (text != "") {
              showDialog(
                context: context,
                builder: (BuildContext context) => _buildPopupDialog(
                  context,
                  text,
                ),
              );
            }
          },
          child: Text("Sign in"),
        ),
        Center(child: Text("Or")),
        ElevatedButton(
            onPressed: () {
              setState(() {
                isSignUp = !isSignUp;
              });
            },
            child: Text("Create Account"))
      ],
    );
  }

  Widget _buildPopupDialog(BuildContext context, String text) {
    return new AlertDialog(
      title: const Text('POP!'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(text),
        ],
      ),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Ok"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: (isSignUp) ? _signUpFields(context) : _signInFields(context),
    ));
  }
}
