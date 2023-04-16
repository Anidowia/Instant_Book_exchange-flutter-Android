import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project2/drawer.dart';
import 'package:project2/bottom_app_bar.dart';
import 'package:project2/login.dart';
class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String registeredEmail = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booookz"),
        backgroundColor: Color(0xff6958ca),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Register'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xff6958ca),
              ),
              onPressed: () async {
                try {
                  UserCredential userCredential =
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(emailController.text)
                      .set({
                    'email': emailController.text,
                    'password': passwordController.text,
                  });
                  setState(() {
                    registeredEmail = emailController.text;
                  });
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'email-already-in-use') {
                    setState(() {
                      registeredEmail = "This email is already in use";
                    });
                  }
                  print('Error: ${e.code} ${e.message}');
                }
              },
            ),
            SizedBox(height: 16),
            TextButton(
              child: Text('Sign In'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
            SizedBox(height: 16),
            registeredEmail.isNotEmpty
                ? Text('$registeredEmail')
                : SizedBox.shrink(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBarWidget(),
    );
  }
}
