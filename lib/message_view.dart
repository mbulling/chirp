import 'package:flutter/material.dart';
import 'shared_structs.dart';
import 'package:intl/intl.dart';
import 'user_profile.dart';
import 'common.dart';
import 'dart:convert';

class MessageView extends StatefulWidget {
  List<Message> messages = [];
  final String userIdentity;
  final Region region;

  MessageView(
      {Key? key,
      required this.messages,
      required this.userIdentity,
      required this.region})
      : super(key: key);

  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  TextEditingController _textController = TextEditingController();

  void _sendMessage() {
    if (_textController.text.isNotEmpty) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      setState(() {
        widget.messages.add(Message(
            content: _textController.text,
            author: widget.userIdentity,
            time: formattedDate,
            zone: widget.region.name,
            media: ""));
        addMessage(_textController.text, widget.region.name,
            widget.userIdentity, formattedDate, "");
        _textController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: widget.messages.length,
              itemBuilder: (BuildContext context, int index) {
                final message = widget.messages[index];
                final isSentByUser = message.author == widget.userIdentity;
                return Column(
                  children: <Widget>[
                    // The image
                    if (message.media.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: isSentByUser
                              ? Alignment.topRight
                              : Alignment.topLeft,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * .6,
                              child: Image.network(
                                width: 300,
                                message.media,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                      ),

                    // This stack contains the message and the profile
                    Stack(
                      children: [
                        // The message
                        if (message.content.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Align(
                              alignment: isSentByUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: isSentByUser
                                      ? Color.fromARGB(255, 111, 185, 211)
                                      : Color.fromARGB(255, 31, 38, 44),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Text(
                                  message.content,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        // The profile
                        if (message.content.isNotEmpty)
                          Positioned(
                            left: isSentByUser ? null : 0,
                            right: isSentByUser ? 0 : null,
                            bottom: 7,
                            child: Container(
                              margin: EdgeInsets.only(
                                left: isSentByUser ? 0 : 8.0,
                                right: isSentByUser ? 8.0 : 0,
                              ),
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: getUserColor(int.parse(message.author)),
                              ),
                            ),
                          ),
                      ],
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
                        hintText: 'type message',
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
