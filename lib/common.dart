import 'package:chirp/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'shared_structs.dart';

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


// class Message {
//   Message(
//       {required this.content,
//       required this.zone,
//       required this.author,
//       required this.time});

//   Message.fromJson(Map<String, Object?> json)
//       : this(
//             content: json["content"] as String,
//             zone: json["zone"] as String,
//             author: json["author"] as String,
//             time: json["time"] as String);

//   final String content;
//   final String zone;
//   final String author;
//   final String time;

//   Map<String, Object?> toJson() {
//     return {'message': content, 'zone': zone, 'author': author, 'time': time};
//   }
// }
