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

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String username;

  late String password;
  bool loginValid = true;
  String loginFailedMessage = '';
  late int loginID;
  late String firstName;

  Widget buildBottomSheet(BuildContext context) {
    return BottomContainer();
  }

  var db = Mysql();

  Future<bool> _login(String username, String password) async {
    // var conn = await db.getConnection();
    // await conn.connect();
    // var results = await conn.execute(
    //     'SELECT * FROM Customer WHERE username="$username" AND password="$password";');
    // conn.close();
    Iterable<ResultSetRow> rows = await db.getResults(
        'SELECT * FROM Customer WHERE username="$username" AND password="$password";');
    if (rows.length == 1) {
      for (var row in rows) {
        loginID = int.parse(row.assoc()['customer_id']!);
        firstName = row.assoc()['first_name']!;
      }
      return true;
    } else {
      return false;
    }
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
                PlainTextField(
                  hintText: 'Enter Username',
                  onChange: (text) {
                    username = text;
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                PasswordTextField(
                  hintText: 'Enter Password',
                  onChange: (text) {
                    password = text;
                  },
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
                  onPressed: () async {
                    if (await _login(username, password)) {
                      setState(() {
                        loginFailedMessage = '';
                      });
                      Navigator.pushNamed(context, MainNavigator.id,
                          arguments: User(id: loginID, firstName: firstName));
                    } else {
                      setState(
                        () {
                          loginFailedMessage = 'Invalid username or password';
                        },
                      );
                    }
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
                  onPressed: () {},
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
