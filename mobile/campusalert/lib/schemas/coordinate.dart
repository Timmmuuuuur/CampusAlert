import 'package:latlong2/latlong.dart';

class Coordinate {
  double latitude;
  double longitude;

  Coordinate({
    required this.latitude,
    required this.longitude,
  });

  static Coordinate parseList(List<double> list) {
    return Coordinate(
      latitude: list[0],
      longitude: list[1],
    );
  }

  static Coordinate parseMap(Map<String, dynamic> map) {
    return Coordinate(
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }

  /* static Coordinate load(int id, double latitude, double longitude) =>
      Coordinate(latitude: latitude, longitude: longitude); */

  /* @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return CoordinateTableCompanion(
            latitude: Value(latitude), longitude: Value(longitude))
        .toColumns(nullToAbsent);
  } */

  /* static Future<Coordinate?> getById(int id) async {
    dynamic result = await (localDatabase!.select(localDatabase!.coordinateTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return result is Coordinate ? result : null;
  } */
}

// @UseRowClass(Coordinate, constructor: "load")
// class CoordinateTable extends Table {
//   @override
//   List<Set<Column>> get uniqueKeys => [
//         {id}
//       ];

//   IntColumn get id => integer().autoIncrement()();
//   RealColumn get latitude => real()();
//   RealColumn get longitude => real()();
// }
