import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'user_profile.dart';
import 'saved_page.dart';
import 'common.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Position _userPosition;
  late String _locationName;
  late int _userIdentity;

  @override
  void initState() async {
    Position position = await getPosition();
    String positionName = await getPositionName(position);
    int userId = createUserId();
    setState(() {
      _userPosition = position;
      _locationName = positionName;
      _userIdentity = userId;
    });
    super.initState();
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
                  userIdentity: _userIdentity.toString()),
              UserProfilePage(userIdentity: _userIdentity),
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
}
