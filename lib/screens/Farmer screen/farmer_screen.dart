import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/farmer_data_retrival.dart';
import '../../utils/functions.dart';

class FarmerScreen extends StatelessWidget {
  final DocumentReference truckDocumentReference;

  FarmerScreen(this.truckDocumentReference);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Functions.addFarmerDialog(context, truckDocumentReference);
        },
      ),
      appBar: AppBar(
        title: Text('Farmers List'),
      ),
      body: FarmerDataRetrieval(truckDocumentReference: truckDocumentReference),
    );
  }
}
