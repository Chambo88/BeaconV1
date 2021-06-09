import 'package:beacon/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController signInEmailController = TextEditingController();
  final TextEditingController signInPasswordController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController signUpEmailController = TextEditingController();
  final TextEditingController signUpPasswordController =
      TextEditingController();
  bool _obscureText = true;
  var error = "";
  var signUpError = "";

  FocusNode signUpEmailFocus = FocusNode();
  FocusNode signUpPasswordFocus = FocusNode();
  FocusNode firstNameFocus = FocusNode();
  FocusNode signInEmailFocus = FocusNode();

  var _pageState = PageState.InitialSelector;

  Widget _initalSelector(BuildContext context) {
    return Center(
      child: Column(
          key: ValueKey("signUpName"),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _pageState = PageState.SignIn;
                      });
                    },
                    child: Text("Sign In")),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _pageState = PageState.SignUpEmail;
                      });
                    },
                    child: Text("Sign Up")),
              ),
            )
          ]),
    );
  }

  Widget _signIn(BuildContext context) {
    return Column(
        key: ValueKey("signIn"),
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 20, 0, 0),
            child: Text(
              "Email",
              style: TextStyle(fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              focusNode: signInEmailFocus,
              controller: signInEmailController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 20, 0, 0),
            child: Text(
              "Password",
              style: TextStyle(fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      color: Colors.white,
                      icon: Icon((_obscureText)
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      })),
              obscureText: _obscureText,
              controller: signInPasswordController,
            ),
          ),
          error == ""
              ? Container()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                  child: Text(
                    error,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Center(
              child: SizedBox(
                width: 220,
                child: ElevatedButton(
                    onPressed: () async {
                      var text = await context.read<AuthService>().signIn(
                            email: signInEmailController.text.trim(),
                            password: signInPasswordController.text.trim(),
                          );
                      if (text != "") {
                        setState(() {
                          error = text;
                        });
                      }
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(fontSize: 16),
                    )),
              ),
            ),
          )
        ]);
  }

  Widget _signUpEmail(BuildContext context) {
    return Column(
        key: ValueKey("signUpEmail"),
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 20, 0, 0),
            child: Text(
              "What's your email?",
              style: TextStyle(fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              focusNode: signUpEmailFocus,
              controller: signUpEmailController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Center(
              child: SizedBox(
                width: 220,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _pageState = PageState.SignUpPassword;
                      });
                    },
                    child: Text(
                      "Continue",
                      style: TextStyle(fontSize: 16),
                    )),
              ),
            ),
          )
        ]);
  }

  Widget _signUpPassword(BuildContext context) {
    return Column(
        key: ValueKey("signUpPassword"),
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 20, 0, 0),
            child: Text(
              "Set a Password",
              style: TextStyle(fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      color: Colors.white,
                      icon: Icon((_obscureText)
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      })),
              obscureText: _obscureText,
              focusNode: signUpPasswordFocus,
              controller: signUpPasswordController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Center(
              child: SizedBox(
                width: 220,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _pageState = PageState.SignUpName;
                      });
                    },
                    child: Text(
                      "Continue",
                      style: TextStyle(fontSize: 16),
                    )),
              ),
            ),
          )
        ]);
  }

  Widget _signUpName(BuildContext context) {
    return Column(
        key: ValueKey("signUpName"),
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 20, 0, 0),
            child: Text(
              "First Name?",
              style: TextStyle(fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              focusNode: firstNameFocus,
              controller: firstNameController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 20, 0, 0),
            child: Text(
              "Last Name?",
              style: TextStyle(fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              controller: lastNameController,
            ),
          ),
          signUpError == ""
              ? Container()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                  child: Text(
                    signUpError,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Center(
              child: SizedBox(
                width: 220,
                child: ElevatedButton(
                    onPressed: () async {
                      var text = await context.read<AuthService>().signUp(
                          firstName: firstNameController.text.trim(),
                          lastName: lastNameController.text.trim(),
                          email: signUpEmailController.text.trim(),
                          password: signUpPasswordController.text.trim());
                      if (text != "") {
                        setState(() {
                          signUpError = text;
                        });
                      }
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(fontSize: 16),
                    )),
              ),
            ),
          )
        ]);
  }

  Widget _getPageState(BuildContext context) {
    switch (_pageState) {
      case PageState.InitialSelector:
        return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _initalSelector(context));
      case PageState.SignIn:
        signInEmailFocus.requestFocus();
        return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _signIn(context));
      case PageState.SignUpEmail:
        signUpEmailFocus.requestFocus();
        return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _signUpEmail(context));
      case PageState.SignUpPassword:
        signUpPasswordFocus.requestFocus();
        return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _signUpPassword(context));
      case PageState.SignUpName:
        firstNameFocus.requestFocus();
        return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _signUpName(context));
      default:
        _initalSelector(context);
    }
    return new Container();
  }

  void _goBack() {
    switch (_pageState) {
      case PageState.SignUpEmail:
        setState(() {
          _pageState = PageState.InitialSelector;
        });
        break;
      case PageState.InitialSelector:
        setState(() {
          _pageState = PageState.InitialSelector;
        });
        break;
      case PageState.SignIn:
        setState(() {
          _pageState = PageState.InitialSelector;
        });
        break;
      case PageState.SignUpPassword:
        setState(() {
          _pageState = PageState.SignUpEmail;
        });
        break;
      case PageState.SignUpName:
        setState(() {
          _pageState = PageState.SignUpPassword;
        });
        break;
      default:
        setState(() {
          _pageState = PageState.InitialSelector;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: _pageState == PageState.InitialSelector
              ? null
              : IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    _goBack();
                  },
                ),
          title: _pageState == PageState.InitialSelector
              ? null
              : _pageState == PageState.SignIn
              ? Text("Sign In")
              : Text("Create Account"),
        ),
        body: SafeArea(child: _getPageState(context)));
  }
}

enum PageState {
  InitialSelector,
  SignIn,
  SignUpEmail,
  SignUpPassword,
  SignUpName
}
