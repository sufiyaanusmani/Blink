import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  String uid = "";
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final _firestore = FirebaseFirestore.instance;

  Customer(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      this.uid = ""});

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
