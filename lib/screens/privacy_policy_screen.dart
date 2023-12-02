import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(backgroundColor: Colors.orange, title: Text("Privacy Policy")),
      backgroundColor: Colors.white,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
              child: Text(
            "Privacy Policy for Blink",
            style: GoogleFonts.lato(fontSize: 30, fontWeight: FontWeight.bold),
          )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              "Thank you for using Blink! This Privacy Policy is designed to help you understand how we collect, use, and safeguard your personal information.",
              style: GoogleFonts.lato(fontSize: 15)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("1. Information We Collect",
              style: GoogleFonts.lato(fontSize: 20)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
              "Account Information: When you create an account, we collect information such as your name and email address.",
              style: GoogleFonts.lato(fontSize: 15)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
              "Order Information: We collect details about your food orders, including the items you've ordered, delivery address, and payment information.",
              style: GoogleFonts.lato(fontSize: 15)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
              "Location Data: If you enable location services, we collect your device's location to provide you with relevant services, such as finding nearby restaurants.",
              style: GoogleFonts.lato(fontSize: 15)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
              "Usage Data: We collect information about how you interact with the app, such as the pages you visit and the features you use. This helps us improve our services.",
              style: GoogleFonts.lato(fontSize: 15)),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text("2. How We Use Your Information",
              style: GoogleFonts.lato(fontSize: 20)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
              "Order Fulfillment: To process and deliver your food orders.",
              style: GoogleFonts.lato(fontSize: 15)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
              "Improving Services: To analyze usage patterns and enhance our app's features and functionality.",
              style: GoogleFonts.lato(fontSize: 15)),
        ),
      ]),
    );
  }
}
