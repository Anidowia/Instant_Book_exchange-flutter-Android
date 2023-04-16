import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project2/transactions_screen.dart';
import 'package:project2/drawer.dart';

import 'bottom_app_bar.dart';

class BookInfoScreen extends StatelessWidget {
  final DocumentSnapshot bookSnapshot;

  const BookInfoScreen({
    required this.bookSnapshot,
  });

  @override
  Widget build(BuildContext context) {
    var bookTitle = bookSnapshot['Title'];
    var bookDescription = bookSnapshot['Description'];
    var bookAuthor = bookSnapshot['Author'];
    var bookCategory = bookSnapshot['Category'];
    var bookCondition = bookSnapshot['Condition'];
    var bookLanguage = bookSnapshot['Language'];
    var imagePath = bookSnapshot['imageUrl'];

    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(bookTitle),
        backgroundColor: Color(0xff6958ca),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(imagePath),
              SizedBox(height: 20),
              Text(
                bookTitle,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('Authors:'),
                  SizedBox(width: 10),
                  Text(bookAuthor),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('Category:'),
                  SizedBox(width: 10),
                  Text(bookCategory),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('Condition:'),
                  SizedBox(width: 10),
                  Text(bookCondition),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('Language:'),
                  SizedBox(width: 10),
                  Text(bookLanguage),
                ],
              ),
              SizedBox(height: 20),
              Text('Description:\n' + bookDescription),
              SizedBox(height: 20),
              if (user != null)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff6958ca),
                  ),
                  onPressed: () async {
                    final CollectionReference transactionsCollection = FirebaseFirestore.instance.collection('transactions');
                    try {
                      final QuerySnapshot existingTransactions = await transactionsCollection.where('bookId', isEqualTo: bookSnapshot.id).get();
                      if (existingTransactions.docs.isEmpty) {
                        await transactionsCollection.add({
                          'bookId': bookSnapshot.id,
                          'bookTitle': bookTitle,
                          'userEmail': user.email,
                          'transactionDate': Timestamp.now(),
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionsPage(
                              userEmail: user.email ?? "Guest",
                              bookTitle: bookTitle,
                            ),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text('Book already added'),
                            content: Text('This book is already added to your transactions or by someone else'),
                            actions: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xff6958ca),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    } catch (e) {
                      print('Error adding transaction: $e');
                    }
                  },
                  child: Text('Add to transaction'),
                )
              else
                SizedBox(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBarWidget(),
    );
  }
}