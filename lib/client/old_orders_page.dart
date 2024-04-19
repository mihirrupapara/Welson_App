import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OldOrdersPage extends StatelessWidget {
  final String userEmail;

  OldOrdersPage({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Old Orders'),
        backgroundColor: Color(0xFF8e2de2),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Clients')
            .where('email', isEqualTo: userEmail)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Client not found'));
          }
          // Get the client document
          var clientDoc = snapshot.data!.docs.first;
          // Retrieve the client's company name from the client document
          var companyName = clientDoc['companyName'];

          // Debugging statement to print company name
          print('Company name retrieved: $companyName');

          // Now fetch orders for the client's company using the companyName
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Orders')
                .where('companyName', isEqualTo: companyName)
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> orderSnapshot) {
              if (orderSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (orderSnapshot.hasError) {
                return Center(child: Text('Error: ${orderSnapshot.error}'));
              }
              if (orderSnapshot.data == null ||
                  orderSnapshot.data!.docs.isEmpty) {
                return Center(child: Text('No old orders found'));
              }
              // Display the old orders
              return ListView.builder(
                itemCount: orderSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var order = orderSnapshot.data!.docs[index];
                  return _buildOrderItem(context, order);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, DocumentSnapshot order) {
    // Extracting date from Firestore timestamp
    Timestamp timestamp = order['timestamp'];
    DateTime orderDate = timestamp.toDate();
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.05,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Date: ${orderDate.day}/${orderDate.month}/${orderDate.year}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Client: ${order['clientName']}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Company: ${order['companyName']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('Order List:'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (order['orderItems'] as List<dynamic>)
                      .map<Widget>((item) => Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              '${item['series']} - ${item['itemName']}  ${item['quantity']}pcs',
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
