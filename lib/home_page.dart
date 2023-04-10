import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'message_view.dart';
import 'shared_structs.dart';
import 'common.dart';

class HomePage extends StatefulWidget {
  final int userIdentity;
  final String locationName;
  final Position userPosition;

  const HomePage(
      {Key? key,
      required this.userIdentity,
      required this.locationName,
      required this.userPosition})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _locationText = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.locationName),
        backgroundColor: Color.fromARGB(255, 19, 64, 100),
      ),
      body: StreamBuilder<List<Message>>(
        stream: getMessages(),
        builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Message> messages = orderByDate(snapshot.data!);

          return MessageView(
              messages: messages,
              userIdentity: (widget.userIdentity).toString());
        },
      ),
      backgroundColor: Color(0xFFe5eaee),
    );
  }
}
