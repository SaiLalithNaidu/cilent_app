import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Pages/splashScreen.dart';

FirebaseOptions firebaseOptions = const FirebaseOptions(
  apiKey: 'AIzaSyClrXb_86MCrCmxfFTWUAk0ESp7bt76eT8',
  appId: '1:387450668918:android:9b27554532adbc699e1c57',
  messagingSenderId: '387450668918',
  projectId: 'realtime-3fb9b',
  // Add other necessary options
);
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyClrXb_86MCrCmxfFTWUAk0ESp7bt76eT8',
        appId: '1:387450668918:android:9b27554532adbc699e1c57',
        messagingSenderId: '387450668918',
        projectId: 'realtime-3fb9b',
        storageBucket: "gs://realtime-3fb9b.appspot.com"),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashScreen());
  }
}
