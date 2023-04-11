import 'dart:math';
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
  List<Offset> regionPositions = [];

  @override
  void initState() {
    super.initState();
    _getRegions();
  }

  // Function to calculate the angle between two points
  double angleBetweenPoints(Offset a, Offset b) {
    return atan2(b.dy - a.dy, b.dx - a.dx);
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
    // sort regions by radius in ascending order
    regionList.sort((a, b) => a.radius.compareTo(b.radius));

    // get the region with the smallest radius
    final smallestRegion = regionList.first;

    // calculate the region size based on the screen size
    final smallestRegionSize = min(MediaQuery.of(context).size.width * 0.4,
        MediaQuery.of(context).size.height * 0.4);

    // calculate the position of the smallest region
    final smallestRegionPosition = Offset(
        (MediaQuery.of(context).size.width - smallestRegionSize) / 2.0,
        (MediaQuery.of(context).size.height - smallestRegionSize) / 3.0);

    // calculate the positions of the other regions
    regionPositions.clear();
    double spacing = 2 * pi / (regionList.length - 1);
    List<double> angles = [];

    for (int i = 1; i < regionList.length; i++) {
      var random = Random();
      double angle = random.nextDouble() * (pi);
      while (angles.contains(angle)) {
        angle = random.nextDouble() * pi;
      }
      angles.add(angle);
      final regionSize = min(MediaQuery.of(context).size.width * 0.15,
          MediaQuery.of(context).size.height * 0.15);
      final radiusSum = smallestRegionSize / 2 + regionSize / 2;
      final position = Offset(
          smallestRegionPosition.dx +
              smallestRegionSize / 2 +
              radiusSum * cos(angle),
          smallestRegionPosition.dy +
              smallestRegionSize / 2 +
              radiusSum * sin(angle));
      regionPositions.add(position - Offset(regionSize / 2, regionSize / 2));
      angle += spacing;
    }

    return Scaffold(
      backgroundColor: Color(0xFFe5eaee),
      appBar: AppBar(
        title: Text('regions'),
        backgroundColor: Color.fromARGB(255, 19, 64, 100),
        actions: [
          IconButton(
            onPressed: () {
              // show dialog to add a new region
              // ...
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              // draw other regions
              ...regionList
                  .where((region) => region != smallestRegion)
                  .map((region) {
                final index = regionList.indexOf(region);
                final regionSize = min(MediaQuery.of(context).size.width * 0.15,
                    MediaQuery.of(context).size.height * 0.15);
                final position = regionPositions[index - 1];
                return Positioned(
                  left: position.dx,
                  top: position.dy,
                  child: GestureDetector(
                    onTap: () {
                      _navigateToMessageView(context, region);
                    },
                    child: Container(
                      width: regionSize.toDouble(),
                      height: regionSize.toDouble(),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            region.name,
                            style: TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Active Users: ${region.active_users}',
                            style: TextStyle(fontSize: 8),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
              Positioned(
                left: smallestRegionPosition.dx,
                top: smallestRegionPosition.dy,
                child: GestureDetector(
                  onTap: () {
                    _navigateToMessageView(context, smallestRegion);
                  },
                  child: Container(
                    width: smallestRegionSize.toDouble(),
                    height: smallestRegionSize.toDouble(),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          smallestRegion.name,
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Active Users: ${smallestRegion.active_users}',
                          style: TextStyle(fontSize: 8),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// helper function to calculate the position of a new region
  Offset _getRegionPosition(double regionSize) {
// set the initial position at the center of the screen
    var position = Offset(
      (MediaQuery.of(context).size.width - regionSize) / 2.0,
      (MediaQuery.of(context).size.height - regionSize) / 2.0,
    );
// check if the initial position overlaps with any existing regions
    for (var existingPosition in regionPositions) {
      var direction = (position - existingPosition).direction;
      var distance = (position - existingPosition).distance;
      var radiusSum = regionSize / 2.0 + existingPosition.distance * 0.5;
      if (distance < radiusSum) {
        // adjust the position to ensure regions are touching
        position += Offset.fromDirection(direction, radiusSum - distance);
      }
    }

// check for screen boundaries and adjust the position accordingly
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double leftBoundary = 0.0;
    double topBoundary = 0.0;
    double rightBoundary = screenWidth - regionSize;
    double bottomBoundary = screenHeight - regionSize;

// Check if the new position is within screen boundaries
    if (position.dx < leftBoundary) {
      position = Offset(leftBoundary, position.dy);
    } else if (position.dx > rightBoundary) {
      position = Offset(rightBoundary, position.dy);
    }
    if (position.dy < topBoundary) {
      position = Offset(position.dx, topBoundary);
    } else if (position.dy > bottomBoundary) {
      position = Offset(position.dx, bottomBoundary);
    }

    return position;
  }
}
