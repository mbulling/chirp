import 'package:flutter/material.dart';
import 'shared_structs.dart';
import 'common.dart';

class SavedRegionsPage extends StatefulWidget {
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

  Future<void> _getRegions() async {
    try {
      final List<Region> regions = await getRegions();
      setState(() {
        regionList = regions;
      });
    } catch (e) {
      setState(() {
        regionList = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe5eaee),
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
              child: Text('no saved regions'),
            )
          : ListView.builder(
              itemCount: regionList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(regionList[index].name),
                  subtitle:
                      Text('Active Users: ${regionList[index].active_users}\n'
                          'Latitude: ${regionList[index].latitude}\n'
                          'Longitude: ${regionList[index].longitude}\n'
                          'Radius: ${regionList[index].radius}'),
                );
              },
            ),
    );
  }
}
