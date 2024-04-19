import 'package:flutter/material.dart';
import 'package:hcd_project2/BrochurePage.dart';
import 'package:hcd_project2/client/clientprofilepage.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hcd_project2/placeorderpage.dart';
import 'package:hcd_project2/client/old_orders_page.dart'; 

class ClientDashboardPage extends StatefulWidget {
  String userEmail;

  ClientDashboardPage({
    required this.userEmail,
  });

  @override
  State<ClientDashboardPage> createState() => _ClientDashboardPageState();
}

class _ClientDashboardPageState extends State<ClientDashboardPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWideScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Client Dashboard'),
        backgroundColor: Color(0xFF8e2de2),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: _buildPage(_currentIndex),
      bottomNavigationBar: isWideScreen ? null : BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Client Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.picture_as_pdf),
            label: 'Show Brochure',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Place Order',
          ),
        ],
      ),
      drawer: isWideScreen ? null : Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(
                'Welson®',
                style: TextStyle(
                  color: Colors.white, // White text color
                  fontSize: 24, // Bigger font size
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0xFF8e2de2), // Purple background color
              ),
              margin: EdgeInsets.zero, // No margin
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Padding
            ),
            ListTile(
              title: Text('Client Profile'),
              onTap: () {
                Navigator.pop(context); // Close the Drawer
                setState(() {
                  _currentIndex = 0; // Change to the Client Profile page
                });
              },
            ),
            ListTile(
              title: Text('Show Brochure'),
              onTap: () {
                Navigator.pop(context); // Close the Drawer
                setState(() {
                  _currentIndex = 1; // Change to the Brochure Page
                });
              },
            ),
            ListTile(
              title: Text('Place Order'),
              onTap: () {
                Navigator.pop(context); // Close the Drawer
                setState(() {
                  _currentIndex = 2; // Change to the Place Order Page
                });
              },
            ),
            ListTile(
              title: Text('Old Orders'), // Link for viewing old orders
              onTap: () {
                Navigator.pop(context); // Close the Drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OldOrdersPage(userEmail: widget.userEmail), // Navigate to old orders page
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return ClientProfilePage(userEmail: widget.userEmail);
      case 1:
        return BrochurePage();
      case 2:
        return PlaceOrderPage(userEmail: widget.userEmail);
      default:
        return Container();
    }
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove("userEmail");
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }
}
