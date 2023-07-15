import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:food_delivery/services/navigator.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:food_delivery/components/plain_text_field.dart';
import 'package:food_delivery/components/password_text_field.dart';
import 'package:food_delivery/components/large_button.dart';
import 'package:food_delivery/components/bottom_container.dart';

class LoginScreen extends StatelessWidget {
  static const id = 'login_screen';
  const LoginScreen({super.key});

  Widget buildBottomSheet(BuildContext context) {
    return BottomContainer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff1eff6),
      body: SafeArea(
        child: Form(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Hello Again!',
                      textAlign: TextAlign.center,
                      textStyle: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Welcome back, you\'ve been missed',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                PlainTextField(hintText: 'Enter Username'),
                SizedBox(
                  height: 25,
                ),
                PasswordTextField(hintText: 'Enter Password'),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: Text(
                    'Forgot Password',
                    textAlign: TextAlign.end,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                        context: context, builder: buildBottomSheet);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                LargeButton(
                  onPressed: () {
                    Navigator.pushNamed(context, MainNavigator.id);
                  },
                  color: Colors.lightBlue,
                  verticalPadding: 15,
                  buttonChild: Text(
                    'Sign In',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "or continue with",
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Divider(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                LargeButton(
                  onPressed: () {
                    print('pressed');
                  },
                  color: Colors.white,
                  verticalPadding: 10,
                  buttonChild: Image.asset(
                    'images/google.png',
                    height: 40,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
