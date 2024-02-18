import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/truck_card.dart';

class TruckDataRetrieval extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('trucks')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .orderBy(
            'truckAdded',
            descending: true,
          ) // Order by timestamp in descending order

          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<DocumentSnapshot> trucks = snapshot.data!.docs;

        return ListView.builder(
          itemCount: trucks.length,
          itemBuilder: (context, index) {
            DocumentReference truckDocumentReference = trucks[index].reference;

            return TruckCard(
              cardNumber: index + 1, // Adding 1 to start the numbering from 1
              truckNumber: trucks[index]['truckNumber'],
              timestamp: trucks[index]['truckAdded'],
              truckDocumentReference: truckDocumentReference,
            );
          },
        );
      },
    );
  }
}
