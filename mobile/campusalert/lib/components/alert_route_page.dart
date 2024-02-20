import 'package:campusalert/components/image_overlay.dart';
import 'package:campusalert/components/radio_selection.dart';
import 'package:campusalert/main.dart';
import 'package:campusalert/alert/threat.dart';
import 'package:campusalert/schemas/building.dart';
import 'package:campusalert/schemas/database.dart';
import 'package:campusalert/schemas/floor.dart';
import 'package:campusalert/schemas/roomnode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<AlertRoutePage> defaultPages() {
  return [
    ThreatTypePage(),
    BuildingFindingPage(),
    FloorFindingPage(),
    RoomNodeFindingPage(),
  ];
}

class AlertRoutePage extends StatelessWidget {
  final String title;
  final bool canPop; // Whether user is allowed to go to previous apge
  final Widget Function(AppState) form;
  final bool Function(AppState) nextButtonEnabledCallback;
  final Future<void> Function(AppState) onNextPageCallback;

  AlertRoutePage? nextPage;

  AlertRoutePage({
    required this.title,
    required this.canPop,
    required this.form,
    required this.nextButtonEnabledCallback,
    required this.onNextPageCallback,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return PopScope(
        canPop: canPop,
        child: Scaffold(
          appBar: AppBar(
            title: Text("REMAIN CALM",
                style: TextStyle(
                    fontSize: 27,
                    color: Colors.red,
                    fontWeight: FontWeight.w900)),
            automaticallyImplyLeading: false,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title),
              form(appState),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: nextButtonEnabledCallback(appState)
                    ? () async {
                        if (nextPage == null) {
                          await onNextPageCallback(appState);
                          nextPage = appState.alertRoute.next(context);
                        }
                      }
                    : null,
                child: Text('Next Page'),
              ),
            ],
          ),
        ));
  }
}

class ThreatTypePage extends AlertRoutePage {
  ThreatTypePage()
      : super(
          title: "WHAT THREAT ARE YOU EXPERIENCING?",
          canPop: false,
          form: (appState) => Center(
            child: DropdownButton<SyncThreat>(
              value: appState.selectedSyncThreat,
              onChanged: (SyncThreat? newValue) {
                if (newValue != null) {
                  appState.updateSelectedSyncThreat(newValue);
                }
              },
              items: SyncThreat.values
                  .map<DropdownMenuItem<SyncThreat>>((SyncThreat value) {
                return DropdownMenuItem<SyncThreat>(
                  value: value,
                  child: Text(value.name),
                );
              }).toList(),
            ),
          ),
          nextButtonEnabledCallback: (appState) =>
              (appState.selectedSyncThreat != null),
          onNextPageCallback: (_) async {},
        );
}

class BuildingFindingPage extends AlertRoutePage {
  BuildingFindingPage()
      : super(
          title: "PLEASE INDICATE WHICH BUILDING THE THREAT OCCURED IN.",
          canPop: false,
          form: (appState) => FutureBuilder<Set<Building>>(
            future: Building.all(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While the future is loading
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // If there's an error
                return Text('Error: ${snapshot.error}');
              } else {
                // Once the future is resolved
                return Center(
                  child: Column(children: [
                    SizedBox(
                        height: 475,
                        child: RadioSelectionWidget<Building>(
                          // TODO: sort this such that the closest buildings are at the top
                          objects: snapshot.data?.toList() ?? [],
                          getSelectedObject: (appState) =>
                              appState.selectedBuilding,
                          onItemSelected: (e) {
                            var building = e as Building;
                            appState.updateSelectedBuilding(building);
                          },
                        ))
                  ]),
                );
              }
            },
          ),
          nextButtonEnabledCallback: (appState) =>
              (appState.selectedBuilding != null),
          onNextPageCallback: (_) async {},
        );
}

class FloorFindingPage extends AlertRoutePage {
  FloorFindingPage()
      : super(
          title: "PLEASE INDICATE WHICH FLOOR THE THREAT OCCURED IN.",
          canPop: false,
          form: (appState) {
            return FutureBuilder<Set<Floor>>(
              future: appState.selectedBuilding == null
                  ? Future.value({})
                  : appState.selectedBuilding!.allFloors(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While the future is loading
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // If there's an error
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Once the future is resolved
                  return Center(
                      child: Column(
                    children: [
                      Text(appState.selectedBuilding == null
                          ? ""
                          : "ALL FLOORS ARE IN ${appState.selectedBuilding!}."),
                      SizedBox(
                          height: 475,
                          child: RadioSelectionWidget<Floor>(
                            objects: snapshot.data?.toList() ?? [],
                            getSelectedObject: (appState) =>
                                appState.selectedFloor,
                            onItemSelected: (e) {
                              var floor = e as Floor;
                              appState.updateSelectedFloor(floor);
                            },
                          )),
                    ],
                  ));
                }
              },
            );
          },
          nextButtonEnabledCallback: (appState) =>
              (appState.selectedFloor != null),
          onNextPageCallback: (_) async {},
        );
}

