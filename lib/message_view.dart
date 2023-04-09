import 'package:flutter/material.dart';
import 'shared_structs.dart';

class MessageView extends StatefulWidget {
  final List<Message> messages;

  MessageView({Key? key, required this.messages}) : super(key: key);

  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  List<Message> messages = [
    Message(
        author: "me",
        time: "now",
        content: "hello world",
        zone: "north campus"),
    Message(
        author: "me",
        time: "now",
        content: "goodbye world",
        zone: "north campus"),
    Message(author: "me", time: "now", content: "chirp", zone: "north campus"),
    Message(author: "mason", time: "now", content: "bark", zone: "north campus")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe5eaee),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                    alignment: messages[index].author == 'me'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: messages[index].author == 'me'
                            ? Color(
                                0xFF023258) // Set your sent message background color
                            : Colors
                                .grey, // Set your received message background color
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        messages[index].content,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white, // Set your message text color
                        ),
                      ),
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
