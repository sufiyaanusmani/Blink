import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/screens/create_new_account_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:food_delivery/services/navigator.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:food_delivery/components/plain_text_field.dart';
import 'package:food_delivery/components/password_text_field.dart';
import 'package:food_delivery/components/large_button.dart';
import 'package:food_delivery/components/bottom_container.dart';
import 'package:food_delivery/mysql.dart';
import 'package:food_delivery/user1.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:food_delivery/classes/restaurant.dart';
import 'package:food_delivery/arguments/home_screen_arguments.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_button/sign_in_button.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  LoginScreen({super.key});

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
        'SELECT * FROM Customer C INNER JOIN Account A ON (C.username = A.username) WHERE C.username="$username" AND A.password="$password";');
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

  void getRestaurants() async {
    Iterable<ResultSetRow> rows = await db
        .getResults('SELECT restaurant_id, name, owner_name FROM Restaurant;');
    for (var row in rows) {
      restaurants.add(Restaurant(
          restaurantID: int.parse(row.assoc()['restaurant_id']!),
          name: row.assoc()['name']!,
          ownerName: row.assoc()['owner_name']!));
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
    email = signPrefs.get('username');
    return email;
  }

  Future<String> getPassword() async {
    SharedPreferences signPrefs = await SharedPreferences.getInstance();
    password = signPrefs.get('password');
    return password;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
    // getSharedPreferences();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _usernameTextController.text = await getUsername();
      _passwordTextController.text = await getPassword();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff1eff6),
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
                        hintText: 'Enter Email',
                        onChange: (text) {
                          email = text;
                        },
                        labelText: 'Email',
                        controller: _usernameTextController,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      PasswordTextField(
                        hintText: 'Enter Password',
                        onChange: (text) {
                          password = text;
                        },
                        controller: _passwordTextController,
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
                          // if (await _login(username, password)) {
                          //   setState(() {
                          //     loginFailedMessage = '';
                          //   });
                          //   final SharedPreferences prefs =
                          //       await SharedPreferences.getInstance();
                          //   await prefs.setString('username', username);
                          //   await prefs.setString('password', password);
                          //   getRestaurants();
                          //   Navigator.pushNamed(context, MainNavigator.id,
                          //       arguments: HomeScreenArguments(
                          //         user:
                          //             User1(id: loginID, firstName: firstName),
                          //         restaurants: restaurants,
                          //       ));
                          // } else {
                          //   setState(
                          //     () {
                          //       loginFailedMessage =
                          //           'Invalid username or password';
                          //     },
                          //   );
                          // }
                          try {
                            final user = await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                            if (user != null) {
                              getRestaurants();
                              Navigator.pushNamed(context, MainNavigator.id,
                                  arguments: HomeScreenArguments(
                                    user: User1(id: 1, firstName: "Sufiyaan"),
                                    restaurants: restaurants,
                                  ));
                            }
                          } catch (e) {
                            print(e);
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
                            "or",
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CreateNewAccountScreen()));
                        },
                        color: Colors.white,
                        verticalPadding: 10,
                        buttonChild: Text(
                          'Create a new account',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      LargeButton(
                          color: Colors.white,
                          buttonChild: Text("Sign in with Google"),
                          verticalPadding: 10,
                          onPressed: () {
                            _handleGoogleSignIn();
                          })
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
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(_googleAuthProvider);
    } catch (error) {
      print(error);
    }
  }
}
