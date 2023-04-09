import 'package:meta/meta.dart';

class Message {
  Message(
      {required this.content,
      required this.zone,
      required this.author,
      required this.time});

  Message.fromJson(Map<String, Object?> json)
      : this(
            content: json["content"] as String,
            zone: json["zone"] as String,
            author: json["author"] as String,
            time: json["time"] as String);

  final String content;
  final String zone;
  final String author;
  final String time;

  Map<String, Object?> toJson() {
    return {'message': content, 'zone': zone, 'author': author, 'time': time};
  }
}
