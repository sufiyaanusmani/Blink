import 'package:food_delivery/firebase_services.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mysql_client/mysql_client.dart';

class EmailSender {
  static const String email = "suffiyaanusmani@gmail.com";
  static const String password = "ksfuybxbaqqzgqxd";

  void sendEmail(String orderID) async {
    // var db = FirebaseServices();
    // Iterable<ResultSetRow> rows = await db.getResults(
    //     ' select O.order_id, O.price, C.first_name, C.last_name, R.name, C.email from Orders O INNER JOIN Customer C ON (O.customer_id=C.customer_id) INNER JOIN Restaurant R ON (O.restaurant_id = R.restaurant_id) WHERE O.order_id=$orderID;');
    // int price = 0;
    // String firstName, lastName, restaurantName, recipientEmail;
    // firstName = lastName = restaurantName = recipientEmail = "";
    // if (rows.isNotEmpty) {
    //   for (var row in rows) {
    //     price = int.parse(row.assoc()['price']!);
    //     firstName = row.assoc()['first_name']!;
    //     lastName = row.assoc()['last_name']!;
    //     restaurantName = row.assoc()['name']!;
    //     recipientEmail = row.assoc()['email']!;
    //     break;
    //   }
    //
    //   sendMail(
    //       orderID, firstName, lastName, price, restaurantName, recipientEmail);
    // }
  }

  void sendMail(String orderID, String firstName, String lastName, int price,
      String restaurantName, String recipientEmail) async {
    final smtpServer = gmail(email, password);
    final message = Message()
      ..from = Address(email, 'Blink')
      ..recipients.add(recipientEmail)
      ..subject = '#$orderID - Thank You for your Order'
      ..html =
          "<h1>Order Confirmation</h1>\n<p>Dear $firstName $lastName</p><p>Thank you for placing an order. Your order details are as follows:</p><p>Order ID: $orderID</p><p>Restaurant Name: $restaurantName</p><p>Price: Rs. $price</p><p>Time: ${DateTime.now()}</p><p>&copy; 2023 Blink. All rights reserved.</p>";

    try {
      final sendReport = await send(message, smtpServer);
    } on MailerException catch (e) {
      print("Message not sent");
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  static void sendResetPasswordCode(String email, String code) async {
    final smtpServer = gmail(email, password);
    final message = Message()
      ..from = Address(email, 'Blink')
      ..recipients.add(email)
      ..subject = 'Blink - Password Reset Code'
      ..html =
          "<h1>Dear Blink User,</h1>\n<p>You have requested to reset your password. Below is your password reset code:</p><strong>$code</strong></string><p>Please enter this code in the app to proceed with the password reset. If you did not request this, you can safely ignore this email.</p><p>&copy; 2023 Blink. All rights reserved.</p>";

    try {
      final sendReport = await send(message, smtpServer);
    } on MailerException catch (e) {
      print("Message not sent");
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
