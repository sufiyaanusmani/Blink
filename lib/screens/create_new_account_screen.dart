import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:food_delivery/components/plain_text_field.dart';
import 'package:food_delivery/components/password_text_field.dart';
import 'package:food_delivery/components/large_button.dart';
import 'package:food_delivery/components/bottom_container.dart';
import 'package:food_delivery/firebase_services.dart';
import 'package:flutter/services.dart';
import '../classes/UiColor.dart';
import 'package:food_delivery/classes/restaurant.dart';

import '../classes/customer.dart';

class CreateNewAccountScreen extends StatefulWidget {
  static const id = 'create_new_account_screen';

  CreateNewAccountScreen({super.key});

  @override
  State<CreateNewAccountScreen> createState() => _CreateNewAccountScreenState();
}

class _CreateNewAccountScreenState extends State<CreateNewAccountScreen> {
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

  var db = FirebaseServices();

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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: ui.val(0),
      statusBarColor: ui.val(0),
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ui.val(0),
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
                          color: ui.val(4),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                PlainTextField2(
                  background: ui.val(3).withOpacity(0.1),
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
                PlainTextField2(
                  background: ui.val(2).withOpacity(0.1),
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
                PlainTextField2(
                  background: ui.val(0).withOpacity(0.1),
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
                    // if (firstName == '' ||
                    //     lastName == '' ||
                    //     email == '' ||
                    //     password == '') {
                    //   setState(() {
                    //     loginFailedMessage = 'Enter all fields';
                    //   });
                    // } else if (!isValidName(firstName)) {
                    //   setState(() {
                    //     loginFailedMessage = 'Invalid First Name Format';
                    //   });
                    // } else if (!isValidName(lastName)) {
                    //   setState(() {
                    //     loginFailedMessage = 'Invalid Name Format';
                    //   });
                    // } else if (!isValidEmail(email)) {
                    //   setState(() {
                    //     loginFailedMessage = 'Invalid Email Format';
                    //   });
                    // } else if (!isValidPassword(password)) {
                    //   setState(() {
                    //     loginFailedMessage = 'Invalid Password Format';
                    //   });
                    // } else {
                    setState(() {
                      loginFailedMessage = '';
                    });
                    Customer customer = Customer(
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        password: password);
                    customer.registerUser(email, password, firstName, lastName);
                    print(customer.uid);
                    // }
                  },
                  color: ui.val(10),
                  verticalPadding: 15,
                  buttonChild: Text(
                    'Register',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: ui.val(1),
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
