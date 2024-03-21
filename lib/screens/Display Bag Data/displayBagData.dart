import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../utils/data_model.dart';

class DisplayBagData extends StatefulWidget {
  final String farmerName;
  final String phoneNumber;
  final DocumentReference farmerDocumentReference;
  // final DocumentReference? truckDocumentReference;

  const DisplayBagData({
    Key? key,
    required this.farmerName,
    required this.phoneNumber,
    required this.farmerDocumentReference,
    // required this.truckDocumentReference,
  }) : super(key: key);

  @override
  State<DisplayBagData> createState() => _DisplayBagDataState();
}

class _DisplayBagDataState extends State<DisplayBagData> {
  var src = GlobalKey();
  Future getPdf(Uint8List screenShot, time, tempPath) async {
    pw.Document pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Expanded(
            child: pw.Image(pw.MemoryImage(screenShot), fit: pw.BoxFit.contain),
          );
        },
      ),
    );
    var pathurl = "$tempPath";

    File pdfFile = File(pathurl);
    await pdfFile.writeAsBytes(await pdf.save());
  }

  ScreenshotController cont = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              String tempPath = (await getExternalStorageDirectory())!.path;
              var dates = DateTime.now().toString();
              var pathurl = "$tempPath/$dates.pdf";
              cont.capture().then((value) async {
                await getPdf(value!, dates, pathurl);

                print(pathurl);
                await Share.shareXFiles([XFile(pathurl)]);
              });
            },
            icon: const Icon(Icons.save),
          ),
        ],
        title: const Text('Data'),
      ),
      body: RepaintBoundary(
        key: src,
        child: Screenshot(
          controller: cont,
          child: SingleChildScrollView(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('bagData')
                  .where('farmerId', isEqualTo: widget.farmerDocumentReference)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No bag data available'));
                }

                var data =
                    snapshot.data!.docs.first.data()! as Map<String, dynamic>;
                DateTime bagAddedDate =
                    (data['bagAdded'] as Timestamp).toDate();
                String formattedDate =
                    DateFormat('dd MMM yyyy').format(bagAddedDate);

                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Farmer settlement Report',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              const Text('Name: '),
                              Text(
                                widget.farmerName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text('Number: '),
                              Text(
                                ' ${widget.phoneNumber}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          AdvanceWidget(
                            farmerDocumentReference:
                                widget.farmerDocumentReference,
                            bagAddedDate: bagAddedDate,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Price Per Kg: '),
                              Text('${data['pricePerKg']}'),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Bags Entered:'),
                              Text(' ${data['bagsEntered']}'),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Weight:  '),
                              Text(' ${data['totalWeight']}'),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Weight Adjustment: '),
                              Text(' ${data['weightAdjustment']}'),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Adjusted Total Weight: '),
                              Text('${data['adjustedTotalWeight']}'),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Value: '),
                              Text('${data['totalValue']}'),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Consumer<DataModel>(
                            builder: (context, dataModel, child) {
                              final String farmerId =
                                  widget.farmerDocumentReference.id;
                              final totalInterest =
                                  dataModel.totalInterestMap[farmerId] ?? 0.0;
                              final totalAmount =
                                  dataModel.totalAmountMap[farmerId] ?? 0.0;
                              final totalValue = data['totalValue'] ?? 0.0;
                              final finalAmount =
                                  totalValue - (totalAmount + totalInterest);

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Total Interest: '),
                                      const SizedBox(width: 0),
                                      Text(
                                        '$totalInterest INR',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Total Advance: '),
                                      const SizedBox(width: 0),
                                      Text(
                                        '$totalAmount INR',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Final amount:'),
                                      Text(
                                        '$finalAmount INR',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 10, // Adjust spacing as needed
                            alignment: WrapAlignment.spaceBetween,
                            children: [
                              const Text('Weights Entered: '),
                              Text((data['weightsEntered'] as List)
                                  .join(' ,  ')),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class AdvanceWidget extends StatelessWidget {
  final DocumentReference farmerDocumentReference;
  final DateTime bagAddedDate;

  const AdvanceWidget({
    Key? key,
    required this.farmerDocumentReference,
    required this.bagAddedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataModel = Provider.of<DataModel>(context, listen: false);

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('advance')
          .where('farmerId', isEqualTo: farmerDocumentReference)
          .orderBy('advanceAdded', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No advance data available'),
          );
        }

        List<DataRow> advanceRows = [];
        double totalAmount = 0;
        double totalInterest = 0;
        List<DocumentSnapshot> docs = snapshot.data!.docs;
        for (var doc in docs) {
          var advanceDataMap = doc.data()! as Map<String, dynamic>;
          var advanceAmount =
              double.parse(advanceDataMap['advance'].toString());
          var advanceTime =
              (advanceDataMap['advanceAdded'] as Timestamp).toDate();
          int days = advanceTime.difference(bagAddedDate).inDays;
          double interestRate = 0.18;
          double interest = advanceAmount * interestRate * (days / 365);

          advanceRows.add(
            DataRow(
              cells: [
                DataCell(Text(
                  DateFormat('dd MMM yyyy').format(advanceTime),
                )),
                DataCell(Center(child: Text('$advanceAmount'))),
                DataCell(Center(child: Text('$interest'))),
              ],
            ),
          );

          totalAmount += advanceAmount;
          totalInterest += interest;
        }
        dataModel.updateTotals(
          farmerDocumentReference.id,
          totalInterest,
          totalAmount,
        );

        advanceRows.add(
          DataRow(
            cells: [
              const DataCell(Center(
                child: Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )),
              DataCell(Center(
                child: Text(
                  '$totalAmount',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )),
              DataCell(Center(
                child: Text(
                  '$totalInterest',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )),
            ],
          ),
        );

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Container(
              child: DataTable(
                headingTextStyle: const TextStyle(
                  fontSize: 16,
                ),
                columnSpacing: 40,
                horizontalMargin: 0,
                columns: const [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Amount INR')),
                  DataColumn(label: Text('Interest INR')),
                ],
                rows: advanceRows,
              ),
            ),
          ),
        );
      },
    );
  }
}
