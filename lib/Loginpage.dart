import 'package:flutter/material.dart';
import 'package:hcd_project2/admin/admin_login_page.dart';
import 'package:hcd_project2/client/client_login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welson App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color appBarColor = Color(0xFF8e2de2);
    Color textColor = Colors.white;
    Color buttonColor = Color(0xFF8e2de2);

    // Applying media query to get device width
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: buttonColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: deviceWidth > 600 ? 30 : 60,
              ),
              child: Text(
                'Welson®',
                style: TextStyle(
                  fontSize: deviceWidth > 600 ? 40 : 60,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: deviceWidth > 600 ? 20 : 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLoginPage()),
                );
              },
              child: Text(
                'Admin Login',
                style: TextStyle(fontSize: deviceWidth > 600 ? 14 : 18, color: textColor),
              ),
              style: ElevatedButton.styleFrom(
                primary: buttonColor,
                padding: EdgeInsets.symmetric(
                  horizontal: deviceWidth > 600 ? 30 : 50,
                  vertical: deviceWidth > 600 ? 20 : 25,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: deviceWidth > 600 ? 15 : 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClientLoginPage()),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 10),
                  Text(
                    'Client Login',
                    style: TextStyle(fontSize: deviceWidth > 600 ? 14 : 18, color: textColor),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: buttonColor,
                padding: EdgeInsets.symmetric(
                  horizontal: deviceWidth > 600 ? 30 : 50,
                  vertical: deviceWidth > 600 ? 20 : 25,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
