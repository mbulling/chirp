import 'package:flutter/material.dart';
import 'shared_structs.dart';

class MessageView extends StatefulWidget {
  List<Message> messages;

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
            author: "me",
            time: "now",
            content: _textController.text,
            zone: Zone(location: "north campus")));
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
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                    alignment: widget.messages[index].author == 'me'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: widget.messages[index].author == 'me'
                            ? Color(
                                0xFF023258) // Set your sent message background color
                            : Colors
                                .grey, // Set your received message background color
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        widget.messages[index].content,
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: TextFormField(
                      controller: _textController,
                      decoration: InputDecoration(
                          hintText: "type message", border: InputBorder.none),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Theme.of(context).primaryColor,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
