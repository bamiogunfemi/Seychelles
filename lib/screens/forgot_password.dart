import 'package:flutter/material.dart';
import 'package:grantconsent/screens/get_started_screen.dart';
import 'package:grantconsent/utilities/constants.dart';
import 'package:grantconsent/services/firebase_forgot_password.dart';
import 'package:grantconsent/utilities/custom_widgets.dart';
import 'package:grantconsent/utilities/styles.dart';

class ForgotPassword extends StatelessWidget {
  final TextEditingController inputEmail = TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    kScreenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: kGetStartedScreenBackground,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Color.fromRGBO(34, 34, 34, 0.2), BlendMode.overlay),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 38),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Spacer(
                flex: 9,
              ),
              Text(
                'Forgot',
                style: kWelcomeHeadingTextStyle,
              ),
              Text(
                'Password',
                style: kWelcomeHeadingTextStyle,
              ),
              Spacer(
                flex: 2,
              ),
              Text(
                'Enter email address below to retrieve your password.',
                style: kBody1TextStyle.copyWith(color: Colors.white),
              ),
              Spacer(
                flex: 2,
              ),
              CustomTextFormField(
                controller: inputEmail,
                hintText: "Email Address",
                textInputType: TextInputType.emailAddress,
              ),
              Spacer(
                flex: 17,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: UserActionButton(
                  onTap: () async {
                    if (inputEmail.text == "") {
                      scaffoldKey.currentState.showSnackBar(
                        customSnackBar(message: 'Please enter your email.'),
                      );
                    } else {
                      await forgotPassword(inputEmail.text);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          actions: <Widget>[
                            AppIconButton(onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  maintainState: true,
                                  builder: (context) => GetStarted(),
                                ),
                              );
                            })
                          ],
                          title: Text(
                            'Retrieve Password',
                            style: kWelcomeHeadingTextStyle,
                          ),
                          content: Container(
                            child: Text(
                                'Please click the link the email sent to you to retrieve password.'),
                          ),
                        ),
                      );
                    }
                  },
                  label: 'Retrieve Password',
                  filled: true,
                ),
              ),
              Spacer(
                flex: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
