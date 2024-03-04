// import 'package:campusalert/components/image_overlay.dart';
// import 'package:campusalert/components/title.dart' as title;
// import 'package:campusalert/schemas/database.dart';
// import 'package:campusalert/schemas/floor.dart';
// import 'package:campusalert/schemas/floorlayout.dart';
// import 'package:campusalert/schemas/roomedge.dart';
// import 'package:campusalert/schemas/roomnode.dart';
// import 'package:drift/drift.dart';
// import 'package:flutter/widgets.dart';


// // TODO: we need a "flattened" room representation so that we no longer need to worry about querying the database, where each room instead references a building, and contains a set of other nodes it is connected to!

// // TODO: rewrite this such that it contains every node, edges, floor and floorlayout
// // Has a member function which returns a list of nodes and edges to draw given an A* result (series of nodes) and a floor
// // also make an A* function that returns a series of denormroomnodes

// class FloorLayoutEvaluator {
//   // this includes every floor and room
//   final Floor floor;
//   late Set<RoomNode> nodes;

//   FloorLayoutEvaluator(required this.floor) {
//     this.nodes = floor.allRoomNodes; // allRoomNodes return a Future<Set<RoomNode>>
//   }
// }

// class FloorLayoutDisplay extends StatelessWidget {
//   late final Floor floor;
//   late final Future<FloorLayout> floorLayout;

//   FloorLayoutDisplay(this.floor);

//   @override
//   Widget build(BuildContext context) {
//     String floorName = floor.name;
//     floorLayout = floor.floorLayout;
//     var nodes = (localDatabase!.roomNodeTable.select()..where((u) => u.floorId.equals(floor.id))).get();
//     var edges = (localDatabase!.roomEdgeTable.select()..where((u) => u.roomId1.floorId.equals(floor.id))).get();

//     return Column(
//         children: [title.Title(text: "Map of $floorName"), 
//         FutureBuilder(
//           future: Future.wait([
//             floor.floorLayout,
//             floor.allRoomNodes,
//             floor.allRoomEdges,
//           ]),
//           builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
//             FloorLayout floorLayout = snapshot.data?[0] as FloorLayout;
//             Set<RoomNode> nodes = snapshot.data?[1] as Set<RoomNode>;
//             Set<RoomEdge> edges = snapshot.data?[2] as Set<RoomEdge>;

//             return ImageWithOverlay(
//               imageUrl: floorLayout.layoutImageUrl,
              
//             );
//           }
//         )
//     ]);
//   }
// }
