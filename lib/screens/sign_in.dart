import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grantconsent/screens/forgot_password.dart';
import 'package:grantconsent/screens/loader.dart';
import 'package:grantconsent/screens/sign_up.dart';
import 'package:grantconsent/screens/test_screen_2.dart';
import 'package:grantconsent/services/firebase_sign_in.dart';
import 'package:grantconsent/utilities/constants.dart';
import 'package:grantconsent/utilities/custom_classes.dart';
import 'package:grantconsent/utilities/custom_widgets.dart';
import 'package:grantconsent/utilities/styles.dart';

class SignIn extends StatelessWidget {
  final TextEditingController inputEmail = TextEditingController();
  final TextEditingController inputPassword = TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints.tight(kScreenSize),
          padding: EdgeInsets.symmetric(horizontal: 38),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Spacer(flex: 3),
              GrantConsentLogo(LogoType.mediumWithText),
              Spacer(flex: 6),
              CustomTextFormField(
                controller: inputEmail,
                hintText: "Email Address",
                textInputType: TextInputType.emailAddress,
              ),
              SizedBox(height: 5),
              CustomTextFormField(
                  controller: inputPassword,
                  obscure: true,
                  hintText: "Password"),
              SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedCheckBox(),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'remember me',
                      style: TextStyle(color: kButtonTextColor2),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword()));
                    },
                    child: Text(
                      'forgot password?',
                      style: TextStyle(color: kButtonTextColor2),
                    ),
                  ),
                ],
              ),
              Spacer(flex: 2),
              UserActionButton(
                  onTap: () {
                    _signIn(context);
                  },
                  label: 'Sign In',
                  filled: true),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(child: Text("OR", style: kOrTextStyle)),
              ),
              UserGoogleButton(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignIn()));
                },
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0, top: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Don\'t have an account? ',
                      style: TextStyle(color: kButtonTextColor2, fontSize: 13),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _signIn(BuildContext context) async {
    final bool isValid = EmailValidator.validate(inputEmail.text);
    if (!isValid) {
      //If email is empty
      scaffoldKey.currentState.showSnackBar(
        customSnackBar(message: 'Invalid Email'),
      );
    } else if (inputPassword.text == "") {
      //If password is empty
      scaffoldKey.currentState.showSnackBar(
        customSnackBar(message: 'Enter Password'),
      );
    } else {
      showDialog(context: context, builder: (context) => Loader());
      ConsentUserSignIn email = ConsentUserSignIn(email: inputEmail.text);
      SignInStatus operationStatus =
          await signInUser(newUser: email, password: inputPassword.text);
      var user = await FirebaseAuth.instance.currentUser();
      Navigator.pop(context);
      if (operationStatus == SignInStatus.success) {
        if (user.isEmailVerified) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => TestScreen2()));
        } else {
          scaffoldKey.currentState.showSnackBar(
            customSnackBar(message: 'Please verify your email.'),
          );
        }
      } else {
        _handleExceptions(operationStatus); //If sign in was NOT successful
      }
    }
  }

  void _handleExceptions(SignInStatus operationStatus) {
    if (operationStatus == SignInStatus.invalidEmail) {
      //If sign in was NOT successful - EMAIL IS INVALID
      scaffoldKey.currentState.showSnackBar(
        customSnackBar(
            message: 'You have entered an invalid email. Please try again',
            durationInSeconds: 3),
      );
    } else if (operationStatus == SignInStatus.userNotFound) {
      //If sign in was NOT successful - INVALID EMAIL ENTERED
      scaffoldKey.currentState.showSnackBar(
        customSnackBar(
            message:
                'This email does NOT have an account. Please Sign Up instead',
            durationInSeconds: 3),
      );
    } else if (operationStatus == SignInStatus.wrongPassword) {
      //If sign in was NOT successful - USER ALREADY EXISTS
      scaffoldKey.currentState.showSnackBar(
        customSnackBar(
            message: 'You have entered a wrong password', durationInSeconds: 3),
      );
    } else if (operationStatus == SignInStatus.unknownException) {
      //If sign in was NOT successful - UNKNOWN ERROR OCCURED
      scaffoldKey.currentState.showSnackBar(
        customSnackBar(
            message: 'An unknown error occured. Try again',
            durationInSeconds: 3),
      );
    }
  }
}

class SizedCheckBox extends StatefulWidget {
  @override
  _SizedCheckBoxState createState() => _SizedCheckBoxState();
}

class _SizedCheckBoxState extends State<SizedCheckBox> {
  bool checkBoxValue = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      width: 9,
      child: Checkbox(
          value: checkBoxValue,
          activeColor: kButtonTextColor2,
          onChanged: (bool newValue) {
            setState(() {
              checkBoxValue = newValue;
            });
          }),
    );
  }
}
