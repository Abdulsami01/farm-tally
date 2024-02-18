import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Advance extends StatelessWidget {
  final DocumentReference truckDocumentReference;
  final DocumentReference farmerDocumentReference;

  Advance({
    required this.truckDocumentReference,
    required this.farmerDocumentReference,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advance'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('advance')
            .where('farmerId', isEqualTo: farmerDocumentReference)
            .orderBy('advanceAdded', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            if (snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No advance data available.'));
            } else {
              List<QueryDocumentSnapshot> advance = snapshot.data!.docs;
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var advanceAmount = advance[index]['advance'];
                  var advanceTime =
                      (advance[index]['advanceAdded'] as Timestamp).toDate();
                  String formattedDate =
                      DateFormat('dd MMM yyyy').format(advanceTime);
                  // String formattedTime =
                  //     DateFormat('hh:mm a').format(advanceTime);

                  //  var advanceData = snapshot.data!.docs[index].data();
                  return ListTile(
                    title: Row(
                      children: [
                        Text('Amount: '),
                        Text(
                          ' $advanceAmount INR',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    subtitle: Text(formattedDate),
                  );
                },
              );
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController advanceController = TextEditingController();

              return AlertDialog(
                title: Text('Add Advance'),
                content: TextField(
                  keyboardType: TextInputType.number,
                  controller: advanceController,
                  decoration: InputDecoration(
                    prefixText: 'INR ',
                    labelText: 'Enter Advance',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      String advanceAmount = advanceController.text;
                      // Upload advance amount to Firebase collection 'advance'
                      FirebaseFirestore.instance.collection('advance').add({
                        'advance': advanceAmount,
                        'truckId': truckDocumentReference,
                        'farmerId': farmerDocumentReference,
                        'advanceAdded': FieldValue.serverTimestamp(),
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
