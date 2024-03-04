import 'package:campusalert/api_service.dart';
import 'package:campusalert/schemas/database.dart';
import 'package:campusalert/schemas/floor.dart';
import 'package:campusalert/schemas/schema.dart';
import 'package:drift/drift.dart';

class BuildingFetcher with Fetcher {
  @override
  Future<List<Map<String, dynamic>>> getAllFromRemoteRaw() async {
    return Fetcher.castList<Map<String, dynamic>>(
        await APIService.getCommonWithPagination("emergency/building/all"));
  }

  @override
  Building parseMap(Map<String, dynamic> map) {
    return Building(
      id: map['id'],
      name: map['name'],
    );
  }
}

class Building extends Schema implements Insertable<Building> {
  int id;
  String name;

  static Set<Building>? _allBuildingsMemoization;
  Set<Floor>? _allFloorsMemoization;

  Building({
    required this.id,
    required this.name,
  });

  static void removeAllMemoization() {
    _allBuildingsMemoization = null;
  }

  // TODO: complete these methods for other schemas
  static Building load(int id, String name) => Building(id: id, name: name);

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return BuildingTableCompanion(
      id: Value(id),
      name: Value(name),
    ).toColumns(nullToAbsent);
  }

  Future<Set<Floor>> allFloors() async {
    _allFloorsMemoization ??=
        (await (localDatabase!.select(localDatabase!.floorTable)
                  ..where((t) => t.buildingId.equals(id)))
                .get())
            .toSet();

    return _allFloorsMemoization!;
  }

  @override
  String toString() {
    return name;
  }

  static Future<Building?> getById(int id) async {
    dynamic result = await (localDatabase!.select(localDatabase!.buildingTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return result is Building ? result : null;
  }

  static Future<Set<Building>> all() async {
    _allBuildingsMemoization ??=
        (await (localDatabase!.buildingTable.select()).get()).toSet();

    return _allBuildingsMemoization!;
  }
}

@UseRowClass(Building, constructor: "load")
class BuildingTable extends Table {
  @override
  Set<Column> get primaryKey => {id};

  IntColumn get id => integer()();
  TextColumn get name => text().withLength(max: 255)();
}
