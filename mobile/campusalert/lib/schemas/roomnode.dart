import 'package:campusalert/api_service.dart';
import 'package:campusalert/schemas/coordinate.dart';
import 'package:campusalert/schemas/database.dart';
import 'package:campusalert/schemas/floor.dart';
import 'package:campusalert/schemas/schema.dart';
import 'package:campusalert/services/a_star.dart';
import 'package:drift/drift.dart';

class RoomNode extends Schema with Node<RoomNode> implements Insertable<RoomNode> {
  int id;
  int floorId;
  String name;
  double x;
  double y;
  bool isExit;
  Coordinate latlong;
  Set<RoomNode>? _neighbourMemoization;
  static Set<RoomNode>? _allNodesMemoization;

  RoomNode({
    required this.id,
    required this.floorId,
    required this.name,
    required this.x,
    required this.y,
    required this.isExit,
    required this.latlong,
  });

  // Override == to compare instances based on id
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is RoomNode && id == other.id);

  // Override hashCode to ensure consistency with ==
  @override
  int get hashCode => id.hashCode;

  Future<Set<RoomNode>> get neighbours async {
    if (_neighbourMemoization == null) {
      var result = await (localDatabase!.roomEdgeTable.select()
            ..where((u) => u.roomId1.equals(id) | u.roomId2.equals(id)))
          .get();
      var neighboursId = result
          .map((edge) => edge.roomIds)
          .reduce((value, element) => value.union(element));
      // We always remove ourselves since we don't care about reflexive edges
      neighboursId.remove(id);
      var neighbours =
          await Future.wait(neighboursId.map((id) => RoomNode.getById(id)));
      _neighbourMemoization = neighbours.nonNulls.toSet();
    }

    return _neighbourMemoization!;
  }

  static Future<Set<RoomNode>> get allNodes async {
    _allNodesMemoization ??=
        (await (localDatabase!.roomNodeTable.select()).get()).toSet();
    return _allNodesMemoization!;
  }

  Future<Floor> get floor async {
    var f = await Floor.getById(floorId);
    return f!;
  }

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
}

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

@UseRowClass(RoomNode, constructor: "load")
class RoomNodeTable extends Table {
  IntColumn get floorId => integer().references(FloorTable, #id)();

  IntColumn get id => integer()();
  BoolColumn get isExit => boolean()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get name => text()();
  @override
  Set<Column> get primaryKey => {id};
  RealColumn get x => real()();
  RealColumn get y => real()();
}
