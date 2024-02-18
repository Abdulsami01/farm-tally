// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class ODisplayBagData extends StatefulWidget {
//   final String farmerName;
//   final String phoneNumber;
//   final DocumentReference farmerDocumentReference;
//   final DocumentReference truckDocumentReference;
//
//   DisplayBagData({
//     required this.farmerName,
//     required this.phoneNumber,
//     required this.farmerDocumentReference,
//     required this.truckDocumentReference,
//   });
//
//   @override
//   State<DisplayBagData> createState() => _DisplayBagDataState();
// }
//
// class _DisplayBagDataState extends State<DisplayBagData> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Data'),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('bagData')
//             .where('farmerId', isEqualTo: widget.farmerDocumentReference)
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No bag data available'));
//           }
//
//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               var data =
//                   snapshot.data!.docs[index].data()! as Map<String, dynamic>;
//               // Extract bagAddedDate from data
//               DateTime bagAddedDate = (data['bagAdded'] as Timestamp).toDate();
//               String formattedDate =
//                   DateFormat('dd MMM yyyy').format(bagAddedDate);
//
//               return ListTile(
//                 title: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Information',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Farmer Name: '),
//                         Text('${data['farmerName']}'),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 4,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Phone Number: '),
//                         Text('${data['phoneNumber']}'),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 4,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Price Per Kg: '),
//                         Text('${data['pricePerKg']}'),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 4,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Total Weight:  '),
//                         Text(' ${data['totalWeight']}'),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 4,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Bags Entered:'),
//                         Text(' ${data['bagsEntered']}'),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 4,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Weight Adjustment: '),
//                         Text(' ${data['weightAdjustment']}'),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 4,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Adjusted Total Weight: '),
//                         Text('${data['adjustedTotalWeight']}'),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 4,
//                     ),
//                     Wrap(
//                       spacing: 10, // Adjust spacing as needed
//                       alignment: WrapAlignment.spaceBetween,
//                       children: [
//                         Text('Weights Entered: '),
//                         Text(
//                             '${(data['weightsEntered'] as List).join(', ')}'), // Join list elements into a string
//                       ],
//                     ),
//                     SizedBox(
//                       height: 4,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Total Value: '),
//                         Text('${data['totalValue']}'),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 4,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Time: '),
//                         Text(
//                           formattedDate,
//                         ),
//                       ],
//                     ),
//                     Divider(),
//                     // show advance value and time here
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Advance ',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         )
//                       ],
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//
//                     AdvanceWidget(
//                       farmerDocumentReference: widget.farmerDocumentReference,
//                       bagAddedDate: bagAddedDate,
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
// class AdvanceWidget extends StatelessWidget {
//   final DocumentReference farmerDocumentReference;
//   final DateTime bagAddedDate; // Add bagAddedDate as a parameter
//
//   AdvanceWidget(
//       {required this.farmerDocumentReference, required this.bagAddedDate});
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('advance')
//             .where('farmerId', isEqualTo: farmerDocumentReference)
//             .orderBy('advanceAdded', descending: true)
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           }
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Text('No advance data available');
//           }
//
//           return Column(
//             children: [
//               // Display individual advance amounts, dates, and interest
//               Column(
//                 children: snapshot.data!.docs.map((DocumentSnapshot document) {
//                   var advanceData = document.data()! as Map<String, dynamic>;
//                   var advanceAmount =
//                       double.parse(advanceData['advance'].toString());
//                   var advanceTime =
//                       (advanceData['advanceAdded'] as Timestamp).toDate();
//                   String formattedDate =
//                       DateFormat('dd MMM yyyy').format(advanceTime);
//
//                   // Calculate interest
//                   int days = advanceTime.difference(bagAddedDate).inDays;
//                   double interestRate = 0.18;
//                   double interest = advanceAmount * interestRate * (days / 365);
//
//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Wrap(
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Text('Amount'),
//                                   Text('$advanceAmount INR'),
//                                 ],
//                               ),
//                               Text(formattedDate),
//                             ],
//                           ),
//                         ],
//                       ),
//                       Wrap(
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Row(
//                                 children: [
//                                   Text('Interest'),
//                                   Text(' ${interest.toStringAsFixed(2)} INR'),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//
//                       // Display interest
//                       SizedBox(
//                         height: 10,
//                       ), // Add some spacing between each advance entry
//                     ],
//                   );
//                 }).toList(),
//               ),
//               // Display the sum of all advance amounts
//               Row(
//                 children: [
//                   Text('Total: '),
//                   Text(
//                     ' ${_calculateTotalAdvance(snapshot.data!.docs)} INR',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   // Helper method to calculate the total advance amount
//   double _calculateTotalAdvance(List<DocumentSnapshot> documents) {
//     double totalAdvance = 0;
//     for (var document in documents) {
//       var advanceData = document.data()! as Map<String, dynamic>;
//       var advanceAmount = double.parse(advanceData['advance'].toString());
//       totalAdvance += advanceAmount;
//     }
//     return totalAdvance;
//   }
// }
