import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tally/utils/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class AddBag extends StatefulWidget {
  final String farmerName;
  final String phoneNumber;
  final DocumentReference farmerDocumentReference; // Add this field
  final DocumentReference truckDocumentReference;

  AddBag(
      {required this.farmerName,
      required this.phoneNumber,
      required this.farmerDocumentReference,
      required this.truckDocumentReference});

  @override
  State<AddBag> createState() => _AddBagState();
}

class _AddBagState extends State<AddBag> {
  // Get a reference to the Firestore collection
  final bagDataCollection = FirebaseFirestore.instance.collection('bagData');
  final _formkey = GlobalKey<FormState>();

  List<Bag> bags = [];

  double totalWeight = 0.0;

  TextEditingController bagWeightController = TextEditingController();

  TextEditingController pricePerKgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bag'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      'Name: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      widget.farmerName,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      'Number: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      widget.phoneNumber,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Align fields to opposite ends
                  children: [
                    // Price per kg field:
                    Flexible(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter price';
                          }
                          return null;
                        },
                        controller: pricePerKgController,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Price per kg:',
                          hintText: 'Enter price ',
                        ),
                      ),
                    ),
                    SizedBox(
                        width:
                            10.0), // Optional spacing between fields (adjust as needed)
                    // Bag weight field:
                    Flexible(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter bag weight.';
                          }
                          return null;
                        },
                        controller: bagWeightController,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Bag weight:',
                          hintText: 'Enter weight ',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                MaterialButton(
                  color: ColorConstants.primaryColor,
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      addBag();
                    }
                  },
                  child: Text(
                    'Add Bag',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Display Information:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Bags Entered:'),
                    Text('${bags.length}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Weight:'),
                    Text('${totalWeight.toStringAsFixed(2)} kg'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Weight Adjustment:'),
                    Text('${(bags.length * 2).toStringAsFixed(2)} kg'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Adjusted Total Weight:'),
                    Text(
                        '${(totalWeight - (bags.length * 2)).toStringAsFixed(2)} kg'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Value:'),
                    Text(
                        '₹${((totalWeight - (bags.length * 2)) * (double.tryParse(pricePerKgController.text) ?? 0.0)).toStringAsFixed(2)}'),
                  ],
                ),
                Wrap(
                  spacing: 10, // Adjust spacing as needed
                  alignment:
                      WrapAlignment.spaceBetween, // Simulate spaceBetween
                  children: [
                    Text('Weights Entered:'),
                    Text(
                        '${bags.map((bag) => '${bag.bagWeight} kg').join(', ')}'),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Divider(),
                SizedBox(
                  height: 30,
                ),
                MaterialButton(
                  color: Colors.red,
                  onPressed: () {
                    Functions.saveBagData(
                      context,
                      bags,
                      totalWeight,
                      pricePerKgController,
                      widget.truckDocumentReference,
                      widget.farmerDocumentReference,
                      widget.farmerName,
                      widget.phoneNumber,
                    );
                  },
                  child: Text(
                    'Save Bag Data',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addBag() {
    // Get values from text fields

    double bagWeight = double.tryParse(bagWeightController.text) ?? 0.0;
    double pricePerKg = double.tryParse(pricePerKgController.text) ?? 0.0;

    // Validate inputs
    if (bagWeight.isNaN || pricePerKg.isNaN) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all fields with valid values.'),
        duration: Duration(seconds: 2),
      ));
      return;
    }

    // Add bag to the list
    bags.add(Bag()
      ..bagWeight = bagWeight
      ..pricePerKg = pricePerKg);
    totalWeight += bagWeight;

    // Update display
    updateDisplay();
    bagWeightController.clear();
  }

  void updateDisplay() {
    // Update display information widgets
    setState(() {});
  }

  // void saveBagData() async {
  //   User? currentUser = FirebaseAuth.instance.currentUser;
  //   try {
  //     // Validate input (adapt based on specific requirements)
  //     if (bags.isEmpty || double.tryParse(pricePerKgController.text) == null) {
  //       throw Exception('Please enter bag weight and price per kg.');
  //     }
  //     // Calculate adjusted total weight and total value
  //     double adjustedTotalWeight = totalWeight - (bags.length * 2);
  //     double totalValue = adjustedTotalWeight *
  //         (double.tryParse(pricePerKgController.text) ?? 0.0);
  //
  //     // Prepare data for Firestore
  //     final bagData = {
  //       'truck id': widget.truckDocumentReference,
  //       'farmer id': widget.farmerDocumentReference,
  //       'userId': currentUser?.uid,
  //       'farmerName': widget.farmerName,
  //       'phoneNumber': widget.phoneNumber,
  //       'pricePerKg': double.tryParse(pricePerKgController.text)!,
  //       'totalWeight': totalWeight,
  //       'bags': bags.map((bag) => bag.toMap()).toList(),
  //       'adjustedTotalWeight': adjustedTotalWeight,
  //       'totalValue': totalValue,
  //     };
  //
  //     // Add data to Firestore
  //     await bagDataCollection.add(bagData);
  //
  //     // Clear fields and update display (optional)
  //     bags.clear();
  //     totalWeight = 0.0;
  //     pricePerKgController.clear();
  //     bagWeightController.clear();
  //     updateDisplay();
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Bag data saved successfully!'),
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //   } on Exception catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error saving bag data: $e'),
  //         duration: Duration(seconds: 5),
  //       ),
  //     );
  //   }
  // }
}

class Bag {
  double bagWeight = 0.0;
  double pricePerKg = 0.0;
  Map<String, dynamic> toMap() {
    return {
      'bagWeight': bagWeight,
      'pricePerKg': pricePerKg,
    };
  }
}
