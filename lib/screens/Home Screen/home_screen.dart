// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../constants/colors.dart';
// import '../../services/truck_data_retrival.dart';
// import '../../utils/functions.dart';
// import '../drawer/drawer.dart';
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: DrawerScreen(),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: ColorConstants.goldenColor,
//         child: Icon(
//           Icons.add,
//           color: Colors.white,
//         ),
//         onPressed: () {
//           Functions.addTruckDialog(context);
//         },
//       ),
//       appBar: AppBar(
//         title: Text('FarmTally'),
//       ),
//       body: TruckDataRetrieval(),
//     );
//   }
// }

import 'package:farm_tally/controllers/reference_controller.dart';
import 'package:farm_tally/screens/Farmer%20screen/farmer_screen.dart';
import 'package:farm_tally/screens/Home%20Screen/home_trucks.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

import '../drawer/drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ReferenceController());
    return Scaffold(
      drawer: const DrawerScreen(),
      appBar: AppBar(
        title: const Text('Farm  Tally'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        controller.isfromTruck.value = true;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeTrucks()));
                      },
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.directions_bus, size: 50),
                            SizedBox(height: 20),
                            Text(
                              'Trucks',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        controller.isfromTruck.value = false;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FarmerScreen()));
                      },
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people, size: 50),
                            SizedBox(height: 20),
                            Text(
                              'Farmer',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
