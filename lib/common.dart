import 'package:chirp/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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

Future<List<Message>> getMessages() async {
  List<Message> messages = [];
  QuerySnapshot<Message> querySnapshot = await messageRef.get();
  for (QueryDocumentSnapshot<Message> documentSnapshot in querySnapshot.docs) {
    messages.add(documentSnapshot.data());
  }
  return messages;
}

@immutable
class Message {
  Message({required this.message, required this.zone});

  Message.fromJson(Map<String, Object?> json)
      : this(message: json["message"] as String, zone: json["zone"] as String);

  final String message;
  final String zone;

  Map<String, Object?> toJson() {
    return {'message': message, 'zone': zone};
  }
}
