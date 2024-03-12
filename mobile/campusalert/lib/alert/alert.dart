import 'dart:async'; // Import the dart:async library for using Timer
import 'dart:convert';
import 'package:campusalert/alert/threat.dart';
import 'package:campusalert/api_service.dart';
import 'package:campusalert/schemas/building.dart';
import 'package:campusalert/schemas/floor.dart';
import 'package:campusalert/schemas/roomnode.dart';
import 'package:http/http.dart' as http;

class SyncAlert {
  final int id;
  SyncThreat? threat;
  Building? building;
  Floor? floor;
  RoomNode? roomNode;

  SyncAlert({
    required this.id,
    this.threat,
    this.building,
    this.floor,
    this.roomNode,
  });

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

  static Timer? _timer; // Timer object to schedule periodic execution

  // Method to start periodic execution of getActive()
  static void startFetchingActive() {
    // Cancel the previous timer if it's active
    _timer?.cancel();
    // Schedule periodic execution of getActive() every couple of seconds
    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      getActive(); // Call getActive() method
    });
  }

  // Method to stop periodic execution of getActive()
  static void stopFetchingActive() {
    // Cancel the timer
    _timer?.cancel();
  }

  // Method to fetch the active alert
  static Future<SyncAlert?> getActive() async {
    print("-----reading from active----");

    var m = await APIService.getCommon("emergency/alert/get-active/");
    if (m != null && m is Map<String, dynamic>) {
      // Parse the JSON response into a Map<String, dynamic>
    Map<String, dynamic> response = m;

    // Access the value of "active_alert" from the map
    bool activeAlert = response['active_alert'];

    // Now you have the value of "active_alert"
    print(activeAlert);

    }
    
  
    startFetchingActive();
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
