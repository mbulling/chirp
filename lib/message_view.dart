import 'package:flutter/material.dart';
import 'shared_structs.dart';
import 'user_profile.dart';
import 'common.dart';
import 'dart:convert';

class MessageView extends StatefulWidget {
  List<Message> messages = [];

  MessageView({Key? key, required this.messages}) : super(key: key);

  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  TextEditingController _textController = TextEditingController();

  void _sendMessage() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        widget.messages.add(Message(
            content: _textController.text,
            author: "123456",
            time: "now",
            zone: Zone(location: "north campus")));
        addMessage(_textController.text, Zone(location: "north campus"),
            "123456", "now");
        _textController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe5eaee),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: widget.messages.length,
              itemBuilder: (BuildContext context, int index) {
                return Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Align(
                        alignment: widget.messages[index].author == 'me'
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: widget.messages[index].author == 'me'
                                ? Color(0xFF023258)
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Text(
                            widget.messages[index].content,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: widget.messages[index].author == 'me' ? null : 0,
                      right: widget.messages[index].author == 'me' ? 0 : null,
                      bottom: 7,
                      child: Container(
                        margin: EdgeInsets.only(
                          left: widget.messages[index].author == 'me' ? 0 : 8.0,
                          right:
                              widget.messages[index].author == 'me' ? 8.0 : 0,
                        ),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: getUserColor(
                              int.parse(widget.messages[index].author)),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
