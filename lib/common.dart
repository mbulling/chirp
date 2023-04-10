import 'package:chirp/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'shared_structs.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

Future<void> initializeFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

final messageRef =
    FirebaseFirestore.instance.collection('messages').withConverter<Message>(
          fromFirestore: (snapshots, _) => Message.fromJson(snapshots.data()!),
          toFirestore: (message, _) => message.toJson(),
        );

/// Retrieves all messages from 'messages' collection in Firestore
Stream<List<Message>> getMessages() {
  return messageRef.orderBy('time', descending: true).snapshots().map(
        (querySnapshot) => querySnapshot.docs.map((doc) => doc.data()).toList(),
      );
}

/// Adds message to 'messages' collection in Firestore. Requires date/time be
/// in the format YYYY-MM-DD HH:MM:SS
Future<void> addMessage(
    String content, Zone zone, String author, String time, String media) async {
  try {
    await messageRef.add(Message(
        content: content,
        zone: zone,
        author: author,
        time: time,
        media: media));
  } catch (e) {
    print(e);
  }
}

int dateComparator(Message msg1, Message msg2) {
  var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  var dt1 = formatter.parse(msg1.time);
  var dt2 = formatter.parse(msg2.time);
  return dt1.compareTo(dt2);
}

List<Message> orderByDate(List<Message> messages) {
  messages.sort(dateComparator);
  return messages;
}

bool shareZone(Message msg1, Message msg2) {
  return msg1.zone == msg2.zone;
}

/// Gives user position
Future<Position> getPosition() async {
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

final regionRef =
    FirebaseFirestore.instance.collection('regions').withConverter<Region>(
          fromFirestore: (snapshots, _) => Region.fromJson(snapshots.data()!),
          toFirestore: (region, _) => region.toJson(),
        );

/// Retrieves all regions from 'regions' collection in Firestore
Future<List<Region>> getRegions() async {
  List<Region> regions = [];
  QuerySnapshot<Region> querySnapshot = await regionRef.get();
  for (QueryDocumentSnapshot<Region> documentSnapshot in querySnapshot.docs) {
    regions.add(documentSnapshot.data());
  }
  return regions;
}
