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

  Set<RoomNode>? _allRoomNodesMemoization;
  Set<RoomEdge>? _allRoomEdgesMemoization;

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

  Future<Set<RoomNode>> get allRoomNodes async {
    _allRoomNodesMemoization ??= (await (localDatabase!.roomNodeTable.select()
              ..where((u) => u.floorId.equals(id)))
            .get())
        .toSet();

    return _allRoomNodesMemoization!;
  }

  Future<Set<RoomEdge>> get allRoomEdges async {
    Set<RoomEdge> roomEdgeUniverse =
        (await (localDatabase!.roomEdgeTable.select()).get()).toSet();
    Set<int> roomNodeAsIds =
        (await allRoomNodes).map((roomNode) => roomNode.id).toSet();

    _allRoomEdgesMemoization ??= roomEdgeUniverse.where((roomEdge) => roomEdge.roomIds.any(roomNodeAsIds.contains)).toSet();

    return _allRoomEdgesMemoization!;
  }

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
