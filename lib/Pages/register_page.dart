import 'package:client_app/Controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class Register_Page extends StatelessWidget {
  const Register_Page({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Login_Controller>(builder: (ctrl) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.deepPurple[50]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Create your Account..!',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
              const SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Your Name',
                    hintText: 'Your Name'),
              ),
              const SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.phone_android),
                    labelText: 'Mobile Number',
                    hintText: 'Mobile Number'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    ctrl.addUser();
                    // Navigator.of(context)
                    //     .push(MaterialPageRoute(builder: (ctx) => LoginPage()));
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple),
                  child: Text('Register')),
              TextButton(
                  onPressed: () {},
                  child: Text('Alredy have an Account Login..?')),
            ],
          ),
        ),
      );
    });
  }
}
