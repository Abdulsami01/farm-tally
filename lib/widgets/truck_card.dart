import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tally/controllers/reference_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';
import '../screens/Farmer screen/farmer_screen.dart';

class TruckCard extends StatefulWidget {
  final String truckNumber;
  final Timestamp timestamp;
  final int cardNumber;
  final DocumentReference? truckDocumentReference;

  const TruckCard({
    super.key,
    required this.truckNumber,
    required this.timestamp,
    required this.cardNumber,
    required this.truckDocumentReference,
  });

  @override
  State<TruckCard> createState() => _TruckCardState();
}

class _TruckCardState extends State<TruckCard> {
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = widget.timestamp.toDate();
    String formattedDate = DateFormat.yMMMd().format(dateTime);
    String formattedTime = DateFormat('h:mm a').format(dateTime);

    return GestureDetector(
      onTap: () {
        var controller = Get.find<ReferenceController>();
        controller.truckDocReference.value = widget.truckDocumentReference;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FarmerScreen(
                // truckDocumentReference: widget.truckDocumentReference,
                // isFromTruckScreen: true,
                ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: ListTile(
            leading: CircleAvatar(
              radius: 12,
              backgroundColor: ColorConstants.primaryColor,
              child: Text(
                '${widget.cardNumber}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              'Truck Number: ${widget.truckNumber}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date: $formattedDate',
                  style: const TextStyle(color: Colors.blue),
                ),
                Text(
                  'Time: $formattedTime',
                  style: const TextStyle(color: Colors.blue),
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios_sharp)),
      ),
    );
  }
}
