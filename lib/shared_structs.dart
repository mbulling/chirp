class Message {
  Message(
      {required this.content,
      required this.zone,
      required this.author,
      required this.time,
      required this.media});

  Message.fromJson(Map<String, Object?> json)
      : this(
            content: json["content"] as String,
            zone: json["zone"] as String,
            author: json["author"] as String,
            time: json["time"] as String,
            media: json["media"] as String);

  final String content;
  final String zone;
  final String author;
  final String time;
  final String media;

  Map<String, Object?> toJson() {
    return {
      'content': content,
      'zone': zone,
      'author': author,
      'time': time,
      'media': media
    };
  }
}

class Region {
  Region(
      {required this.active_users,
      required this.latitude,
      required this.longitude,
      required this.name,
      required this.radius});

  Region.fromJson(Map<String, Object?> json)
      : this(
            active_users: json["active_users"] as int,
            latitude: json["latitude"] as double,
            longitude: json["longitude"] as double,
            name: json["name"] as String,
            radius: json["radius"] as int);

  final int active_users;
  final double latitude;
  final double longitude;
  final String name;
  final int radius;

  Map<String, Object?> toJson() {
    return {
      'active_users': active_users,
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'radius': radius
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
