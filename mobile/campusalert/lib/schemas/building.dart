import 'package:campusalert/api_service.dart';
import 'package:campusalert/schemas/database.dart';
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

  Building({
    required this.id,
    required this.name,
  });

  // TODO: complete these methods for other schemas
  static Building load(int id, String name) => Building(id: id, name: name);

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return BuildingTableCompanion(
      id: Value(id),
      name: Value(name),
    ).toColumns(nullToAbsent);
  }

  static Future<Building?> getById(int id) async {
    dynamic result = await (localDatabase!.select(localDatabase!.buildingTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return result is Building ? result : null;
  }
}

@UseRowClass(Building, constructor: "load")
class BuildingTable extends Table {

  @override
  Set<Column> get primaryKey => {id};
  
  IntColumn get id => integer()();
  TextColumn get name => text().withLength(max: 255)();
}
