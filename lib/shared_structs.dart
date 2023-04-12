import 'dart:math';

class Message {
  Message({
    required this.content,
    required this.region,
    required this.author,
    required this.time,
  });

  Message.fromJson(Map<String, Object?> json)
      : this(
            content: json["content"] as String,
            region: json["region"] as Region,
            author: json["author"] as String,
            time: json["time"] as String);

  final String content;
  final Region region;
  final String author;
  final String time;

  Map<String, Object?> toJson() {
    return {
      'content': content,
      'region': region,
      'author': author,
      'time': time,
    };
  }
}

class Region {
  Region(
      {required this.longitude, required this.latitude, required this.radius});

  final double longitude;
  final double latitude;
  final double radius;
  final double earthRadius = 6371.0;

  @override
  bool operator ==(Object other) {
    return other is Region &&
        isInteresting(
            latitude, longitude, other.getLatitude(), other.getLongitude());
  }

  double getLongitude() {
    return longitude;
  }

  double getLatitude() {
    return latitude;
  }

  double toRadians(double degree) {
    return degree * pi / 180.0;
  }

  double haversineDistance(
      double lat1, double long1, double lat2, double long2) {
    double dLat = toRadians(lat2 - lat1);
    double dLong = toRadians(long2 - long1);

    lat1 = toRadians(lat1);
    lat2 = toRadians(lat2);

    double a =
        pow(sin(dLat / 2), 2) + pow(sin(dLong / 2), 2) * cos(lat1) * cos(lat2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  bool isInteresting(double lat1, double long1, double lat2, double long2) {
    double distance = haversineDistance(lat1, long1, lat2, long2);
    return distance <= radius;
  }
}
