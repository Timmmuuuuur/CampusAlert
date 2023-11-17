import 'package:campusalert/api_service.dart';
import 'package:campusalert/schemas/coordinate.dart';
import 'package:campusalert/schemas/database.dart';
import 'package:campusalert/schemas/floor.dart';
import 'package:campusalert/schemas/schema.dart';
import 'package:drift/drift.dart';

class RoomNodeFetcher with Fetcher {
  @override
  Future<List<Map<String, dynamic>>> getAllFromRemoteRaw() async {
    return Fetcher.castList<Map<String, dynamic>>(
        await APIService.getCommonWithPagination("emergency/room/node/all"));
  }

  @override
  RoomNode parseMap(Map<String, dynamic> map) {
    return RoomNode(
        id: map['id'],
        floorId: map['floor']['id'],
        name: map['name'],
        x: map['x'],
        y: map['y'],
        isExit: map['is_exit'],
        latlong: Coordinate.parseMap(map['latlong']));
  }
}

class RoomNode extends Schema implements Insertable<RoomNode> {
  int id;
  int floorId;
  String name;
  double x;
  double y;
  bool isExit;
  Coordinate latlong;

  RoomNode({
    required this.id,
    required this.floorId,
    required this.name,
    required this.x,
    required this.y,
    required this.isExit,
    required this.latlong,
  });

  Future<Floor> get floor async {
    var f = await Floor.getById(floorId);
    return f!;
  }

  static RoomNode load(
    int id,
    int floorId,
    String name,
    double x,
    double y,
    bool isExit,
    double latitude,
    double longitude,
  ) =>
      RoomNode(
        id: id,
        floorId: floorId,
        name: name,
        x: x,
        y: y,
        isExit: isExit,
        latlong: Coordinate(latitude: latitude, longitude: longitude),
      );

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return RoomNodeTableCompanion(
      id: Value(id),
      floorId: Value(floorId),
      name: Value(name),
      x: Value(x),
      y: Value(y),
      isExit: Value(isExit),
      latitude: Value(latlong.latitude),
      longitude: Value(latlong.longitude),
    ).toColumns(nullToAbsent);
  }

  static Future<RoomNode?> getById(int id) async {
    dynamic result = await (localDatabase!.select(localDatabase!.roomNodeTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return result is RoomNode ? result : null;
  }
}

@UseRowClass(RoomNode, constructor: "load")
class RoomNodeTable extends Table {

  @override
  Set<Column> get primaryKey => {id};

  IntColumn get id => integer()();
  IntColumn get floorId => integer().references(FloorTable, #id)();
  TextColumn get name => text()();
  RealColumn get x => real()();
  RealColumn get y => real()();
  BoolColumn get isExit => boolean()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
}
