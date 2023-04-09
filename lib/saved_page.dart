import 'package:flutter/material.dart';

class SavedRegionsPage extends StatefulWidget {
  @override
  _SavedRegionsPageState createState() => _SavedRegionsPageState();
}

class _SavedRegionsPageState extends State<SavedRegionsPage> {
  List<String> savedRegions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          setState(() {
                            savedRegions.add(newRegionName);
                          });
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
      body: savedRegions.isEmpty
          ? Center(
              child: Text('no saved regions'),
            )
          : ListView.builder(
              itemCount: savedRegions.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(savedRegions[index]),
                );
              },
            ),
    );
  }
}
