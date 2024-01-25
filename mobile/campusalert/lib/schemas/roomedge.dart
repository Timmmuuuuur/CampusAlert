import 'package:campusalert/api_service.dart';
import 'package:campusalert/schemas/database.dart';
import 'package:campusalert/schemas/roomnode.dart';
import 'package:campusalert/schemas/schema.dart';
import 'package:drift/drift.dart';

class RoomEdge extends Schema implements Insertable<RoomEdge> {
  int id;

  // NOTE: it's possible for roomIds to be of length 1 if the edge is reflexive
  Set<int> roomIds;

  RoomEdge({
    required this.id,
    required this.roomIds,
  });

  Future<Set<RoomNode>> get rooms async {
    Set<RoomNode> result = {};
    for (var i in roomIds) {
      var r = await RoomNode.getById(i);
      result.add(r!);
    }

    return result;
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    var roomIdsList = roomIds.toList();
    return RoomEdgeTableCompanion(
      id: Value(id),
      roomId1: Value(roomIdsList[0]),
      roomId2: Value(roomIdsList[1]),
    ).toColumns(nullToAbsent);
  }

  static RoomEdge load(int id, int roomId1, int roomId2) =>
      RoomEdge(id: id, roomIds: {roomId1, roomId2});
}

class RoomEdgeFetcher with Fetcher {
  @override
  Future<List<Map<String, dynamic>>> getAllFromRemoteRaw() async {
    return Fetcher.castList<Map<String, dynamic>>(
        await APIService.getCommonWithPagination("emergency/room/edge/all"));
  }

  @override
  RoomEdge parseMap(Map<String, dynamic> map) {
    return RoomEdge(
      id: map['id'],
      roomIds: <int>{map['nodes'][0]['id'], map['nodes'][1]['id']},
    );
  }
}

@UseRowClass(RoomEdge, constructor: "load")
class RoomEdgeTable extends Table {

  IntColumn get id => integer()();

  @override
  Set<Column> get primaryKey => {id};
  IntColumn get roomId1 => integer().references(RoomNodeTable, #id)();
  IntColumn get roomId2 => integer().references(RoomNodeTable, #id)();
}
