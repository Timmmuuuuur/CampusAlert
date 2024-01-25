import 'package:campusalert/alert/threat.dart';
import 'package:campusalert/schemas/building.dart';
import 'package:campusalert/schemas/floor.dart';
import 'package:campusalert/schemas/roomnode.dart';
import 'package:uuid/uuid.dart';

var uuidFactory = Uuid();

class SyncAlert {
  final String uuid;
  SyncThreat? threat;
  Building? building;
  Floor? floor;
  RoomNode? room;

  SyncAlert()
      : uuid = uuidFactory.v1(),
        threat = null,
        building = null,
        floor = null,
        room = null;
}
