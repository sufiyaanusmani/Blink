import 'package:flutter/material.dart';
import 'package:food_delivery/screens/create_new_account_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:food_delivery/components/plain_text_field.dart';
import 'package:food_delivery/components/large_button.dart';
import 'package:food_delivery/components/bottom_container.dart';
import 'package:food_delivery/mysql.dart';
import 'package:food_delivery/user1.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:food_delivery/classes/restaurant.dart';
import 'package:food_delivery/arguments/home_screen_arguments.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery/classes/UIColor.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/navigator.dart';

class PasswordTextField extends StatefulWidget {
  final String hintText;
  final bool error;
  final Function(String) onChange;
  final TextEditingController? controller;
  final String? errorText; // Add errorText parameter

  PasswordTextField({
    required this.hintText,
    required this.onChange,
    required this.error,
    this.controller,
    this.errorText, // Initialize errorText parameter
  });

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: ui.val(2),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: ui.val(1).withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              width: 0.5,
              color: widget.error == true ? Colors.red : Colors.transparent),
        ),
        child: TextField(
          obscureText: _obscureText,
          onChanged: widget.onChange,
          controller: widget.controller,
          style: TextStyle(
            color: ui.val(4),
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: "Password",
            labelStyle: TextStyle(
              color: ui.val(4).withOpacity(0.5),
            ),
            hintText: widget.hintText,
            hintStyle:
                TextStyle(color: ui.val(4).withOpacity(0.5)), // Hint text color
            errorText: widget.errorText, // Set error text
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: ui.val(3),
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  var email;
  List<Restaurant> restaurants = [];
  var password;
  bool loginValid = true;
  String loginFailedMessage = '';
  late int loginID;
  late String firstName;
  bool _isLoadingGoogle = false;
  bool _isLoadingSignIn = false;

  Widget buildBottomSheet(BuildContext context) {
    return BottomContainer();
  }

  var db = Mysql();

  Future<bool> _login(String username, String password) async {
    Iterable<ResultSetRow> rows = await db.getResults(
        'SELECT * FROM Customer C INNER JOIN Account A ON (C.username = A.username) WHERE C.username="$username" AND A.password="$password";');
    if (rows.length == 1) {
      for (var row in rows) {
        loginID = int.parse(row.assoc()['customer_id']!);
        firstName = row.assoc()['first_name']!;
      }
      return true;
    } else {
      setState(() {
        loginFailedMessage = 'Email or password incorrect'; // Set error message
      });
      return false;
    }
  }

  void getRestaurants() async {
    Iterable<ResultSetRow> rows = await db
        .getResults('SELECT restaurant_id, name, owner_name FROM Restaurant;');
    for (var row in rows) {
      restaurants.add(Restaurant(
          restaurantID: "1",
          name: row.assoc()['name']!,
          ownerName: row.assoc()['owner_name']!,
          rating: "5",
          totalRatings: "69",
          description: "hello",
          estimatedTime: "420 mins"));
    }
  }

  TextEditingController _usernameTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  void getSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('username')!;
      password = prefs.getString('password')!;
    });
  }

  Future<String> getUsername() async {
    SharedPreferences signPrefs = await SharedPreferences.getInstance();
    email = signPrefs.getString('username') ??
        ''; // Provide a default value if null
    return email;
  }

  Future<String> getPassword() async {
    SharedPreferences signPrefs = await SharedPreferences.getInstance();
    password = signPrefs.getString('password') ??
        ''; // Provide a default value if null
    return password;
  }

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _usernameTextController.text = await getUsername();
      _passwordTextController.text = await getPassword();
    });
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
      body: _user == null
          ? SafeArea(
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
                                color: ui.val(4),
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
                            color: ui.val(4),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      PlainTextField(
                        hintText: 'Enter Email',
                        onChange: (text) {
                          email = text;
                        },
                        labelText: 'Email',
                        controller: _usernameTextController,
                        errorText: loginFailedMessage.isNotEmpty
                            ? loginFailedMessage
                            : null, // Pass error message
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      PasswordTextField(
                        error: loginFailedMessage.isNotEmpty ? true : false,
                        hintText: 'Enter Password',
                        onChange: (text) {
                          password = text;
                        },
                        controller: _passwordTextController,
                        errorText: null,
                      ),
                      SizedBox(
                        height: 20,
                        child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            loginFailedMessage.isNotEmpty
                                ? loginFailedMessage
                                : "",
                            style:
                                TextStyle(color: Colors.red.withOpacity(0.7)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              child: Text(
                                'Create new Account',
                                textAlign: TextAlign.end,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: ui.val(4).withOpacity(0.5),
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CreateNewAccountScreen()));
                              },
                            ),
                            GestureDetector(
                              child: Text(
                                'Forgot Password',
                                textAlign: TextAlign.end,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: ui.val(4).withOpacity(0.3),
                                  ),
                                ),
                              ),
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: buildBottomSheet);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      LargeButton(
                        onPressed: () async {
                          setState(() {
                            _isLoadingSignIn = true;
                          });
                          try {
                            final user = await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                            if (user != null) {
                              getRestaurants();
                              Navigator.pushNamed(context, MainNavigator.id,
                                  arguments: HomeScreenArguments(
                                    user: User1(id: 1, firstName: "Sufiyaan"),
                                    restaurants: restaurants,
                                  ),);
                            }
                          } catch (e) {
                            print(e);
                            setState(() {
                              loginFailedMessage =
                                  'Email or password incorrect'; // Set error message
                            });
                          } finally {
                            setState(() {
                              _isLoadingSignIn = false;
                            });
                          }
                        },
                        color: ui.val(10),
                        verticalPadding: 15,
                        buttonChild: _isLoadingSignIn
                            ? SizedBox(
                                height: 23,
                                width: 23,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Sign In',
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
                      SizedBox(
                        height: 20,
                      ),
                      LargeButton(
                        color: ui.val(1).withOpacity(0.3),
                        verticalPadding: 10,
                        onPressed: () {
                          setState(() {
                            _isLoadingGoogle = true;
                          });
                          _handleGoogleSignIn();
                        },
                        buttonChild: _isLoadingGoogle
                            ? SizedBox(
                                height: 40,
                                width: 40,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : Image.asset(
                                'images/google.png',
                                height: 40,
                                color: ui.val(4).withOpacity(0.5),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : h(),
    );
  }

  Widget h() {
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("${_user?.uid}"),
        MaterialButton(
            child: Text("Sign Out"),
            onPressed: () {
              _auth.signOut();
            })
      ],
    ));
  }

  void _handleGoogleSignIn() {
    try {
      // Implement your Google sign-in logic here
      // For example:
      // GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      // _auth.signInWithProvider(_googleAuthProvider);
      // Set a delay to simulate the Google sign-in process
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isLoadingGoogle = false;
        });
        // After sign-in, redirect to Google
        // For demonstration, navigate back to the login screen after a short delay
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context); // Close the login screen
          // Navigate to Google or handle redirection as required
          // Example:
          // Navigator.push(context, MaterialPageRoute(builder: (context) => GoogleScreen()));
        });
      });
    } catch (error) {
      print(error);
    }
  }
}