class RoomNodeFindingPage extends AlertRoutePage {
  static List<Point> getSelectedRoomPoint(AppState appState) {
    if (appState.selectedRoom == null) {
      return [];
    }

    // if the selected room isn't on the same floor, we don't display it
    if (appState.selectedRoom!.floorId != appState.selectedFloor!.id) {
      return [];
    }

    return [Point(appState.selectedRoom!.x, appState.selectedRoom!.y)];
  }

  RoomNodeFindingPage()
      : super(
          title:
              "PLEASE INDICATE WHICH ROOM YOU ARE CURRENTLY IN. Tap the room on the map",
          canPop: false,
          form: (appState) => FutureBuilder<String>(
            future: appState.selectedFloor == null
                ? Future.value("")
                : appState.selectedFloor!.floorLayout
                    .then((layout) => layout.layoutImageUrl),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Placeholder for loading indicator
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Column(children: [
                  Text(appState.selectedRoom == null
                      ? ""
                      : "Selected room: ${appState.selectedRoom!.name}"),
                  ImageWithOverlay(
                    imageUrl: snapshot.data!, // Use snapshot data here
                    points: getSelectedRoomPoint(appState),
                    lines: [],
                    onTapCallback: (Offset o) async {
                      var closestRoomNode =
                          await appState.selectedFloor!.closestRoomNode(o);

                      if (closestRoomNode != null) {
                        appState.updateSelectedRoom((await appState
                            .selectedFloor!
                            .closestRoomNode(o))!);
                      }
                    },
                  )
                ]);
              }
            },
          ),
          nextButtonEnabledCallback: (appState) =>
              (appState.selectedRoom != null),
          onNextPageCallback: (appState) async {
            // If it's a storm, we can't have people going out.
            if (appState.selectedSyncThreat != SyncThreat.storm) {

            }
            appState.alertRoute.extendSome(
                await EmergencyRoutePage.generateRoute(appState.selectedRoom!));
          },
        );
}

class EmergencyRoutePage extends AlertRoutePage {
  final Floor floor;
  final List<RoomNode> route;

  static Future<List<EmergencyRoutePage>> generateRoute(
      RoomNode roomNode) async {
    List<RoomNode> route = await router!.getRoute(roomNode);
    List<EmergencyRoutePage> pages = [];

    Floor? currentFloor;
    List<RoomNode> currentFloorRoute = [];

    for (var n in route) {
      Floor nextFloor = await n.floor;
      print(currentFloor == nextFloor);
      if (currentFloor != nextFloor) {
        if (currentFloor != null) {
          pages.add(EmergencyRoutePage(
              floor: currentFloor, route: currentFloorRoute));
        }

        currentFloor = nextFloor;
        currentFloorRoute = [];
      }

      currentFloorRoute.add(n);
    }

    pages.add(
        EmergencyRoutePage(floor: currentFloor!, route: currentFloorRoute));

    for (var i in pages) {
      print(i.floor);
    }

    return pages;
  }

  static List<Point> getPoints(List<RoomNode> route) {
    return route.map((node) => node.point).toList();
  }

  static List<Line> getLines(List<RoomNode> route) {
    List<Line> retval = [];

    for (var i = 0; i < (route.length - 1); i++) {
      retval.add(Line(route[i].point, route[i + 1].point));
    }

    return retval;
  }

  EmergencyRoutePage({
    required this.floor,
    required this.route,
  }) : super(
          title:
              "FOLLOW THE RED LINE TO REACH THE EXIT OR STAIRWELL. WHEN YOU'RE ON ANOTHER FLOOR, PRESS NEXT PAGE.",
          canPop: false,
          form: (appState) => FutureBuilder<String>(
            future: floor.floorLayout.then((layout) => layout.layoutImageUrl),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return ImageWithOverlay(
                  imageUrl: snapshot.data!, // Use snapshot data here
                  points: [],
                  lines: getLines(route),
                  onTapCallback: (Offset o) async {
                    var closestRoomNode =
                        await appState.selectedFloor!.closestRoomNode(o);

                    if (closestRoomNode != null) {
                      appState.updateSelectedRoom(
                          (await appState.selectedFloor!.closestRoomNode(o))!);
                    }
                  },
                );
              }
            },
          ),
          nextButtonEnabledCallback: (appState) => true,
          onNextPageCallback: (_) async {},
        );
}
