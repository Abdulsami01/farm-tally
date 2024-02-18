import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utils/data_model.dart';

class DisplayBagData extends StatefulWidget {
  final String farmerName;
  final String phoneNumber;
  final DocumentReference farmerDocumentReference;
  final DocumentReference truckDocumentReference;

  DisplayBagData({
    required this.farmerName,
    required this.phoneNumber,
    required this.farmerDocumentReference,
    required this.truckDocumentReference,
  });

  @override
  State<DisplayBagData> createState() => _DisplayBagDataState();
}

class _DisplayBagDataState extends State<DisplayBagData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data'),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('bagData')
              .where('farmerId', isEqualTo: widget.farmerDocumentReference)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No bag data available'));
            }

            var data =
                snapshot.data!.docs.first.data()! as Map<String, dynamic>;
            DateTime bagAddedDate = (data['bagAdded'] as Timestamp).toDate();
            String formattedDate =
                DateFormat('dd MMM yyyy').format(bagAddedDate);

            return Column(
              children: [
                // First part of the screen
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                      SizedBox(height: 18),
                      Row(
                        children: [
                          Text('Name: '),
                          Text(
                            '${widget.farmerName}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text('Number: '),
                          Text(
                            ' ${widget.phoneNumber}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      AdvanceWidget(
                        farmerDocumentReference: widget.farmerDocumentReference,
                        bagAddedDate: bagAddedDate,
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),

                /// Second part of the screen
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Price Per Kg: '),
                          Text('${data['pricePerKg']}'),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Bags Entered:'),
                          Text(' ${data['bagsEntered']}'),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Weight:  '),
                          Text(' ${data['totalWeight']}'),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Weight Adjustment: '),
                          Text(' ${data['weightAdjustment']}'),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Adjusted Total Weight: '),
                          Text('${data['adjustedTotalWeight']}'),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Value: '),
                          Text('${data['totalValue']}'),
                        ],
                      ),
                      SizedBox(
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
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total Interest: '),
                                  SizedBox(width: 0),
                                  Text(
                                    '$totalInterest INR',
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total Advance: '),
                                  SizedBox(width: 0),
                                  Text(
                                    '$totalAmount INR',
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Final amount:'),
                                  Text(
                                    '$finalAmount INR',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                // Third part of the screen
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 10, // Adjust spacing as needed
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          Text('Weights Entered: '),
                          Text(
                              '${(data['weightsEntered'] as List).join(' ,  ')}'), // Join list elements into a string
                        ],
                      ),
                      SizedBox(
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
    );
  }
}

class AdvanceWidget extends StatelessWidget {
  final DocumentReference farmerDocumentReference;
  final DateTime bagAddedDate; // Add bagAddedDate as a parameter

  AdvanceWidget({
    required this.farmerDocumentReference,
    required this.bagAddedDate,
  });

  @override
  Widget build(BuildContext context) {
    final dataModel = Provider.of<DataModel>(context, listen: false);

    return SingleChildScrollView(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('advance')
            .where('farmerId', isEqualTo: farmerDocumentReference)
            .orderBy('advanceAdded', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No advance data available');
          }

          List<Widget> advanceData = [];
          double totalAmount = 0;
          double totalInterest = 0;

          // Extracting advance data and calculating totals
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

            advanceData.add(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormat('dd MMM yyyy').format(advanceTime)),
                  Text('$advanceAmount INR'),
                  Text('$interest INR'),
                ],
              ),
            );

            // Update totals
            totalAmount += advanceAmount;
            totalInterest += interest;
          }
          // Update total interest and total amount using Provider
          dataModel.updateTotals(
              farmerDocumentReference.id, totalInterest, totalAmount);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Advance',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Amount',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Interest',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: advanceData,
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 0,
                  ),
                  Text(
                    ' $totalAmount INR',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' $totalInterest INR',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
