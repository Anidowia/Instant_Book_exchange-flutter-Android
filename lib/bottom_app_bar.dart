import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomAppBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color(0xffb19dfc),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.code),
            onPressed: () async {
              const url = 'https://github.com/AsserElfeki/Instant_Book_exchange'; // замените ссылку на свою
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () async {
              const url = 'https://www.linkedin.com/';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () async {
              const url = 'https://github.com/Anidowia';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.support),
            onPressed: () async {
              const url = 'https://boookzexchange.store/support';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
        ],
      ),
    );
  }
}
