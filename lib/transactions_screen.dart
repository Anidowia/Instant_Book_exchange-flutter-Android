import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
        backgroundColor: Color(0xff6958ca),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: transactions,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<DocumentSnapshot> transactions = snapshot.data!;
            final List<Widget> items = [];

            for (var i = 0; i < transactions.length; i++) {
              final DocumentSnapshot transaction = transactions[i];
              final String bookTitle = transaction['bookTitle'];
              final String userEmail = transaction['userEmail'];
              final Timestamp transactionDate = transaction['transactionDate'];

              items.add(Card(
                child: ListTile(
                  title: Text(bookTitle),
                  subtitle: Text('User: $userEmail'),
                  trailing: Text(transactionDate.toDate().toString()),
                ),
              ));

              if ((i + 1) % 2 == 0) {
                items.add(Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Text(
                      'Status: Initiated',
                      style: TextStyle(
                        color: Colors.purple,
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
            return Center(
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