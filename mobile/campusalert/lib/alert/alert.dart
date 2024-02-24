import 'package:campusalert/alert/threat.dart';
import 'package:campusalert/api_service.dart';
import 'package:campusalert/schemas/building.dart';
import 'package:campusalert/schemas/floor.dart';
import 'package:campusalert/schemas/roomnode.dart';

class SyncAlert {
  final int id;
  SyncThreat? threat;
  Building? building;
  Floor? floor;
  RoomNode? roomNode;

  SyncAlert(
      {required this.id,
      this.threat,
      this.building,
      this.floor,
      this.roomNode});

  Map<String, dynamic> serialize() {
    Map<String, dynamic> m = {
      "syncThreat": threat?.serialized,
      "building": building?.id,
      "floor": floor?.id,
      "roomNode": roomNode?.id
    };
    Map<String, dynamic> n = {};

    // erase keys mapping to null
    for (String k in m.keys) {
      if (m[k] != null) {
        n[k] = m[k];
      }
    }

    return n;
  }

  static Future<SyncAlert> deserialize(Map<String, dynamic> m) async {
    return SyncAlert(
      id: m['id'],
      threat: m['syncThreat'] != null ? SyncThreat.fromString(m['syncThreat']) : null,
      building: m['building'] != null ? await Building.getById(m['building']['id']) : null,
      floor: m['floor'] != null ? await Floor.getById(m['floor']['id']) : null,
      roomNode: m['roomNode'] != null ? await RoomNode.getById(m['roomNode']['id']) : null,
    );
  }

  // If there's no active alert, null is returned
  static Future<SyncAlert?> getActive() async {
    var m = await APIService.getCommon("emergency/alert/get-active/");
    return m['active_alert'] ? await SyncAlert.deserialize(m) : null;
  }

  static void createActive() {
    APIService.postCommon("emergency/alert/create/", {});
  }

  static void updateActive(SyncAlert alert) {
    APIService.putCommon("emergency/alert/update-active/", alert.serialize());
  }

  void updateToActive() {
    updateActive(this);
  }
}
