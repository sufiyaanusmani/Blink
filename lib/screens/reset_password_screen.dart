import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    String password1 = "";
    String password2 = "";
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reset Password',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter New Password',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            PasswordTextField(
              hintText: 'New Password',
              onChange: (text) {
                setState(() {
                  password1 = text;
                });
              },
            ),
            SizedBox(height: 20.0),
            PasswordTextField(
              hintText: 'Confirm Password',
              onChange: (text) {
                password2 = text;
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                // Add logic to update the password
                // This is where you would call a backend service to update the password
                // For demonstration purposes, we'll just navigate back to the login screen
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Set Password',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final String hintText;
  final Function(String) onChange;
  final TextEditingController? controller;
  final String? errorText;

  PasswordTextField({
    required this.hintText,
    required this.onChange,
    this.controller,
    this.errorText,
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
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            width: 0.5,
            color: widget.errorText != null ? Colors.red : Colors.transparent,
          ),
        ),
        child: TextField(
          obscureText: _obscureText,
          onChanged: widget.onChange,
          controller: widget.controller,
          style: TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: "Password",
            labelStyle: TextStyle(
              color: Colors.black.withOpacity(0.5),
            ),
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
            errorText: widget.errorText,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
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
