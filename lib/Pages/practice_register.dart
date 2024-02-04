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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Registation'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              margin: EdgeInsets.all(15),
              alignment: Alignment.center,
              child: Form(
                key: _fromKey,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
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
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
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
                            labelText: 'Pasword',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          print(email);
                          print(password);
                          singUp();
                        },
                        child: Text("Register"),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: Text('Alreadt have an account..?'))
                    ],
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
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              (Route<dynamic> route) => false);
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
