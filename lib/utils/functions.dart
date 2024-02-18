import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tally/screens/Display%20Bag%20Data/displayBagData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/Add Bag/add_bag.dart';
import '../screens/registration/email_login.dart';
import '../screens/registration/register_email.dart';

class Functions {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  /// BAd Data new
  static Future<void> saveBagData(
    BuildContext context,
    List<Bag> bags,
    double totalWeight,
    TextEditingController pricePerKgController,
    DocumentReference truckDocumentReference,
    DocumentReference farmerDocumentReference,
    String farmerName,
    String phoneNumber,
  ) async {
    final CollectionReference bagDataCollection =
        FirebaseFirestore.instance.collection('bagData');

    User? currentUser = FirebaseAuth.instance.currentUser;
    try {
      // Validate input (adapt based on specific requirements)
      if (bags.isEmpty || double.tryParse(pricePerKgController.text) == null) {
        throw Exception('Please enter bag weight and price per kg.');
      }

      // Prepare data for Firestore
      final bagData = {
        'bagAdded': FieldValue.serverTimestamp(),
        'truckId': truckDocumentReference,
        'farmerId': farmerDocumentReference,
        'userId': currentUser?.uid,
        'farmerName': farmerName,
        'phoneNumber': phoneNumber,
        'pricePerKg': double.tryParse(pricePerKgController.text)!,
        'totalWeight': totalWeight,
        'bagsEntered': bags.length,
        'weightsEntered': bags.map((bag) => bag.bagWeight).toList(),
        'weightAdjustment': bags.length * 2,
        'adjustedTotalWeight': totalWeight - (bags.length * 2),
        'totalValue': (totalWeight - (bags.length * 2)) *
            double.tryParse(pricePerKgController.text)!,
        'bags': bags.map((bag) => bag.toMap()).toList(),
      };

      // Add data to Firestore
      await bagDataCollection.add(bagData);

      // Clear fields and update display (optional)
      bags.clear();
      totalWeight = 0.0;
      pricePerKgController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bag data saved successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => DisplayBagData(
                  farmerName: farmerName,
                  phoneNumber: phoneNumber,
                  truckDocumentReference: truckDocumentReference,
                  farmerDocumentReference: farmerDocumentReference,
                )),
      );
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving bag data: $e'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  ///Add Bag  old
  // static Future<void> saveBagData(
  //   BuildContext context,
  //   List<Bag> bags,
  //   double totalWeight,
  //   TextEditingController pricePerKgController,
  //   DocumentReference truckDocumentReference,
  //   DocumentReference farmerDocumentReference,
  //   String farmerName,
  //   String phoneNumber,
  //   void Function() updateDisplayCallback, // Callback function
  // ) async {
  //   final CollectionReference bagDataCollection =
  //       FirebaseFirestore.instance.collection('Bag Data');
  //
  //   User? currentUser = FirebaseAuth.instance.currentUser;
  //   try {
  //     // Validate input (adapt based on specific requirements)
  //     if (bags.isEmpty || double.tryParse(pricePerKgController.text) == null) {
  //       throw Exception('Please enter bag weight and price per kg.');
  //     }
  //
  //     // Prepare data for Firestore
  //     final bagData = {
  //       'truck id': truckDocumentReference,
  //       'farmer id': farmerDocumentReference,
  //       'userId': currentUser?.uid,
  //       'farmerName': farmerName,
  //       'phoneNumber': phoneNumber,
  //       'pricePerKg': double.tryParse(pricePerKgController.text)!,
  //       'totalWeight': totalWeight,
  //       'bags': bags.map((bag) => bag.toMap()).toList(),
  //       'adjustedTotalWeight': totalWeight - (bags.length * 2),
  //       'totalValue': (totalWeight - (bags.length * 2)) *
  //           double.tryParse(pricePerKgController.text)!,
  //     };
  //
  //     // Add data to Firestore
  //     await bagDataCollection.add(bagData);
  //
  //     // Clear fields and update display (optional)
  //     bags.clear();
  //     totalWeight = 0.0;
  //     pricePerKgController.clear();
  //     updateDisplayCallback();
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Bag data saved successfully!'),
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //   } on Exception catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error saving bag data: $e'),
  //         duration: Duration(seconds: 5),
  //       ),
  //     );
  //   }
  // }

