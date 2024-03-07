import 'package:campusalert/api_service.dart';
import 'package:campusalert/local_store.dart';
import 'package:campusalert/main.dart';
import 'package:campusalert/schemas/database.dart';
import 'package:campusalert/services/room_graph.dart';
import 'package:campusalert/services/image_cache.dart';
import 'package:flutter/foundation.dart';

Future<void> preCacheFloorLayouts() async {
  var allFL = await localDatabase!.allFloorLayouts;
  var allUri = allFL.map((fl) => Uri.parse(fl.layoutImageUrl));
  evictAllFromCache(allUri);
  preCacheImages(allUri);
}

abstract mixin class Fetcher {
  Future<Iterable<Schema>> getAllFromRemote() async {
    List<Map<String, dynamic>> all = await getAllFromRemoteRaw();
    return all.map((e) => parseMap(e));
  }

  Future<List<Map<String, dynamic>>> getAllFromRemoteRaw();
  Schema parseMap(Map<String, dynamic> map);

  // A useful helper function that cast a list of dynamics
  // If a dynamic item isn't a T, remove it from the list
  static List<T> castList<T>(List<dynamic> list) {
    List<T> result = [];

    for (var item in list) {
      if (item is T) {
        result.add(item);
      }
    }

    return result;
  }
}

abstract class Schema {}

class SchemaFetcher extends ChangeNotifier {
  final AppContext appContext;
  String? lastUpdate;

  final SPStringPair _lastModifiedDateStore = SPStringPair('lastModifiedDate');

  SchemaFetcher({required this.appContext});

  Future<bool> checkForUpdate() async {
    String latestDate = await getLatestChangeDate();
    return latestDate != await _lastModifiedDateStore.get();
  }

  // Check for update. Return true if update is needed.
  Future<bool> checkForUpdateAndUpdate() async {
    String latestDate = await getLatestChangeDate();

    if (latestDate != await _lastModifiedDateStore.get()) {
      localDatabase!.updateDatabase();
      await updateLatestChangeDate(latestDate);
      await preCacheFloorLayouts();

      router = await RoomGraph.create();

      return true;
    }

    return false;
  }

  // this should only be used for debugging purposes
  Future<void> debugDeleteDate() async {
    await _lastModifiedDateStore.remove();
    notifyListeners();
  }

  Future<String> getLatestChangeDate() async {
    Map<String, dynamic> response =
        await APIService.getCommon("emergency/changes/latest");
    return response["date"];
  }

  Future<void> updateLatestChangeDate(latestDate) async {
    await _lastModifiedDateStore.set(latestDate);
    lastUpdate = latestDate;
    notifyListeners();
  }
}
