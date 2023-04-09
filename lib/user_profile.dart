import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  final String userName;

  UserProfilePage({Key? key, required this.userName}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  List<String> postHistory = [
    'First post',
    'Second post',
    'Third post',
    'Fourth post',
    'Fifth post',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'),
        backgroundColor: Color.fromARGB(255, 19, 64, 100),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              widget.userName,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: postHistory.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      postHistory[index],
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
