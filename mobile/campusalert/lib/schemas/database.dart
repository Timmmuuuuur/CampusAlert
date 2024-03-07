import 'package:campusalert/schemas/building.dart';
import 'package:campusalert/schemas/schema.dart';
import 'package:campusalert/schemas/floor.dart';
import 'package:campusalert/schemas/floorlayout.dart';
import 'package:campusalert/schemas/roomedge.dart';
import 'package:campusalert/schemas/roomnode.dart';
import 'package:campusalert/services/room_graph.dart';
import 'package:drift/drift.dart';
// WARNING: Do NOT import flutter packages in here, or else database.g.dart will
// break due to Table name conflict
// Drift is a very janky library, not much we can do about it.
// See here for detail: https://github.com/simolus3/drift/issues/2422

// Necessary imports to open the sqlite3 database
import 'dart:io';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// This will be broken unless you run `dart run build_runner build` without
// error
part 'database.g.dart';

const tablesDeclared = [
  BuildingTable,
  FloorTable,
  FloorLayoutTable,
  RoomEdgeTable,
  RoomEdgeTable,
  RoomNodeTable
];

@DriftDatabase(tables: tablesDeclared)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(onCreate: (Migrator m) async {
      await m.createAll();
    });
  }

  Future<void> clear() {
    return transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }

  Future<void> updateDatabase() async {
    Map<TableInfo, Iterable<Schema>> data = {
      buildingTable: await BuildingFetcher().getAllFromRemote(),
      floorTable: await FloorFetcher().getAllFromRemote(),
      floorLayoutTable: await FloorLayoutFetcher().getAllFromRemote(),
      roomEdgeTable: await RoomEdgeFetcher().getAllFromRemote(),
      roomNodeTable: await RoomNodeFetcher().getAllFromRemote(),
    };

    await clear();

    for (TableInfo t in data.keys) {
      Iterable<Schema>? d = data[t];
      for (Schema di in d!) {
        into(t).insertOnConflictUpdate(di as Insertable<dynamic>);
      }
    }
  }

  Future<List<FloorLayout>> get allFloorLayouts =>
      select(floorLayoutTable).get();
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

LocalDatabase? localDatabase;
RoomGraph? router;

Future<void> initializeDatabase() async {
  // WidgetsFlutterBinding.ensureInitialized();
  localDatabase = LocalDatabase();
  RoomNode.removeAllMemoization();
  Floor.removeAllMemoization();
  Building.removeAllMemoization(); // NOTE: Only static fields are removed!
  router = await RoomGraph.create();
}
