import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../Home Screen/home_screen.dart';
import 'email_login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  _RegisterState();

  bool showProgress = false;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController confirmpassController =
      new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController numberController = new TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;
  File? file;
  late double height = MediaQuery.of(context).size.height;
  late double width = MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: height * 0.10,
            horizontal: width * 0.04,
          ),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 100,
                  child: Image.asset(
                    'assets/logo.png',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Sign up",
                  style: TextStyle(fontSize: 40),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Name',
                    enabled: true,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 10.0, top: 10.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal),
                      borderRadius: new BorderRadius.circular(20),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(color: Colors.white),
                      borderRadius: new BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value!.length == 0) {
                      return "Name cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {},
                  keyboardType: TextInputType.name,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Email',
                    enabled: true,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 10.0, top: 10.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal),
                      borderRadius: new BorderRadius.circular(20),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(color: Colors.white),
                      borderRadius: new BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value!.length == 0) {
                      return "Email cannot be empty";
                    }
                    if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return ("Please enter a valid email");
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {},
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: numberController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Phone Number',
                    enabled: true,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 10.0, top: 10.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal),
                      borderRadius: new BorderRadius.circular(20),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(color: Colors.white),
                      borderRadius: new BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Phone number cannot be empty";
                    }
                    // Add additional validation for phone numbers if needed
                    // For example, you can check the length or format of the phone number
                    // You may use regular expressions or other validation logic here.
                    // For simplicity, I'll just check if it contains only digits.
                    if (!RegExp(r"^\d+$").hasMatch(value)) {
                      return "Please enter a valid phone number";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {},
                  keyboardType:
                      TextInputType.phone, // Set keyboard type to phone
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: _isObscure,
                  controller: passwordController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(_isObscure
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        }),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Password',
                    enabled: true,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 10.0, top: 10.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal),
                      borderRadius: new BorderRadius.circular(20),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(color: Colors.white),
                      borderRadius: new BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    RegExp regex = new RegExp(r'^.{6,}$');
                    if (value!.isEmpty) {
                      return "Password cannot be empty";
                    }
                    if (!regex.hasMatch(value)) {
                      return ("please enter valid password min. 6 character");
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {},
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: _isObscure2,
                  controller: confirmpassController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(_isObscure2
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isObscure2 = !_isObscure2;
                          });
                        }),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Confirm Password',
                    enabled: true,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 10.0, top: 10.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal),
                      borderRadius: new BorderRadius.circular(20),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(color: Colors.white),
                      borderRadius: new BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (confirmpassController.text != passwordController.text) {
                      return "Password did not match";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {},
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    elevation: 5.0,
                    minWidth: double.infinity,
                    height: 40,
                    onPressed: () async {
                      setState(() {
                        visible = true;
                      });
                      await signUp(
                        emailController.text,
                        passwordController.text,
                        nameController.text,
                        numberController.text,
                      );
                      setState(() {
                        visible = false;
                      });
                    },
                    child: Text(
                      "Create account",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    color: ColorConstants.primaryColor,
                  ),
                ),
                Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: visible,
                  child: CircularProgressIndicator(
                    color: Colors.red, // Adjust the color as needed
                  ),
                ),
                Text(
                  "Already have an account ?",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 1,
                  ),
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  elevation: 5.0,
                  height: 40,
                  onPressed: () {
                    CircularProgressIndicator();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  color: ColorConstants.secondaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  signUp(
    String email,
    String password,
    String name,
    String number,
  ) async {
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String userId = userCredential.user!.uid;
        //  User? user = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'name': name,
          'email': email,
          'phoneNumber': number,
          'accountCreated': FieldValue.serverTimestamp(),
          'userId': userId,

          // Add any additional fields you want to store
        }).whenComplete(() => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomeScreen(),
              ),
            ));
      } on FirebaseAuthException catch (e) {
        String errorMessage = '';
        if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'The account already exists for that email.';
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

    CircularProgressIndicator();
  }
}
