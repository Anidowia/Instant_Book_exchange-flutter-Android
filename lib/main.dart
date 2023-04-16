import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project2/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyCVp2IKlkS2vReSINImAkFGNdbzVd1Qk6s',
          appId: '1:509184877462:android:9be1932f7c7e3631eb73b7',
          messagingSenderId: '509184877462',
          projectId: 'project2-414b9',
          storageBucket: 'project2-414b9.appspot.com'
      ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}