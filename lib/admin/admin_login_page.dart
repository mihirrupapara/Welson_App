import 'package:flutter/material.dart';
import 'admin_dashboard_page.dart'; // Import the admin dashboard page

void main() async {
  runApp(MaterialApp(
    home: AdminLoginPage(),
  ));
}

class AdminLoginPage extends StatefulWidget {
  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  OutlineInputBorder _defaultBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey[700]!),
    );
  }

  OutlineInputBorder _focusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Color(0xFF8e2de2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Applying media query to get device width
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Login'),
        backgroundColor: Color(0xFF8e2de2),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Container(
              width: deviceWidth > 500 ? 500 : deviceWidth - 32,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter Email',
                      prefixIcon: const Icon(Icons.email),
                      border: _defaultBorder(),
                      focusedBorder: _focusedBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter email';
                      } else if (!value.contains('@gmail.com')) {
                        return 'Please enter a valid Email address';
                      }
                      return null;
                    },
                    focusNode: _emailFocusNode,
                    onTap: () {
                      setState(() {
                        _emailFocusNode.requestFocus();
                        _passwordFocusNode.unfocus();
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: _defaultBorder(),
                      focusedBorder: _focusedBorder(),
                    ),
                    obscureText: _obscurePassword,
                    validator: (value) {
                      return value!.isEmpty ? 'Please enter password' : null;
                    },
                    focusNode: _passwordFocusNode,
                    onTap: () {
                      setState(() {
                        _passwordFocusNode.requestFocus();
                        _emailFocusNode.unfocus();
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: deviceWidth > 500 ? 500 : deviceWidth - 32,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _performAdminLogin(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        primary: Color(0xFF8e2de2),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Center(
                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _performAdminLogin(BuildContext context) async {
    try {
      // Check if email and password match the allowed credentials
      if (_emailController.text == 'welson@gmail.com' && _passwordController.text == '111111') {
        // If credentials match, navigate to the admin dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboardPage()),
        );
      } else {
        // If credentials don't match, show an error dialog
        _showErrorDialog(context, 'Login Failed', 'Invalid email or password. Please try again.');
      }
    } catch (e) {
      // Handle any exceptions here
      print('Failed to sign in: $e');
      _showErrorDialog(context, 'Login Failed', 'Invalid email or password. Please try again.');
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
