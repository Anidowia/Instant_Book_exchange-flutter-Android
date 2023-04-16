import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'book_info_screen.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final _searchController = TextEditingController();
  List<String> offeredBooks = [
    'The Manga Guide to Cryptography',
    'The Manga Guide to Physics',
    'Algorithms base for tyans',
    'Atomic heart',
    'Genshin Insights',
  ];
  List<DocumentSnapshot?> _searchResults = [];


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

  void _performSearch(String query) async {
    // Reset search results
    setState(() {
      _searchResults = [];
    });

    // Query Firestore for books matching the search query
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('books')
        .where('Title', isEqualTo: query)
        .get();

    // Check if any books were found
    if (querySnapshot.docs.isNotEmpty) {
      // Add each book to the search results list
      setState(() {
        _searchResults = querySnapshot.docs.toList();
      });
    } else {
      // Query not found, show "Text not found" message
      setState(() {
        _searchResults.add(null);
      });
    }
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onSubmitted: _performSearch,
          decoration: InputDecoration(
            hintText: 'Search for books...',
            border: InputBorder.none,
          ),
        ),
        backgroundColor: Color(0xff6958ca),
      ),
      body: ListView.separated(
        itemCount: _searchResults.length,
        itemBuilder: (BuildContext context, int index) {
          if (_searchResults[index] != null) {
            String bookTitle = _searchResults[index]!['Title'];
            String bookDescription = _searchResults[index]!['Description'];
            String bookAuthor = _searchResults[index]!['Author'];
            String bookCategory = _searchResults[index]!['Category'];
            String bookCondition = _searchResults[index]!['Condition'];
            String bookLanguage = _searchResults[index]!['Language'];
            String imagePath = _searchResults[index]!['imageUrl'];
            return InkWell(
              onTap: () {
                _navigateToBookInfoScreen(
                  context,
                  _searchResults[index]!,
                );
              },
              child: ListTile(
                title: Text(bookTitle),
              ),
            );
          } else {
            return ListTile(
              title: Text('Text not found'),
            );
          }
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
      ),
    );
  }
}
