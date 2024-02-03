import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  String uid = "";
  late String firstName;
  late String lastName;
  late String email;
  late String password;
  final _firestore = FirebaseFirestore.instance;

  Customer(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      this.uid = ""});

  Customer.fromUser(User user) {
    _firestore
        .collection("customers")
        .doc(user.uid)
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      uid = user.uid;
      firstName = data["firstname"];
      lastName = data["lastname"];
      email = user.email!;
      password = "";
    });
  }

  Future<void> _createUser(
      String uid, String firstName, String lastName) async {
    await _firestore
        .collection("customers")
        .doc(uid)
        .set({"firstname": firstName, "lastname": lastName});
  }

  Future<void> registerUser(
      String email, String password, String firstName, String lastName) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result != null) {
        _createUser(result.user!.uid, firstName, lastName);
      }
    } catch (e) {
      print(e);
    }
  }
}
