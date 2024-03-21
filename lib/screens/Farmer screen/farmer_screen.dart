import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/farmer_data_retrival.dart';
import '../../utils/functions.dart';

class FarmerScreen extends StatelessWidget {
  // final DocumentReference? truckDocumentReference;

  const FarmerScreen({
    super.key,
    // this.truckDocumentReference,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Functions.addFarmerDialog(
            context,
            // truckDocumentReference: truckDocumentReference,
          );
        },
      ),
      appBar: AppBar(
        title: const Text('Farmers List'),
      ),
      body: const FarmerDataRetrieval(
          // truckDocumentReference: truckDocumentReference,
          ),
    );
  }
}
