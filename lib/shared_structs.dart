import 'package:meta/meta.dart';

class Message {
  String id;
  String content;
  String time;
  String author;

  Message(
      {required this.id,
      required this.content,
      required this.time,
      required this.author});
}
