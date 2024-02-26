import 'package:client_app/Pages/home_screen.dart';
import 'package:client_app/Pages/practice_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Product_Description_Sscreen.dart';

class login_Page extends StatefulWidget {
  const login_Page({super.key});

  @override
  State<login_Page> createState() => _login_PageState();
}

class _login_PageState extends State<login_Page> {
  String email = "";
  String password = "";
  var _fromKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscureText = true; // State variable to toggle password visibility
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : Container(
                  // margin: EdgeInsets.all(15),
                  alignment: Alignment.center,
                  child: Form(
                    key: _fromKey,
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 85),
                          Column(
                            children: [
                              Container(
                                child: const Column(
                                  children: [
                                    Text(
                                      "Sign in Now",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Roboto',
                                        fontSize: 25,
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      "Please sign in to continue our app",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                return value!.contains("@")
                                    ? null
                                    : 'Enter valid Email';
                              },
                              onChanged: (value) {
                                setState(() {
                                  email = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "Email",
                                labelText: 'Email',
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey[10],
                                contentPadding: EdgeInsets.all(
                                    25), // Adjust padding as needed
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: TextFormField(
                                obscureText: _obscureText,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  return value!.length > 6
                                      ? null
                                      : 'Password must be 6 characters';
                                },
                                onChanged: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: "Passsword",
                                  labelText: 'Password',
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.grey[10],
                                  contentPadding: EdgeInsets.all(
                                      25), // Adjust padding as needed
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                  ),
                                ),
                              )),
                          SizedBox(height: 8),
                          Container(
                            width: 320,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () {
                                print(email);
                                print(password);
                                signIn();
                              },
                              child: const Text("Sign In"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      15.0), // Adjust the value as needed
                                ), // Background color
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) =>
                                        const PracticeRegisterationScreeen()));
                              },
                              child: Text('Register new account..?')),
                          SizedBox(height: 15),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'assets/google.jpg',
                                  width: 50,
                                  height: 60,
                                ),
                                Image.asset(
                                  'assets/facebook.png',
                                  width: 50,
                                  height: 40,
                                ),
                                Image.asset(
                                  'assets/insta.jpg',
                                  width: 50,
                                  height: 40,
                                ), // Replace 'assets/image1.png' with your image path
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  void signIn() {
    try {
      if (_fromKey.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
        FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((user) {
          print("Usser:$user.user?.uid");
          setState(() {
            isLoading = false;
          });
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => homeScreen()),
              (Route<dynamic> route) => false);
          Fluttertoast.showToast(msg: "Succesfully SignIn");
        }).catchError((onError) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: "Error: " + onError.message!);
        });
      }
    } catch (e) {
      print("Error occurred singUp: $e");
    }
  }
}
