import 'package:flutter/material.dart';
import 'shared_structs.dart';
import 'common.dart';

Color getUserColor(int userIdentity) {
  // Generate a color based on the user identity
  int colorValue = userIdentity.hashCode % (0xFFFFFF + 1);
  return Color(colorValue).withOpacity(1.0);
}

class UserProfilePage extends StatefulWidget {
  final int userIdentity;

  UserProfilePage({Key? key, required this.userIdentity}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final List<Message> messages = [];
  List<Message> userMessages = [];

  @override
  void initState() {
    super.initState();
    // Filter messages by the user's identity
    getMessages().listen((messages) {
      setState(() {
        userMessages = messages;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe5eaee),
      appBar: AppBar(
        title: Text('profile'),
        backgroundColor: Color.fromARGB(255, 19, 64, 100),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: getUserColor(widget.userIdentity),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userMessages.length,
              itemBuilder: (BuildContext context, int index) {
                if (userMessages[index].author ==
                    widget.userIdentity.toString()) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        userMessages[index].content,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
