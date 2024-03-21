import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tally/controllers/reference_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

import '../widgets/farmer_card.dart';

class FarmerDataRetrieval extends StatelessWidget {
  const FarmerDataRetrieval({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ReferenceController>();
    return StreamBuilder(
      stream: controller.truckDocReference.value != null
          ? FirebaseFirestore.instance
              .collection('farmer')
              .where('truckId', isEqualTo: controller.truckDocReference.value)
              .orderBy('farmerAdded', descending: true)
              .snapshots()
          : FirebaseFirestore.instance
              .collection('farmer')
              // .where('truckId', isEqualTo: truckDocumentReference)
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
