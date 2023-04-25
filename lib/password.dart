import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project2/drawer.dart';
import 'package:project2/bottom_app_bar.dart';
import 'package:project2/login.dart';
class PasswordScreen extends StatefulWidget {
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}
class _PasswordScreenState extends State<PasswordScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Password Reset"),
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
                labelText: 'New Password',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xff6958ca),
              ),
              child: Text('Reset Password'),
              onPressed: () async {
                try {
                  await auth.sendPasswordResetEmail(email: emailController.text);
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(emailController.text)
                      .update({
                    'password': passwordController.text,
                  });
                  setState(() {
                    message = 'Password reset email sent successfully';
                  });
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    setState(() {
                      message = 'User not found for this email';
                    });
                  }
                  print('Error: ${e.code} ${e.message}');
                }
              },
            ),
            SizedBox(height: 16),
            Text('$message'),
          ],
        ),
      ),
    );
  }
}