  ///Add Truck
  static void addTruckDialog(BuildContext context) {
    final CollectionReference truckCollection =
        FirebaseFirestore.instance.collection('trucks');

    // Function to show Cupertino Alert Dialog
    TextEditingController textField1Controller = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Add Truck'),
          content: Column(
            children: [
              CupertinoTextField(
                controller: textField1Controller,
                placeholder: 'Truck Number',
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('Add'),
              onPressed: () async {
                String truckNumber = textField1Controller.text;
                // Get current user
                User? currentUser = FirebaseAuth.instance.currentUser;

                try {
                  if (currentUser != null) {
                    // Upload data with user UID
                    await truckCollection.add({
                      'userId': currentUser.uid,
                      'truckNumber': truckNumber,
                      'truckAdded': FieldValue.serverTimestamp(),
                    });

                    print('Data Uploaded for User: ${currentUser.uid}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Truck added successfully!'),
                      ),
                    );
                  } else {
                    print('No user signed in');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('No user signed in!'),
                      ),
                    );
                  }
                } catch (e) {
                  print('Error during upload: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error during upload: $e'),
                    ),
                  );
                }

                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  ///Add farmer
  static void addFarmerDialog(
    BuildContext context,
    DocumentReference truckDocumentReference, // New parameter
  ) {
    final CollectionReference farmerCollection =
        FirebaseFirestore.instance.collection('farmer');

    final CollectionReference truckCollection =
        FirebaseFirestore.instance.collection('trucks');
    // Function to show Cupertino Alert Dialog
    TextEditingController farmerNameController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Add Farmer'),
          content: Column(
            children: [
              CupertinoTextField(
                controller: farmerNameController,
                placeholder: 'Farmer Name',
              ),
              SizedBox(
                height: 8,
              ),
              CupertinoTextField(
                keyboardType: TextInputType.phone,
                controller: phoneNumberController,
                placeholder: 'Phone Number',
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('Add'),
              onPressed: () async {
                String farmerName = farmerNameController.text;
                String phoneNumber = phoneNumberController.text;
                // Get current user
                User? currentUser = FirebaseAuth.instance.currentUser;

                try {
                  if (currentUser != null) {
                    // Add a new document to the "farmer" collection
                    await farmerCollection.add({
                      'truckId': truckDocumentReference,
                      'farmerName': farmerName,
                      'phoneNumber': phoneNumber,
                      'farmerAdded': FieldValue.serverTimestamp(),
                    });

                    print('Data Uploaded for User: ${currentUser.uid}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Truck added successfully!'),
                      ),
                    );
                  } else {
                    print('No user signed in');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('No user signed in!'),
                      ),
                    );
                  }
                } catch (e) {
                  print('Error during upload: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error during upload: $e'),
                    ),
                  );
                }

                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  ///Delete Account
  static Future<void> deleteAccount(BuildContext context) async {
    final _formkey = GlobalKey<FormState>();
    String errorMessage = "";
    final TextEditingController _passwordController = TextEditingController();
    String? _passwordError;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Form(
            key: _formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'Are you sure you want to delete your account? This action cannot be undone.'),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (errorMessage.isNotEmpty) {
                      return 'wrong Password'; // Return the error message directly
                    }
                    return null;
                  },
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    errorText: _passwordError,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      try {
                        // Validate the password
                        String password = _passwordController.text.trim();
                        // Close the password dialog and proceed with deletion

                        Functions.performDeleteAccount(context, password);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'wrong-password') {
                          errorMessage = 'Incorrect Password ';
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(errorMessage),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  child: Text('Confirm Delete'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> performDeleteAccount(
      BuildContext context, String password) async {
    late SharedPreferences _prefs;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    User? user = _auth.currentUser;

    if (user != null) {
      try {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );

        await user.reauthenticateWithCredential(credential);

        // Delete data from 'receipts' collection
        await FirebaseFirestore.instance
            .collection('trucks')
            .where('uid', isEqualTo: user.uid)
            .get()
            .then((querySnapshot) => {
                  for (DocumentSnapshot document in querySnapshot.docs)
                    {document.reference.delete()}
                });

        // Delete user document from 'users' collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .delete();

        // Delete user account
        await user.delete();

        // // Sign out user
        // await _auth.signOut();

        // Navigate to login screen or display success message
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Register(),
          ),
        );
      } catch (e) {
        // Handle errors during reauthentication or deletion
        print('Error during deletion: $e');
        // Display error message to the user
      }
    } else {
      // Prompt user to log in if not already
      print('User not logged in');
    }
  }

  ///signout function
  static signOut(BuildContext context) async {
    await auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}
