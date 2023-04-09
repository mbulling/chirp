import 'package:chirp/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'shared_structs.dart';
import 'package:intl/intl.dart';

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
    String content, Zone zone, String author, String time) async {
  try {
    await messageRef
        .add(Message(content: content, zone: zone, author: author, time: time));
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
