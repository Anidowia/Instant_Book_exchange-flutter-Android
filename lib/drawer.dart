import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project2/registration_screen.dart';
import 'package:project2/search_page.dart';
import 'package:project2/transactions_screen.dart';
class AppDrawer extends StatelessWidget {
  final String? bookTitle;
  const AppDrawer({
    Key? key,
    this.bookTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isUserLoggedIn = user != null;

    return Drawer(
      child: Container(
        color: Color(0xffb19dfc),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xff6958ca),
                    radius: 40,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    FirebaseAuth.instance.currentUser?.email ?? "Guest",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Search'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
            ),
            isUserLoggedIn
                ? ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign out'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                      (_) => false,
                );
              },
            ): ListTile(
              leading: Icon(Icons.person),
              title: Text('Sign in'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegistrationScreen(),
                  ),
                );
              },
            ),
            if (isUserLoggedIn) // Show "Transactions" only for logged-in users
              ListTile(
                leading: Icon(Icons.credit_card),
                title: Text('Transactions'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionsPage(
                        userEmail: FirebaseAuth.instance.currentUser?.email ?? "Guest",
                        bookTitle: bookTitle,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
