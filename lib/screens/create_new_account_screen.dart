import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:food_delivery/services/navigator.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:food_delivery/components/plain_text_field.dart';
import 'package:food_delivery/components/password_text_field.dart';
import 'package:food_delivery/components/large_button.dart';
import 'package:food_delivery/components/bottom_container.dart';
import 'package:food_delivery/mysql.dart';
import 'package:food_delivery/user.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:food_delivery/classes/restaurant.dart';
import 'package:food_delivery/arguments/home_screen_arguments.dart';
import 'package:food_delivery/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateNewAccountScreen extends StatefulWidget {
  static const id = 'create_new_account_screen';

  CreateNewAccountScreen({super.key});

  @override
  State<CreateNewAccountScreen> createState() => _CreateNewAccountScreenState();
}

class _CreateNewAccountScreenState extends State<CreateNewAccountScreen> {
  var username = '';
  List<Restaurant> restaurants = [];
  var password = '';
  bool loginValid = true;
  String loginFailedMessage = '';
  late int loginID;
  late String firstName = '';
  late String lastName = '';
  late String email = '';

  Widget buildBottomSheet(BuildContext context) {
    return BottomContainer();
  }

  var db = Mysql();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getSharedPreferences();
  }

  bool isValidUsername(String value) {
    final validCharacters = RegExp(r'^[a-zA-Z][a-zA-Z0-9.]*[a-zA-Z0-9]$');

    return validCharacters.hasMatch(value);
  }

  bool isValidName(String value) {
    final validCharacters = RegExp(r'^[a-zA-Z ]+$');
    return validCharacters.hasMatch(value);
  }

  bool isValidEmail(String value) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(value);
  }

  bool isValidPassword(String value) {
    return value.length >= 8 && // Minimum length requirement
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+{}|":;<>,.?/~`]).*$')
            .hasMatch(value); // Complex password requirements
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
                      'Create New Account',
                      textAlign: TextAlign.center,
                      textStyle: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                PlainTextField(
                  hintText: 'Enter Username',
                  onChange: (text) {
                    username = text;
                  },
                  labelText: 'Username',
                  controller: TextEditingController(),
                ),
                SizedBox(
                  height: 15,
                ),
                PlainTextField(
                  hintText: 'First Name',
                  onChange: (text) {
                    firstName = text;
                  },
                  labelText: 'First Name',
                  controller: TextEditingController(),
                ),
                SizedBox(
                  height: 15,
                ),
                PlainTextField(
                  hintText: 'Last Name',
                  onChange: (text) {
                    lastName = text;
                  },
                  labelText: 'Last Name',
                  controller: TextEditingController(),
                ),
                SizedBox(
                  height: 15,
                ),
                PlainTextField(
                  hintText: 'Email',
                  onChange: (text) {
                    email = text;
                  },
                  labelText: 'Email',
                  controller: TextEditingController(),
                ),
                SizedBox(
                  height: 15,
                ),
                PasswordTextField(
                  hintText: 'Enter Password',
                  onChange: (text) {
                    password = text;
                  },
                  controller: TextEditingController(),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  loginFailedMessage,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.red,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                LargeButton(
                  onPressed: () async {
                    if (username == '' ||
                        firstName == '' ||
                        lastName == '' ||
                        email == '' ||
                        password == '') {
                      setState(() {
                        loginFailedMessage = 'Enter all fields';
                      });
                    } else if (!isValidUsername(username)) {
                      setState(() {
                        loginFailedMessage = 'Invalid Username Format';
                      });
                    } else if (!isValidName(firstName)) {
                      setState(() {
                        loginFailedMessage = 'Invalid First Name Format';
                      });
                    } else if (!isValidName(lastName)) {
                      setState(() {
                        loginFailedMessage = 'Invalid Name Format';
                      });
                    } else if (!isValidEmail(email)) {
                      setState(() {
                        loginFailedMessage = 'Invalid Email Format';
                      });
                    } else if (!isValidPassword(password)) {
                      setState(() {
                        loginFailedMessage = 'Invalid Password Format';
                      });
                    } else {
                      setState(() {
                        loginFailedMessage = '';
                      });
                      int customerID = await db.createNewAccount(
                          firstName, lastName, email, username, password);
                      if (customerID == -1) {
                        setState(() {
                          loginFailedMessage = 'Account already exists';
                        });
                      } else {
                        setState(() {
                          loginFailedMessage = '';
                          username = '';
                          firstName = '';
                          lastName = '';
                          email = '';
                          password = '';
                        });
                        Navigator.pop(context);
                      }
                    }
                  },
                  color: Colors.lightBlue,
                  verticalPadding: 15,
                  buttonChild: Text(
                    'Register',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
