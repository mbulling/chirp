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
            region: Region(
                name: json["regionName"] as String,
                latitude: json["latitude"] as double,
                longitude: json["longitude"] as double,
                radius: json["radius"] as double,
                actives: json["actives"] as int),
            author: json["author"] as String,
            time: json["time"] as String);

  final String content;
  final Region region;
  final String author;
  final String time;

  Map<String, Object?> toJson() {
    return {
      'content': content,
      'longitude': region.getLongitude(),
      'latitude': region.getLatitude(),
      'radius': region.getRadius(),
      'author': author,
      'time': time,
      'actives': region.getActives(),
    };
  }
}

class Region {
  Region(
      {required this.name,
      required this.longitude,
      required this.latitude,
      required this.radius,
      required this.actives});

  Region.fromJson(Map<String, Object?> json)
      : this(
            name: json["name"] as String,
            longitude: json["longitude"] as double,
            latitude: json["latitude"] as double,
            radius: json["radius"] as double,
            actives: json["actives"] as int);

  Map<String, Object?> toJson() {
    return {"longitude": longitude, "latitude": latitude, "radius": radius};
  }

  final String name;
  final double longitude;
  final double latitude;
  final double radius;
  final int actives;
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

  double getRadius() {
    return radius;
  }

  int getActives() {
    return actives;
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
