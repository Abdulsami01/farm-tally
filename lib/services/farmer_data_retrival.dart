import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/farmer_card.dart';

class FarmerDataRetrieval extends StatelessWidget {
  final DocumentReference truckDocumentReference;

  FarmerDataRetrieval({required this.truckDocumentReference});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('farmer')
          .where('truckId', isEqualTo: truckDocumentReference)
          .orderBy('farmerAdded', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Error loading data'),
          );
        }

        List<QueryDocumentSnapshot> farmer = snapshot.data!.docs;

        return ListView.builder(
          itemCount: farmer.length,
          itemBuilder: (context, index) {
            DocumentReference farmerDocumentReference = farmer[index].reference;
            return FarmerCard(
              cardNumber: index + 1, // Adding 1 to start the numbering from 1
              truckDocumentReference: truckDocumentReference,
              farmerName: farmer[index]['farmerName'],
              phoneNumber: farmer[index]['phoneNumber'],
              timestamp: farmer[index]['farmerAdded'],
              farmerDocumentReference: farmerDocumentReference,
            );
          },
        );
      },
    );
  }
}
