import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientProfilePage extends StatelessWidget {
  final String userEmail;

  ClientProfilePage({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
          return Center(child: Text('No client data found'));
        }
        final clientData =
            snapshot.data!.docs.first.data() as Map<String, dynamic>;
        final documentId = snapshot.data!.docs.first.id;
        return ClientProfileDetails(
          clientData: clientData,
          documentId: documentId,
        );
      },
    );
  }
}

class ClientProfileDetails extends StatelessWidget {
  final Map<String, dynamic> clientData;
  final String documentId;

  ClientProfileDetails({required this.clientData, required this.documentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Client Profile',
              style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.06, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            _buildDetailRow(context, 'Name', clientData['name']),
            _buildDetailRow(context, 'Company Name', clientData['companyName']),
            _buildDetailRow(context, 'State', clientData['state']),
            _buildDetailRow(context, 'Mobile Number', clientData['mobileNumber']),
            _buildDetailRow(context, 'GST Number', clientData['gstNumber']),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ModifyClientDetailsPage(
                        clientData: clientData,
                        documentId: documentId,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Edit Details',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF8e2de2),
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.4, MediaQuery.of(context).size.height * 0.06),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.04),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.005),
          Text(
            value,
            style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035),
          ),
        ],
      ),
    );
  }
}

class ModifyClientDetailsPage extends StatefulWidget {
  final Map<String, dynamic> clientData;
  final String documentId;

  ModifyClientDetailsPage({required this.clientData, required this.documentId});

  @override
  _ModifyClientDetailsPageState createState() =>
      _ModifyClientDetailsPageState();
}

class _ModifyClientDetailsPageState extends State<ModifyClientDetailsPage> {
  late TextEditingController _nameController;
  late TextEditingController _companyNameController;
  late TextEditingController _stateController;
  late TextEditingController _mobileController;
  late TextEditingController _gstController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.clientData['name']);
    _companyNameController =
        TextEditingController(text: widget.clientData['companyName']);
    _stateController =
        TextEditingController(text: widget.clientData['state']);
    _mobileController =
        TextEditingController(text: widget.clientData['mobileNumber']);
    _gstController =
        TextEditingController(text: widget.clientData['gstNumber']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modify Client Details'),
        backgroundColor: Color(0xFF8e2de2),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Name', _nameController),
            _buildTextField('Company Name', _companyNameController),
            _buildTextField('State', _stateController),
            _buildTextField('Mobile Number', _mobileController),
            _buildTextField('GST Number', _gstController),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Center(
              child: ElevatedButton(
                onPressed: _updateDetails,
                child: Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF8e2de2),
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.4, MediaQuery.of(context).size.height * 0.06),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.04),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.005),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  void _updateDetails() {
    FirebaseFirestore.instance
        .collection('Clients')
        .doc(widget.documentId)
        .update({
      'name': _nameController.text,
      'companyName': _companyNameController.text,
      'state': _stateController.text,
      'mobileNumber': _mobileController.text,
      'gstNumber': _gstController.text,
    }).then((_) {
      print('Client details updated successfully');
      Navigator.pop(context);
    }).catchError((error) {
      print('Failed to update client details: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to update client details. Please try again later.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Client Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Client Profile'),
          backgroundColor: Color(0xFF8e2de2),
        ),
        body: ClientProfilePage(
          userEmail: 'example@example.com',
        ),
      ),
    );
  }
}
