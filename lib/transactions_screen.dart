import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project2/drawer.dart';
import 'package:project2/bottom_app_bar.dart';
class _TransactionsPageState extends State<TransactionsPage> {
  late Future<List<DocumentSnapshot>> transactions;

  @override
  void initState() {
    super.initState();
    transactions = getTransactions();
  }
  Future<List<DocumentSnapshot>> getTransactions() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('transactions').get();
    return querySnapshot.docs;
  }
  void _cancelTransaction(DocumentSnapshot transaction) async {
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email;

    if (transaction['userEmail'] != currentUserEmail) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cannot cancel transaction'),
          content: const Text('You did not initiate this transaction.'),
          actions: [
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
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel transaction?'),
        content: const Text('Are you sure you want to cancel this transaction?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No',
              style: TextStyle(
                  color: Color(0xff6958ca)
              )
            ),
          ),
          TextButton(
            onPressed: () async {
              await transaction.reference.delete();
              Navigator.pop(context);
              setState(() {
                transactions = getTransactions();
              });
            },
            child: Text('Yes',
            style: TextStyle(
                color: Color(0xff6958ca)
            )
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        backgroundColor: const Color(0xff6958ca),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: transactions,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<DocumentSnapshot> transactions = snapshot.data!;
            final List<Widget> items = [];

            if (transactions.isEmpty) {
              return const Center(
                child: Text('There are no transactions yet'),
              );
            }

            for (var i = 0; i < transactions.length; i++) {
              final DocumentSnapshot transaction = transactions[i];
              final String bookTitle = transaction['bookTitle'];
              final String userEmail = transaction['userEmail'];
              final Timestamp transactionDate = transaction['transactionDate'];
              final String transactionStatus = transaction['status'];

              items.add(Card(
                child: ListTile(
                  title: Text(bookTitle),
                  subtitle: Text('User: $userEmail'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(transactionDate.toDate().toString()),
                      if (transactionStatus == 'Initiated')
                        IconButton(
                          icon: const Icon(Icons.cancel),
                          onPressed: () => _cancelTransaction(transaction),
                        ),
                    ],
                  ),
                ),
              ));

              if ((i + 1) % 2 == 0) {
                items.add(Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: const Text(
                      'Status: Initiated',
                      style: TextStyle(
                        color: Color(0xff6958ca),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ));
              }
            }

            return ListView(children: items);
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading transactions: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBarWidget(),
    );
  }
}


class TransactionsPage extends StatefulWidget {
  final String userEmail;
  final String? bookTitle;
  const TransactionsPage({required this.bookTitle, required this.userEmail, Key? key}) : super(key: key);
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}
