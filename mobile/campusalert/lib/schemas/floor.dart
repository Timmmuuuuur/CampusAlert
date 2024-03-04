import 'dart:math';
import 'dart:ui';

import 'package:campusalert/api_service.dart';
import 'package:campusalert/schemas/building.dart';
import 'package:campusalert/schemas/coordinate.dart';
import 'package:campusalert/schemas/database.dart';
import 'package:campusalert/schemas/floorlayout.dart';
import 'package:campusalert/schemas/roomedge.dart';
import 'package:campusalert/schemas/roomnode.dart';
import 'package:campusalert/schemas/schema.dart';
import 'package:drift/drift.dart';

class Floor extends Schema implements Insertable<Floor> {
  int id;
  int buildingId;
  int floorLayoutId;
  int floorNumber;
  String name;
  Coordinate topLeft;
  Coordinate topRight;
  Coordinate bottomLeft;

  static Set<RoomNode>? _allRoomNodesMemoization;
  static Set<RoomEdge>? _allRoomEdgesMemoization;
  static Set<Floor>? _allFloorsMemoization;

  Floor({
    required this.id,
    required this.buildingId,
    required this.floorLayoutId,
    required this.floorNumber,
    required this.name,
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
  });

  static void removeAllMemoization() {
    _allRoomEdgesMemoization = null;
    _allRoomNodesMemoization = null;
  }

  Future<Building> get building async {
    var b = await Building.getById(buildingId);
    return b!;
  }

  Future<FloorLayout> get floorLayout async {
    var fl = await FloorLayout.getById(floorLayoutId);
    if (fl == null) {
      throw Exception(
          "No floorLayoutId exists with id $floorLayoutId, which is stored by $this");
    }
    return fl;
  }

  static Future<Set<Floor>> all() async {
    _allFloorsMemoization ??=
        (await (localDatabase!.floorTable.select()).get()).toSet();

    return _allFloorsMemoization!;
  }

  Future<Set<RoomNode>> get allRoomNodes async {
    _allRoomNodesMemoization ??= (await (localDatabase!.roomNodeTable.select()
              ..where((u) => u.floorId.equals(id)))
            .get())
        .toSet();

    return _allRoomNodesMemoization!;
  }

  static double _distance(double x1, double y1, double x2, double y2) {
    return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
  }

  Future<RoomNode?> closestRoomNode(Offset point) async {
    var roomNodes = await allRoomNodes;
    if (roomNodes.isEmpty) {
      return null;
    }

    RoomNode closest = roomNodes.first;
    double minDistance =
        _distance(roomNodes.first.x, roomNodes.first.y, point.dx, point.dy);

    for (var roomNode in roomNodes) {
      double distance = _distance(roomNode.x, roomNode.y, point.dx, point.dy);
      if (distance < minDistance) {
        minDistance = distance;
        closest = roomNode;
      }
    }

    return closest;
  }

  Future<Set<RoomEdge>> get allRoomEdges async {
    Set<RoomEdge> roomEdgeUniverse =
        (await (localDatabase!.roomEdgeTable.select()).get()).toSet();
    Set<int> roomNodeAsIds =
        (await allRoomNodes).map((roomNode) => roomNode.id).toSet();

    _allRoomEdgesMemoization ??= roomEdgeUniverse
        .where((roomEdge) => roomEdge.roomIds.any(roomNodeAsIds.contains))
        .toSet();

    return _allRoomEdgesMemoization!;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Floor && id == other.id);

  @override
  int get hashCode => id.hashCode;

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return FloorTableCompanion(
      id: Value(id),
      buildingId: Value(buildingId),
      floorLayoutId: Value(floorLayoutId),
      floorNumber: Value(floorNumber),
      name: Value(name),
      topLeftLatitude: Value(topLeft.latitude),
      topLeftLongitude: Value(topLeft.longitude),
      topRightLatitude: Value(topRight.latitude),
      topRightLongitude: Value(topRight.longitude),
      bottomLeftLatitude: Value(bottomLeft.latitude),
      bottomLeftLongitude: Value(bottomLeft.longitude),
    ).toColumns(nullToAbsent);
  }

  @override
  String toString() {
    return "Floor $floorNumber";
  }

  // Future<DenormFloor> denormalize() async {
  //   return DenormFloor(
  //     id: this.id,
  //     imageUrl: this.floorLayout
  //     buildingId: this.buildingId,

  //   )
  // }

  static Future<Floor?> getById(int id) async {
    dynamic result = await (localDatabase!.select(localDatabase!.floorTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return result is Floor ? result : null;
  }

  static Floor load(
      int id,
      int buildingId,
      int floorLayoutId,
      int floorNumber,
      String name,
      double topLeftLatitude,
      double topLeftLongitude,
      double topRightLatitude,
      double topRightLongitude,
      double bottomLeftLatitude,
      double bottomLeftLongitude) {
    return Floor(
        id: id,
        buildingId: buildingId,
        floorLayoutId: floorLayoutId,
        floorNumber: floorNumber,
        name: name,
        topLeft:
            Coordinate(latitude: topLeftLatitude, longitude: topLeftLongitude),
        topRight: Coordinate(
            latitude: topRightLatitude, longitude: topRightLongitude),
        bottomLeft: Coordinate(
            latitude: bottomLeftLatitude, longitude: bottomLeftLongitude));
  }
}

class FloorFetcher with Fetcher {
  @override
  Future<List<Map<String, dynamic>>> getAllFromRemoteRaw() async {
    return Fetcher.castList<Map<String, dynamic>>(
        await APIService.getCommonWithPagination("emergency/floor/all"));
  }

  @override
  Schema parseMap(Map<String, dynamic> map) {
    return Floor(
        id: map['id'],
        buildingId: map['building']['id'],
        floorLayoutId: map['layout']['id'],
        floorNumber: map['floor_number'],
        name: map['name'],
        topLeft: Coordinate.parseMap(map['topleft']),
        topRight: Coordinate.parseMap(map['topright']),
        bottomLeft: Coordinate.parseMap(map['bottomleft']));
  }
}

@UseRowClass(Floor, constructor: "load")
class FloorTable extends Table {
  RealColumn get bottomLeftLatitude => real()();

  RealColumn get bottomLeftLongitude => real()();
  IntColumn get buildingId => integer().references(BuildingTable, #id)();
  IntColumn get floorLayoutId => integer().references(FloorLayoutTable, #id)();
  IntColumn get floorNumber => integer()();
  IntColumn get id => integer()();

  TextColumn get name => text().withLength(max: 255)();
  @override
  Set<Column> get primaryKey => {id};

  RealColumn get topLeftLatitude => real()();
  RealColumn get topLeftLongitude => real()();

  RealColumn get topRightLatitude => real()();
  RealColumn get topRightLongitude => real()();
}
