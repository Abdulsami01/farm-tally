import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tally/controllers/reference_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

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
          var controller = Get.find<ReferenceController>();
          controller.truckDocReference.value == null
              ? Functions.addFarmerDialog(
                  context,
                  // truckDocumentReference: truckDocumentReference,
                )
              : showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return DraggableScrollableSheet(
                        expand: true,
                        initialChildSize: 0.9,
                        maxChildSize: 0.9,
                        minChildSize: 0.1,
                        builder: (ctx, sc) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: Column(
                              children: [
                                MaterialButton(
                                  onPressed: () {
                                    Functions.addFarmerDialog(
                                      context,
                                      // truckDocumentReference: truckDocumentReference,
                                    );
                                  },
                                  child: const Icon(Icons.add),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.9,
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('farmer')
                                          .where('truckId', isEqualTo: '')
                                          .orderBy('farmerAdded',
                                              descending: true)
                                          .snapshots(),
                                      builder: (ctx, snap) {
                                        if (snap.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else if (snap.hasData) {
                                          return ListView.builder(
                                              controller: sc,
                                              itemCount: snap.data!.docs.length,
                                              itemBuilder: (context, i) {
                                                return ListTile(
                                                  onTap: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('farmer')
                                                        .doc(snap
                                                            .data!.docs[i].id)
                                                        .update({
                                                      'truckId': controller
                                                          .truckDocReference
                                                          .value
                                                    }).then((value) {
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  title: Text(snap.data?.docs[i]
                                                      ['farmerName']),
                                                );
                                              });
                                        }
                                        return const Center(
                                          child: Text('Internal Server Error'),
                                        );
                                      }),
                                ),
                              ],
                            ),
                          );
                        });
                  });
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
