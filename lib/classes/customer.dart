import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Customer {
  String uid = "";
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final _firestore = FirebaseFirestore.instance;

  /// Constructor for [Customer]
  ///
  /// Parameters:
  ///   - firstName: [String]
  ///   - lastName: [String]
  ///   - email: [String]
  ///   - password: [String]
  ///   - uid: [String]
  ///
  /// Example:
  /// ```dart
  /// // Usage example of the function.
  /// Customer obj = Customer(firstName, lastName, email, password, uid);
  /// ```
  Customer(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      this.uid = ""});

  /// Helper function for [registerUser] function
  ///
  /// This function inserts a new document in [customers] collection
  ///
  /// Parameters:
  ///   - uid: [String]
  ///   - firstName: [String]
  ///   - lastName: [String]
  ///
  /// Example:
  /// ```dart
  /// // Usage example of the function.
  /// customer._createUser(uid, firstName, lastName);
  /// ```
  Future<void> _createUser(
      String uid, String firstName, String lastName) async {
    await _firestore
        .collection("customers")
        .doc(uid)
        .set({"firstname": firstName, "lastname": lastName});
  }

  /// Registers a new user in Firebase Authentication
  ///
  /// Parameters:
  ///   - email: [String]
  ///   - password: [String]
  ///   - firstName: [String]
  ///   - lastName: [String]
  ///
  /// Example:
  /// ```dart
  /// // Usage example of the function.
  /// customer.registerUser(email, password, firstName, lastName);
  /// ```
  Future<void> registerUser(
      String email, String password, String firstName, String lastName) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      final UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _createUser(result.user!.uid, firstName, lastName);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
