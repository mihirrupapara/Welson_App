import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlaceOrderPage extends StatefulWidget {
  final String userEmail;

  PlaceOrderPage({
    required this.userEmail,
  });

  @override
  _PlaceOrderPageState createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {
  String? _selectedSeries;
  String? _selectedItem;
  late String comName = '';
  late String cliName = '';
  int _quantity = 1;
  TextEditingController _quantityController = TextEditingController();

  List<OrderItem> _orderItems = [];

  final List<String> _seriesList = [
    'DELIGHT',
    'IMPERIAL',
    'JET+',
    'NANO',
    'LOTUS',
    'ROYAL',
    'RIVA',
    'TOUCH',
    'SKY'
  ];

  final Map<String, List<String>> _seriesItems = {
    'DELIGHT': [
      'Bib Cock',
      'Long Body',
      'Piller Cock',
      'Angular Stop Cock',
      'Concealed Stop Cock(Medium)',
      'Concealed Stop Cock(XL)',
      'Concealed Stop Cock(XXL)',
      'Flush Cock(XL)',
      'Sink Cock with Swinging "J" Spout',
      'Swan Neck with Swinging "J" Spout',
      '2 in 1 Bib Cock',
      '2 in 1 Angle Cock',
      '2 in 1 Wall Mixer',
      'Sink Mixer with Swinging "J" Spout',
      'Center Hold Basin Mixer'
    ],
    'IMPERIAL': [
      'Bib Cock',
      'Long Body',
      'Piller Cock',
      'Angular Stop Cock',
      'Concealed Stop Cock(Medium)',
      'Concealed Stop Cock(XL)',
      'Concealed Stop Cock(XXL)',
      'Flush Cock(XL)',
      'Sink Cock with Swinging Brass Spout',
      'Swan Neck with Swinging "J" Spout',
      '2 in 1 Bib Cock',
      '2 in 1 Angle Cock',
      '2 in 1 Wall Mixer',
      'Sink Mixer',
      'Center Hold Basin Mixer'
    ],
    'JET+': [
      'Bib Cock',
      'Long Body',
      'Piller Cock',
      'Angular Stop Cock',
      'Concealed Stop Cock (Medium)',
      'Concealed Stop Cock (XL)',
      'Concealed Stop Cock (XXL)',
      'Flush Cock (XL)',
      'Sink Cock with Swinging "J" Spout',
      'Swan Neck with Swinging "J" Spout',
      '2 in 1 Bib Cock',
      '2 in 1 Angle Cock',
      '2 in 1 Wall Mixer',
      'Sink Mixer',
      'Center Hold Basin Mixer'
    ],
    'NANO': [
      'Bib Cock',
      'Long Body',
      'Piller Cock',
      'Angular Stop Cock',
      'Concealed Stop Cock (Medium)',
      'Concealed Stop Cock (XL)',
      'Concealed Stop Cock (XXL)',
      'Flush Cock (XL)',
      'Sink Cock with Swinging "J" Spout',
      'Swan Neck with Swinging "J" Spout',
      '2 in 1 Bib Cock',
      '2 in 1 Angle Cock',
      '2 in 1 Wall Mixer with Band',
      'Sink Mixer with Swinging "J" Spout',
      'Center Hold Basin Mixer'
    ],
    'LOTUS': [
      'Long Body',
      'Piller Cock',
      'Angular Stop Cock',
      'Concealed Stop Cock (XL)',
      'Sink Cock with Swinging Brass Spout',
      'Swan Neck with Swinging Brass Spout',
      'Swan Neck with Swinging "J" Spout',
      '2 in 1 Bib Cock',
      '2 in 1 Angle Cock',
      '2 in 1 Wall Mixer',
      'Sink Mixer with Swinging Brass Spout'
    ],
    'ROYAL': [
      'Bib Cock',
      'Long Body',
      'Piller Cock',
      'Angular Stop Cock',
      'Concealed Stop Cock (XL)',
      'Sink Cock with Swinging "J" Spout',
      'Swan Neck with Swinging "J" Spout',
      '2 in 1 Bib Cock',
      '2 in 1 Angle Cock',
      '2 in 1 Wall Mixer',
      'Sink Mixer with Swinging "J" Spout'
    ],
    'RIVA': [
      'Bib Cock',
      'Long Body',
      'Piller Cock',
      'Angular Stop Cock',
      'Concealed Stop Cock (Medium)',
      'Concealed Stop Cock (XL)',
      'Concealed Stop Cock (XXL)',
      'Flush Cock (XL)',
      'Sink Cock with Swinging "J" Spout',
      'Swan Neck with Swinging "J" Spout',
      '2 in 1 Bib Cock',
      '2 in 1 Angle Cock',
      '2 in 1 Wall Mixer',
      'Sink Mixer with Swinging "J" Spout',
      'Center Hold Basin Mixer'
    ],
    'TOUCH': [
      'Bib Cock',
      'Long Body',
      'Piller Cock',
      'Angular Stop Cock',
      'Concealed Stop Cock (XL)',
      'Sink Cock with Swinging "J" Spout',
      'Swan Neck with Swinging "J" Spout',
      '2 in 1 Bib Cock',
      '2 in 1 Angle Cock',
      '2 in 1 Wall Mixer',
      'Sink Mixer with Swinging "J" Spout',
      'Center Hold Basin Mixer'
    ],
    'SKY': [
      'Bib Cock',
      'Long Body',
      'Piller Cock',
      'Angular Stop Cock',
      'Concealed Stop Cock (Medium)',
      'Concealed Stop Cock (XL)',
      'Concealed Stop Cock (XXL)',
      'Flush Cock (XL)',
      'Sink Cock with Swinging "J" Spout',
      'Swan Neck with Swinging "J" Spout',
      '2 in 1 Bib Cock',
      '2 in 1 Angle Cock',
      '2 in 1 Wall Mixer',
      'Sink Mixer with Swinging "J" Spout',
      'Center Hold Basin Mixer'
    ],
  };

  Future<void> saveOrderToFirestore() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Clients')
          .where('email', isEqualTo: widget.userEmail)
          .get();

      if (querySnapshot.docs.length == 1) {
        var clientData = querySnapshot.docs.first.data();

        if (clientData != null && clientData is Map<String, dynamic>) {
          String clientName = clientData['name'] as String;
          String companyName = clientData['companyName'] as String;
          comName = companyName;
          cliName = clientName;
          var orderData = _orderItems.map((item) {
            return {
              'series': item.series,
              'itemName': item.itemName,
              'quantity': item.quantity,
            };
          }).toList();

          await FirebaseFirestore.instance.collection('Orders').add({
            'clientName': clientName,
            'companyName': companyName,
            'orderItems': orderData,
            'timestamp': FieldValue.serverTimestamp(),
            'isCompleted': false
          });

          setState(() {
            _selectedSeries = null;
            _selectedItem = null;
            _quantity = 1;
            _quantityController.clear();
            _orderItems.clear();
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Order placed successfully!')),
          );

          log('Order data saved to Firestore');
        } else {
          log('Client data is null or not of type Map<String, dynamic>');
        }
      } else {
        log('No client found with the provided email or multiple clients found.');
      }
    } catch (e) {
      log('Error saving order data to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Place Order'),
      //   backgroundColor: Color(0xFF8e2de2),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedSeries,
              hint: Text('Select Series'),
              onChanged: (value) {
                setState(() {
                  _selectedSeries = value;
                  _selectedItem = null;
                });
              },
              items: _seriesList.map((series) {
                return DropdownMenuItem<String>(
                  value: series,
                  child: Text(series),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            if (_selectedSeries != null)
              DropdownButtonFormField<String>(
                value: _selectedItem,
                hint: Text('Select Item'),
                onChanged: (value) {
                  setState(() {
                    _selectedItem = value;
                  });
                },
                items: _seriesItems[_selectedSeries!]?.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              ),
            const SizedBox(height: 20),
            if (_selectedItem != null)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '$_selectedSeries - $_selectedItem',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (_quantity > 1) _quantity--;
                        _quantityController.text = _quantity.toString();
                      });
                    },
                  ),
                  SizedBox(
                    width: 50,
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        setState(() {
                          _quantity = int.tryParse(value) ?? 1;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _quantity++;
                        _quantityController.text = _quantity.toString();
                      });
                    },
                  ),
                ],
              ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedItem != null) {
                    bool itemExists = false;
                    for (var item in _orderItems) {
                      if (item.series == _selectedSeries &&
                          item.itemName == _selectedItem) {
                        setState(() {
                          item.quantity += _quantity;
                          itemExists = true;
                        });
                        break;
                      }
                    }
                    if (!itemExists) {
                      setState(() {
                        _orderItems.add(OrderItem(
                            _selectedSeries!, _selectedItem!, _quantity));
                      });
                    }
                  }
                },
                child: Text('Add', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF8e2de2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Client: ${cliName}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            'Company: ${comName}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 20.0,
                          columns: [
                            DataColumn(
                              label: SizedBox(
                                width: 120,
                                child: Text(
                                  'Series',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 120,
                                child: Text(
                                  'Item',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 120,
                                child: Text(
                                  'Quantity',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            DataColumn(label: Text('')),
                          ],
                          rows: _orderItems.map((item) {
                            return DataRow(cells: [
                              DataCell(
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: SizedBox(
                                      width: 120,
                                      child: Text(item.series),
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: SizedBox(
                                      width: 120,
                                      child: Text(item.itemName),
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: SizedBox(
                                      width: 120,
                                      child: Text(item.quantity.toString()),
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  iconSize: 20,
                                  icon: Icon(Icons.remove_circle),
                                  onPressed: () {
                                    setState(() {
                                      _orderItems.remove(item);
                                    });
                                  },
                                ),
                              ),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Call the method to save order to Firestore
                  saveOrderToFirestore();
                },
                child:
                    Text('Place Order', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF8e2de2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItem {
  final String series;
  final String itemName;
  int quantity;

  OrderItem(this.series, this.itemName, this.quantity);
}