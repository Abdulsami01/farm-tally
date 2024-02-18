//new with pdf

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:open_file/open_file.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
//
// class DisplayBagData extends StatefulWidget {
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
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   Future<void> _downloadPDF() async {
//     try {
//       final pdf = pw.Document();
//
//       // Add data to the PDF document
//       pdf.addPage(
//         pw.Page(
//           build: (pw.Context context) => pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Text('Farmer Name: ${widget.farmerName}'),
//               pw.Text('Phone Number: ${widget.phoneNumber}'),
//               // Add more data fields here as needed
//             ],
//           ),
//         ),
//       );
//
//       // Get the app's document directory
//       final Directory appDocDir = await getApplicationDocumentsDirectory();
//       final String appDocPath = appDocDir.path;
//
//       // Create FarmTally directory if it doesn't exist
//       final Directory farmTallyDir = Directory('$appDocPath/FarmTally');
//       farmTallyDir.createSync(recursive: true);
//
//       // Save the PDF to the FarmTally directory
//       final String pdfPath = '${farmTallyDir.path}/bag_data.pdf';
//       final File file = File(pdfPath);
//       await file.writeAsBytes(await pdf.save());
//
//       // Show a snackbar to inform the user about the download
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('PDF downloaded successfully'),
//         ),
//       );
//
//       // Open the PDF document
//       OpenFile.open(pdfPath); // Assuming you have a package to open PDF files
//     } catch (e) {
//       // Handle any errors that occur during the process
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: $e'),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         title: Text('Bag Data'),
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
//               snapshot.data!.docs[index].data()! as Map<String, dynamic>;
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
//                     // Add more data fields here as needed
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _downloadPDF,
//         child: Icon(Icons.download),
//       ),
//     );
//   }
// }
//
