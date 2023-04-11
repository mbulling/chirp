import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'message_view.dart';
import 'shared_structs.dart';
import 'home_page.dart';
import 'region_logic.dart';
import 'common.dart';

class SavedRegionsPage extends StatefulWidget {
  final Position userPosition;
  final String userIdentity;

  const SavedRegionsPage(
      {Key? key, required this.userPosition, required this.userIdentity})
      : super(key: key);

  @override
  _SavedRegionsPageState createState() => _SavedRegionsPageState();
}

class _SavedRegionsPageState extends State<SavedRegionsPage> {
  List<Region> regionList = [];

  @override
  void initState() {
    super.initState();
    _getRegions();
  }

  List<Region> validRegions(List<Region> allRegions) {
    List<Region> validRegions = [];
    for (Region region in allRegions) {
      if (region.latitude != null &&
          region.longitude != null &&
          inRegion(region, widget.userPosition)) {
        validRegions.add(region);
      }
    }
    return validRegions;
  }

  Future<void> _getRegions() async {
    try {
      final List<Region> regions = await getRegions();
      setState(() {
        regionList = validRegions(regions);
      });
    } catch (e) {
      setState(() {
        regionList = [];
      });
    }
  }

  void _navigateToMessageView(BuildContext context, Region region) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
            userPosition: widget.userPosition,
            userIdentity: int.parse(widget.userIdentity),
            region: region),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: Text('regions'),
        backgroundColor: Color.fromARGB(255, 19, 64, 100),
        actions: [
          IconButton(
            onPressed: () {
              // show dialog to add a new region
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  String newRegionName = '';
                  return AlertDialog(
                    title: Text('save region'),
                    content: TextField(
                      onChanged: (value) {
                        newRegionName = value;
                      },
                      decoration: InputDecoration(hintText: 'region'),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('save'),
                        onPressed: () {
                          // implement saveRegion(newRegionName);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: regionList.isEmpty
          ? Center(
              child: Stack(
              children: [
                Container(color: Colors.black),
                Text('no saved regions')
              ],
            ))
          : ListView.builder(
              itemCount: regionList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    _navigateToMessageView(context, regionList[index]);
                  },
                  child: ListTile(
                    tileColor: Colors.black,
                    title: Text(
                      regionList[index].name,
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    subtitle: Text(
                      'active Users: ${regionList[index].active_users}\n',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
