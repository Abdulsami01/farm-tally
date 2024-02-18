import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/functions.dart';
import '../registration/changePassword.dart';
import '../registration/email_login.dart';
import '../registration/register_email.dart';

const Gradient kGradient = LinearGradient(colors: [Colors.green, Colors.blue]);

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(80),
        ),
      ),
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            // decoration: BoxDecoration(
            //   color: Colors.white,
            // ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 100,
                  child: Image.asset(
                    'assets/logo.png',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  user.email!,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add new'),
            onTap: () {
              Functions.addTruckDialog(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('History'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('Contact Us'),
            onTap: () {},
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePassword(),
                  ),
                );
              },
              child: Text('Change Password'),
              color: Colors.teal,
              minWidth: 10,
              textColor: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: MaterialButton(
              onPressed: () {
                Functions.deleteAccount(context);
              },
              child: Text('Delete Account'),
              color: Colors.green,
              minWidth: 10,
              textColor: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: MaterialButton(
              onPressed: () {
                Functions.signOut(context);
              },
              child: Text('Log out'),
              color: Colors.redAccent,
              minWidth: 10,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
    );
  }
}
