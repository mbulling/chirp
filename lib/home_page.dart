import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'message_view.dart';
import 'shared_structs.dart';
import 'common.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _locationText = '';
  String _locationName = '';

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      final Position position = await _determinePosition();
      setState(() {
        _locationText =
            'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
        _getLocationName(position);
      });
    } catch (e) {
      setState(() {
        _locationText = 'Error: ${e.toString()}';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_locationName),
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

          return MessageView(messages: messages);
        },
      ),
      backgroundColor: Color(0xFFe5eaee),
    );
  }
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
