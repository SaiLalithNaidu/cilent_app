import 'package:client_app/Pages/login_page.dart';
import 'package:client_app/Pages/picImageSCreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Edit_status._screendart.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  late User? _user;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  void _checkCurrentUser() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
        if (_user == null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => login_Page()),
              (Route<dynamic> route) => false);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Home Screen",
          style: TextStyle(
            fontFamily: 'YourFontFamily', // Change to your desired font family
            fontSize: 20, // Change to your desired font size
            fontWeight: FontWeight.bold, // Change to your desired font weight
            // You can also specify other text properties like color, letterSpacing, etc. here
          ),
        ),
        actions: <Widget>[
          IconButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => const PickImage()));
            },
            icon: Icon(Icons.add),
            iconSize: 20,
          ),
          IconButton(
            color: Colors.white,
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => login_Page()));
              });
            },
            icon: Icon(Icons.exit_to_app),
            iconSize: 20,
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("statuses").snapshots(),
          builder: (context, snapshort) {
            if (!snapshort.hasData) {
              return CircularProgressIndicator();
            }
            if (snapshort.data?.docs.length == 0) {
              return const Text("No Data");
            }
            return ListView.builder(
                itemCount: snapshort.data?.docs.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            8), // Adjust the border radius as needed
                        child: Image.network(
                          snapshort.data?.docs[index].data()["imageUrl"],
                          width: 50, // Adjust the width of the image as needed
                          height:
                              50, // Adjust the height of the image as needed
                          fit: BoxFit
                              .cover, // Adjust the fit of the image as needed
                        ),
                      ),
                      title: Text(
                        snapshort.data?.docs[index].data()["title"],
                        style: const TextStyle(
                          fontSize: 18, // Adjust the font size as needed
                          fontWeight: FontWeight
                              .bold, // Adjust the font weight as needed
                          // fontStyle: FontStyle
                          //     .italic, // Adjust the font style as needed
                          color: Colors.black, // Adjust the color as needed
                          // fontFamily: 'YourFontFamily', // If you want to use a custom font family
                        ),
                      ),
                      subtitle: Text(
                        snapshort.data?.docs[index]
                            .data()["descriptionOrMessage"],
                        style: const TextStyle(
                          fontSize: 12, // Adjust the font size as needed
                          fontWeight: FontWeight
                              .bold, // Adjust the font weight as needed
                          // fontStyle: FontStyle
                          //     .italic, // Adjust the font style as needed
                          color: Colors.grey, // Adjust the color as needed
                          // fontFamily: 'YourFontFamily', // If you want to use a custom font family
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => EditScreen(
                                  title: snapshort.data?.docs[index]
                                      .data()["title"],
                                  description: snapshort.data?.docs[index]
                                      .data()["descriptionOrMessage"],
                                  imageUrl: snapshort.data?.docs[index]
                                      .data()["imageUrl"],
                                  docId: snapshort.data?.docs[index].id,
                                ),
                              ));
                            },
                          ),
                          // SizedBox(width: ),
                          IconButton(
                              onPressed: () async {
                                // Handle delete functionality
                                await deleteDocument(
                                    snapshort.data?.docs[index].id);
                                Fluttertoast.showToast(
                                  msg:
                                      "successfully Deleted ${snapshort.data?.docs[index].data()["title"]}",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                );
                              },
                              icon: Icon(Icons.delete_forever)),
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }

  Future<void> deleteDocument(String? documentId) async {
    if (documentId != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseFirestore.instance
            .collection("statuses")
            .doc(documentId)
            .delete();
        print("Document successfully deleted!");
      } catch (e) {
        print("Error deleting document: $e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
