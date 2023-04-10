import 'shared_structs.dart';
import 'package:geolocator/geolocator.dart';
import 'common.dart';
import 'dart:math';

const double earthRadius = 6371000;

// function to determine whether user is in region
bool inRegion(Region region, Position position) {
  final double phi_1 = region.latitude * pi / 180;
  final double phi_2 = position.latitude * pi / 180;
  final double delta_phi = (position.latitude - region.latitude) * pi / 180;
  final double delta_lambda =
      (position.longitude - region.longitude) * pi / 180;
  final double a = sin(delta_phi / 2) * sin(delta_phi / 2) +
      cos(phi_1) * cos(phi_2) * sin(delta_lambda / 2) * sin(delta_lambda / 2);
  final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return earthRadius * c <= region.radius;
}
