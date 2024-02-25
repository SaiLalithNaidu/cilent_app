import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login_page.dart';

class PracticeRegisterationScreeen extends StatefulWidget {
  const PracticeRegisterationScreeen({super.key});

  @override
  State<PracticeRegisterationScreeen> createState() =>
      _PracticeRegisterationScreeenState();
}

class _PracticeRegisterationScreeenState
    extends State<PracticeRegisterationScreeen> {
  String email = "";
  String password = "";
  var _fromKey = GlobalKey<FormState>();
  bool isLoading = false;
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
                                      "Sign Up Now",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Roboto',
                                        fontSize: 25,
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      "Please fill the details and create account",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 45),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: "User name",
                                  labelText: "User name",
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
                                )),
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
                              obscureText: true,
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
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: 320,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () {
                                print(email);
                                print(password);
                                singUp();
                              },
                              child: const Text("Sign Up"),
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
                                    builder: (ctx) => const LoginPage()));
                              },
                              child: Text('Alreadt have an account..?')),
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

  void singUp() {
    try {
      if (_fromKey.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((user) {
          print("Usser:$user.user?.uid");
          setState(() {
            isLoading = false;
          });
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              (Route<dynamic> route) => false);
        }).catchError((onError) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(
              msg: "Error toast messege displaying: " + onError.message!);
        });
      }
    } catch (e) {
      print("Error occurred singUp: $e");
    }
  }
}
