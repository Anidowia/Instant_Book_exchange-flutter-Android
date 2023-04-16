import 'package:flutter/material.dart';
import 'package:project2/drawer.dart';
import 'package:project2/book_info_screen.dart';
import 'package:project2/bottom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatelessWidget {
  Future<bool> checkIfBookAlreadyAdded(String bookTitle) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('transactions')
        .where('bookTitle', isEqualTo: bookTitle)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booookz'),
        backgroundColor: Color(0xff6958ca),
      ),
      drawer: AppDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Offered books',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('books').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return GridView.builder(
                  itemCount: snapshot.data?.docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width ~/ 200,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    var document = snapshot.data?.docs[index];
                    var bookTitle = document!['Title'];
                    var imagePath = document['imageUrl'];

                    return GestureDetector(
                      onTap: () {
                        _navigateToBookInfoScreen(
                          context,
                          document,
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20), // set the desired border radius value
                              child: Image.network(
                                imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            bookTitle,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBarWidget(),
    );
  }
}

void _navigateToBookInfoScreen(BuildContext context, DocumentSnapshot bookSnapshot) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BookInfoScreen(
        bookSnapshot: bookSnapshot,
      ),
    ),
  );
}
