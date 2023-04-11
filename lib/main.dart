import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'user_profile.dart';
import 'saved_page.dart';
import 'common.dart';
import 'dart:math';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(const MyApp());
}

int generateUserIdentity() {
  Random random = Random();
  return random.nextInt(999999);
}

final int userIdentity = generateUserIdentity();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Position _userPosition;
  late String _locationName;

  @override
  void initState() {
    _getLocation();
    super.initState();
  }

  Future<void> _getLocation() async {
    try {
      final Position position = await _determinePosition();
      setState(() {
        _userPosition = position;
      });
      _getLocationName(position);
    } catch (e) {
      setState(() {
        _locationName = 'Error: ${e.toString()}';
      });
    }
  }

  Future<void> _getLocationName(Position position) async {
    try {
      final List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      setState(() {
        if (placemarks.isNotEmpty) {
          final Placemark placemark = placemarks[0];
          _locationName =
              placemark.subLocality ?? placemark.locality ?? 'unknown1';
          _locationName = _locationName.toLowerCase();
        } else {
          _locationName = 'unknown2';
        }
      });
    } catch (e) {
      setState(() {
        _locationName = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: TabBarView(
            children: [
              SavedRegionsPage(
                  userPosition: _userPosition,
                  userIdentity: userIdentity.toString()),
              UserProfilePage(userIdentity: userIdentity),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFFe5eaee),
                  width: 1,
                ),
              ),
            ),
            child: const TabBar(
              labelColor: Color(0xFF023258),
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(
                  icon: Icon(Icons.home),
                  text: 'home',
                ),
                Tab(
                  icon: Icon(Icons.person),
                  text: 'profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }
}
