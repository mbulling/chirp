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
            zone: Zone(location: json["zone"] as String),
            author: json["author"] as String,
            time: json["time"] as String);

  final String content;
  final Zone zone;
  final String author;
  final String time;

  Map<String, Object?> toJson() {
    return {
      'message': content,
      'zone': zone.toString(),
      'author': author,
      'time': time
    };
  }
}

class Zone {
  Zone({required this.location});

  final String location;

  @override
  bool operator ==(Object other) {
    return other is Zone && other.location == location;
  }

  @override
  String toString() {
    return location;
  }
}
