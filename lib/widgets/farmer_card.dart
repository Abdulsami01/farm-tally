import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tally/screens/Add%20Bag/add_bag.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/colors.dart';
import '../screens/Display Bag Data/displayBagData.dart';
import '../screens/advance/advance.dart';

class FarmerCard extends StatefulWidget {
  final int cardNumber;
  final Timestamp timestamp;
  final String farmerName;
  final String phoneNumber;

  final DocumentReference truckDocumentReference;
  final DocumentReference farmerDocumentReference;

  FarmerCard({
    required this.cardNumber,
    required this.timestamp,
    required this.farmerName,
    required this.phoneNumber,
    required this.truckDocumentReference,
    required this.farmerDocumentReference,
  });

  @override
  State<FarmerCard> createState() => _FarmerCardState();
}

class _FarmerCardState extends State<FarmerCard> {
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = widget.timestamp.toDate();
    String formattedDate = DateFormat.yMMMd().format(dateTime);
    String formattedTime = DateFormat('h:mm a').format(dateTime);
    return GestureDetector(
      onTap: () {
        checkBagDataExistence(context);
      },
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 12,
            backgroundColor: ColorConstants.primaryColor,
            child: Text(
              '${widget.cardNumber}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios_sharp),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Farmer Name: ${widget.farmerName}'),
              Text('Phone Number: ${widget.phoneNumber}'),
            ],
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '$formattedDate ,',
                    style: TextStyle(color: Colors.blue),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    '$formattedTime',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
              MaterialButton(
                color: Colors.green,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Advance(
                        truckDocumentReference: widget.truckDocumentReference,
                        farmerDocumentReference: widget.farmerDocumentReference,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Advance',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void checkBagDataExistence(BuildContext context) {
    try {
      FirebaseFirestore.instance
          .collection('bagData')
          .where('farmerId', isEqualTo: widget.farmerDocumentReference)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          // Data exists in the "Bag Data" collection for this farmer
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DisplayBagData(
                      farmerName: widget.farmerName,
                      phoneNumber: widget.phoneNumber,
                      truckDocumentReference: widget.truckDocumentReference,
                      farmerDocumentReference: widget.farmerDocumentReference,
                    )),
          );
          print('have data');
        } else {
          // No data exists in the "Bag Data" collection for this farmer
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBag(
                farmerName: widget.farmerName,
                phoneNumber: widget.phoneNumber,
                truckDocumentReference: widget.truckDocumentReference,
                farmerDocumentReference: widget.farmerDocumentReference,
              ),
            ),
          );
        }
      });
    } catch (e) {
      print('Error checking bag data existence: $e');
      // Handle the error or show an error message to the user
    }
  }
}
