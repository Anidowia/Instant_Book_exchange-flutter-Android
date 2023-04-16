import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project2/bottom_app_bar.dart';
import 'package:project2/registration_screen.dart';
import 'package:project2/drawer.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booookz"),
        backgroundColor: Color(0xff6958ca),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
              child: Text('Sign in'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xff6958ca),
              ),
              onPressed: () async {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  // успешная аутентификация, переход на другую страницу
                } on FirebaseAuthException catch (e) {
                  print('Error: ${e.code} ${e.message}');
                }
              },
            ),
            SizedBox(height: 16),
            TextButton(
              child: Text('Create an account'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBarWidget(),
      drawer: AppDrawer(),
    );
  }
}
