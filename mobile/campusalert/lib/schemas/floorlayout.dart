import 'package:campusalert/api_service.dart';
import 'package:campusalert/schemas/database.dart';
import 'package:campusalert/schemas/floor.dart';
import 'package:campusalert/schemas/schema.dart';
import 'package:drift/drift.dart';

class FloorLayoutFetcher with Fetcher {
  @override
  Future<List<Map<String, dynamic>>> getAllFromRemoteRaw() async {
    return Fetcher.castList<Map<String, dynamic>>(
        await APIService.getCommonWithPagination("emergency/floorlayout/all"));
  }

  @override
  Schema parseMap(Map<String, dynamic> map) {
    return FloorLayout(
      id: map['id'],
      name: map['name'],
      layoutImageUrl: map['layout_image'],
    );
  }
}

class FloorLayout extends Schema implements Insertable<FloorLayout> {
  int id;
  String name;
  String layoutImageUrl;

  FloorLayout({
    required this.id,
    required this.name,
    required this.layoutImageUrl,
  });

  static FloorLayout load(int id, String name, String layoutImageUrl) =>
      FloorLayout(id: id, name: name, layoutImageUrl: layoutImageUrl);

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return FloorLayoutTableCompanion(
            id: Value(id),
            name: Value(name),
            layoutImageUrl: Value(layoutImageUrl))
        .toColumns(nullToAbsent);
  }

  static Future<FloorLayout?> getById(int id) async {
    dynamic result =
        await (localDatabase!.select(localDatabase!.floorLayoutTable)
              ..where((t) => t.id.equals(id)))
            .getSingleOrNull();
    return result is FloorLayout ? result : null;
  }
}

@UseRowClass(FloorLayout, constructor: "load")
class FloorLayoutTable extends Table {

  @override
  Set<Column> get primaryKey => {id};

  IntColumn get id => integer()();
  TextColumn get name => text().withLength(max: 255)();
  TextColumn get layoutImageUrl => text()();
}
