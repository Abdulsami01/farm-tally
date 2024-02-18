import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/colors.dart';
import '../../services/truck_data_retrival.dart';
import '../../utils/functions.dart';
import '../drawer/drawer.dart';

class HomeTrucks extends StatelessWidget {
  const HomeTrucks({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstants.goldenColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Functions.addTruckDialog(context);
        },
      ),
      appBar: AppBar(
        title: Text('Trucks'),
      ),
      body: TruckDataRetrieval(),
    );
  }
}
