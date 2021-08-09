import 'package:beacon/Assests/PrivacyPolicyText.dart';
import 'package:beacon/Assests/TermsOfServiceText.dart';
import 'package:beacon/library/ColorHelper.dart';
import 'package:beacon/services/AuthService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/beacon_sheets/TextSheet.dart';
import 'package:beacon/widgets/buttons/GradientButton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController signInEmailController;
  TextEditingController signInPasswordController;
  TextEditingController firstNameController;
  TextEditingController lastNameController;
  TextEditingController signUpEmailController;
  TextEditingController signUpPasswordController;
  final FigmaColours figmaColours = FigmaColours();
  bool _obscureText = true;
  var error = "";
  var signUpError = "";
  final double widthPadding = 35;
  bool signUpNameCondition = false;
  bool signUpNameTooLong = false;
  bool signUpPasswordCondition = false;

  FocusNode signUpEmailFocus;
  FocusNode signUpPasswordFocus;
  FocusNode firstNameFocus;
  FocusNode signInEmailFocus;

  @override
  void initState() {
    signInEmailController = TextEditingController();
    signInPasswordController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    signUpEmailController = TextEditingController();
    signUpPasswordController = TextEditingController();
    signUpEmailFocus = FocusNode();
    signUpPasswordFocus = FocusNode();
    firstNameFocus = FocusNode();
    signInEmailFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    signInEmailController.dispose();
    signInPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    signUpEmailController.dispose();
    signUpPasswordController.dispose();
    signUpEmailFocus.dispose();
    signUpPasswordFocus.dispose();
    firstNameFocus.dispose();
    signInEmailFocus.dispose();
    super.dispose();
  }


  var _pageState = PageState.InitialSelector;

  void checkSignUpNameCondition() {
    if(firstNameController.text.isNotEmpty && lastNameController.text.isNotEmpty
      && firstNameController.text.length <= 20 && lastNameController.text.length <= 20
    ) {
      signUpNameCondition = true;
      signUpNameTooLong = false;
    } else {
      if(firstNameController.text.length > 20 || lastNameController.text.length > 20) {
        signUpNameTooLong = true;
      } else {
        signUpNameTooLong = false;
      }
      signUpNameCondition = false;

    }
  }

  Widget _initalSelector(BuildContext context) {
    return Center(
      child: Column(
          key: ValueKey("signUpName"),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthPadding),
              child: SizedBox(
                width: double.infinity,
                child: GradientButton(
                  onPressed: () {
                    setState(() {
                      _pageState = PageState.SignIn;
                    });
                  },
                  child: Text(
                    'Log In',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  gradient: ColorHelper.getBeaconGradient(),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(35, 15, 35, 35),
              child: SizedBox(
                width: double.infinity,
                child: GradientButton(
                  onPressed: () {
                    setState(() {
                      _pageState = PageState.SignUpName;
                    });
                  },
                  child: Text(
                    'Sign Up',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  gradient: ColorHelper.getBeaconGradient(),
                ),
              ),
            )
          ]),
    );
  }

  Widget _signIn(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthPadding),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          key: ValueKey("signIn"),
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "Log in",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Email",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
            TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 10), // add padding to adjust text
                fillColor: Colors.black,
              ),
              autofocus: true,
              controller: signInEmailController,
              style: Theme.of(context).textTheme.headline3,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.emailAddress,
            ),
            Divider(
              color: Color(figmaColours.greyLight),
              thickness: 1,
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Password",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
            TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 16), // add padding to adjust text
                  isDense: true,
                  fillColor: Colors.black,
                  suffixIcon: IconButton(
                      color: Color(figmaColours.greyLight),
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
              enableSuggestions: false,
              style: Theme.of(context).textTheme.headline3,
            ),
            Divider(
              color: Color(figmaColours.greyLight),
              thickness: 1,
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(top : 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text(
                      "Forgot your password?",
                      style: TextStyle(
                        color: Color(figmaColours.highlight),
                        fontSize: 16
                      ),
                    ),
                    ///Todo forgot password
                    onPressed: () {},
                  )
                ],
              ),
            ),
            (error != '')? Padding(
              padding: const EdgeInsets.only(top : 15),
              child: Text(
                error,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 16
                ),
              ),
            ) : Container(),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text(
                    "Don't have an account yet? Sign up",
                    style: TextStyle(
                        color: Color(figmaColours.highlight),
                        fontSize: 16
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _pageState = PageState.SignUpName;
                    });
                  },
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: SizedBox(
                    width: double.infinity,
                    child: GradientButton(
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
                        'Log In',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      gradient: ColorHelper.getBeaconGradient(),
                    )),
              ),
            ),
          ]),
    );
  }

  Widget _signUpEmail(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthPadding),
      child: Column(
          key: ValueKey("signUpEmail"),
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "What's your email?",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24
                ),
              ),
            ),
            ///being lazy and can't be bothered sizing it with the set password
            ///so just blank string
            Padding(
              padding: const EdgeInsets.only(bottom: 35.0),
              child: Text(
                "                                                   ",
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Email",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 10), // add padding to adjust text
                  fillColor: Colors.black,
              ),
              autofocus: true,
              controller: signUpEmailController,
              style: Theme.of(context).textTheme.headline3,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.emailAddress,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Divider(
                color: Color(figmaColours.greyLight),
                thickness: 1,
                height: 1,
              ),
            ),
            (signUpError != '')? Padding(
              padding: const EdgeInsets.only(top : 15),
              child: Text(
                signUpError,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 16
                ),
              ),
            ) : Container(),
            Spacer(flex: 7,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  child: GradientButton(
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
                      'Continue',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    gradient: ColorHelper.getBeaconGradient(),
                  ),
                ),
              ),
            )
          ]),
    );
  }

  Widget _signUpPassword(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthPadding),
      child: Column(
          key: ValueKey("signUpPassword"),
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "Set a password",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 35.0),
              child: Text(
                "Your password should be at least 6 characters long",
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Password",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 16), // add padding to adjust text
                  isDense: true,
                fillColor: Colors.black,
                  suffixIcon: IconButton(
                      color: Color(figmaColours.greyLight),
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
              enableSuggestions: false,
              onChanged: (value) {
                setState(() {
                  if(value.length >= 6) {
                    signUpPasswordCondition = true;
                  } else {
                    signUpPasswordCondition = false;
                  }
                });
              },
              style: Theme.of(context).textTheme.headline3,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Divider(
                color: Color(figmaColours.greyLight),
                thickness: 1,
                height: 1,
              ),
            ),
            Spacer(flex: 7,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  child: GradientButton(
                    onPressed: signUpPasswordCondition? () {
                      setState(() {
                        _pageState = PageState.SignUpEmail;
                      });
                    }: null,
                      child: Text(
                        'Continue',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      gradient: ColorHelper.getBeaconGradient(),
                  ),
                ),
              ),
            ),

          ]),
    );
  }

  Widget _signUpName(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthPadding),
      child: Column(
          key: ValueKey("signUpName"),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 35),
              child: Center(
                child: Text(
                  "What's your name?",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24
                  ),
                ),
              ),
            ),
            Text(
              "First Name",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 10),
                fillColor: Colors.black
              ),
              onChanged: (value) {
                setState(() {checkSignUpNameCondition();});
              },
              // onSubmitted: (bla) => FocusScope.of(context).requestFocus(firstNameFocus),
              style: Theme.of(context).textTheme.headline3,
              autofocus: true,
              controller: firstNameController,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,
              enableSuggestions: false,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Divider(
                color: Color(figmaColours.greyLight),
                thickness: 1,
                height: 1,
              ),
            ),
            Text(
              "Last Name",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 10),
                  fillColor: Colors.black
              ),
              onChanged: (value) {
                setState(() {checkSignUpNameCondition();});
                },
              autocorrect: false,
              enableSuggestions: false,
              style: Theme.of(context).textTheme.headline3,
              // focusNode: firstNameFocus,
              controller: lastNameController,
              textCapitalization: TextCapitalization.words,
            ),
            Divider(
              color: Color(figmaColours.greyLight),
              thickness: 1,
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: RichText(
                text: TextSpan(
                  text: 'By tapping "Sign up & Accept", you acknowledge that you have read the ',
                  style: Theme.of(context).textTheme.bodyText1,
                  children: [
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: Color(figmaColours.highlight),
                        fontSize: 16,
                        // decoration: TextDecoration.underline
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) {
                            return TextSheet(
                              title: "Privacy policy",
                              body: PrivacyPolicyText().privacyPolicy,
                            );
                          },
                        );
                      }
                    ),
                    TextSpan(
                      text: " and agree to the ",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    TextSpan(
                        text: 'Terms of service.',
                        style: TextStyle(
                          color: Color(figmaColours.highlight),
                          fontSize: 16,
                          // decoration: TextDecoration.underline
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (context) {
                              return TextSheet(
                                title: "Terms of service",
                                body: TermsOfServiceText().termsOfService,
                              );
                            },
                          );
                        }
                    ),
                  ]
                )
              ),
            ),
            signUpNameTooLong? Padding(
              padding: const EdgeInsets.only(top : 15),
              child: Text(
                'First and last names must be less then 20 characters',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16
                ),
              ),
            ) : Container(),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  child: GradientButton(
                    onPressed: signUpNameCondition? () {
                      setState(() {
                        _pageState = PageState.SignUpPassword;
                      });
                    } : null,
                    child: Text(
                      'Sign up & accept',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    gradient: ColorHelper.getBeaconGradient(),
                  ),
                ),
              ),
            )
          ]),
    );
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
          _pageState = PageState.SignUpPassword;
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
          _pageState = PageState.SignUpName;
        });
        break;
      case PageState.SignUpName:
        setState(() {
          _pageState = PageState.InitialSelector;
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
                  ? Text("")
                  : Text(""),
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
