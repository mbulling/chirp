import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'home_page.dart';
import 'user_profile.dart';
import 'saved_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'common.dart';
import 'dart:math';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(MyApp());
}

int generateUserIdentity() {
  Random random = new Random();
  return random.nextInt(999999);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: TabBarView(
            children: [
              HomePage(), // replace this line with HomePage widget from home_page.dart
              SavedRegionsPage(),
              UserProfilePage(userIdentity: generateUserIdentity()),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFFe5eaee),
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              labelColor: Color(0xFF023258),
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(
                  icon: Icon(Icons.home),
                  text: 'home',
                ),
                Tab(
                  icon: Icon(Icons.save),
                  text: 'saved',
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
}
