import 'package:campusalert/api_service.dart';
import 'package:campusalert/schemas/building.dart';
import 'package:campusalert/schemas/coordinate.dart';
import 'package:campusalert/schemas/database.dart';
import 'package:campusalert/schemas/floorlayout.dart';
import 'package:campusalert/schemas/schema.dart';
import 'package:drift/drift.dart';

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

class Floor extends Schema implements Insertable<Floor> {
  int id;
  int buildingId;
  int floorLayoutId;
  int floorNumber;
  String name;
  Coordinate topLeft;
  Coordinate topRight;
  Coordinate bottomLeft;

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

  static Future<Floor?> getById(int id) async {
    dynamic result = await (localDatabase!.select(localDatabase!.floorTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return result is Floor ? result : null;
  }
}

@UseRowClass(Floor, constructor: "load")
class FloorTable extends Table {

  @override
  Set<Column> get primaryKey => {id};

  IntColumn get id => integer()();
  IntColumn get buildingId => integer().references(BuildingTable, #id)();
  IntColumn get floorLayoutId => integer().references(FloorLayoutTable, #id)();
  IntColumn get floorNumber => integer()();
  TextColumn get name => text().withLength(max: 255)();

  RealColumn get topLeftLatitude => real()();
  RealColumn get topLeftLongitude => real()();

  RealColumn get topRightLatitude => real()();
  RealColumn get topRightLongitude => real()();

  RealColumn get bottomLeftLatitude => real()();
  RealColumn get bottomLeftLongitude => real()();
}
