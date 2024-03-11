import 'package:campusalert/alert/alert.dart';
import 'package:campusalert/components/image_overlay.dart';
import 'package:campusalert/components/radio_selection.dart';
import 'package:campusalert/main.dart';
import 'package:campusalert/alert/threat.dart';
import 'package:campusalert/schemas/building.dart';
import 'package:campusalert/schemas/database.dart';
import 'package:campusalert/schemas/floor.dart';
import 'package:campusalert/schemas/roomnode.dart';
import 'package:campusalert/style/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campusalert/api_service.dart';

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
              title: HighlightedText("REMAIN CALM",
                  style: TextStyle(
                      fontSize: 27,
                      color: Colors.red,
                      fontWeight: FontWeight.w900)),
              automaticallyImplyLeading: false,
            ),
            body: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HighlightedText(title),
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
                    child: BodyText('Next Page'),
                  ),
                ],
              ),
            )));
  }
}

class ThreatTypePage extends AlertRoutePage {
  ThreatTypePage()
      : super(
          title: "WHAT THREAT ARE YOU EXPERIENCING?",
          canPop: false,
          form: (appState) => Center(
            child: DropdownButton<SyncThreat>(
              value: appState.activeAlert!.threat,
              onChanged: (SyncThreat? newValue) {
                if (newValue != null) {
                  appState.activeAlert!.threat = newValue;
                  appState.updateAlert(appState.activeAlert!);
                }
              },
              items: SyncThreat.values
                  .map<DropdownMenuItem<SyncThreat>>((SyncThreat value) {
                return DropdownMenuItem<SyncThreat>(
                  value: value,
                  child: BodyText(value.name),
                );
              }).toList(),
            ),
          ),
          nextButtonEnabledCallback: (appState) =>
              (appState.activeAlert!.threat != null),
          onNextPageCallback: (appState) async {
            SyncAlert.updateActive(appState.activeAlert!);
          },
        );
}

// class BuildingFindingPage extends AlertRoutePage {
//   BuildingFindingPage()
//       : super(
//           title: "WHERE U AT?",
//           canPop: false,
//           form: (appState) => Center(
//             child: DropdownButton<SyncThreat>(
//               value: appState.activeAlert!.threat,
//               onChanged: (SyncThreat? newValue) {
//                 if (newValue != null) {
//                   appState.activeAlert!.threat = newValue;
//                   appState.updateAlert(appState.activeAlert!);
//                 }
//               },
//               items: SyncThreat.values
//                   .map<DropdownMenuItem<SyncThreat>>((SyncThreat value) {
//                 return DropdownMenuItem<SyncThreat>(
//                   value: value,
//                   child: BodyText(value.name),
//                 );
//               }).toList(),
//             ),
//           ),
//           nextButtonEnabledCallback: (appState) =>
//               (appState.activeAlert!.threat != null),
//           onNextPageCallback: (appState) async {
//             SyncAlert.updateActive(appState.activeAlert!);
//           },
//         );
// }

class BuildingFindingPage extends AlertRoutePage {
  BuildingFindingPage()
      : super(
          title: "PLEASE INDICATE WHICH BUILDING THE THREAT OCCURRED IN.",
          canPop: false,
          form: (appState) => FutureBuilder<Set<Building>>(
            future: Building.all(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While the future is loading
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // If there's an error
                return BodyText('Error: ${snapshot.error}');
              } else {
                // Once the future is resolved
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        // Remove the fixed height or adjust it according to your UI requirements
                        // height: 475,
                        child: RadioSelectionWidget<Building>(
                          // TODO: sort this such that the closest buildings are at the top
                          objects: snapshot.data?.toList() ?? [],
                          getSelectedObject: (appState) => appState.activeAlert!.building,
                          onItemSelected: (e) {
                            var building = e as Building;
                            appState.activeAlert!.building = building;
                            appState.updateAlert(appState.activeAlert!);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          nextButtonEnabledCallback: (appState) => true, // Always enable the NEXT PAGE button
          onNextPageCallback: (appState) async {
            SyncAlert.updateActive(appState.activeAlert!);
          },
        );
}

// class BuildingFindingPage extends AlertRoutePage {
//   BuildingFindingPage()
//       : super(
//           title: "PLEASE INDICATE WHICH BUILDING THE THREAT OCCURED IN.",
//           canPop: false,
//           form: (appState) => FutureBuilder<Set<Building>>(
//             future: Building.all(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 // While the future is loading
//                 return CircularProgressIndicator();
//               } else if (snapshot.hasError) {
//                 // If there's an error
//                 return BodyText('Error: ${snapshot.error}');
//               } else {
//                 // Once the future is resolved
//                 return Center(
//                   child: Column(children: [
//                     SizedBox(
//                         height: 475,
//                         child: RadioSelectionWidget<Building>(
//                           // TODO: sort this such that the closest buildings are at the top
//                           objects: snapshot.data?.toList() ?? [],
//                           getSelectedObject: (appState) =>
//                               appState.activeAlert!.building,
//                           onItemSelected: (e) {
//                             var building = e as Building;
//                             appState.activeAlert!.building = building;
//                             appState.updateAlert(appState.activeAlert!);
//                           },
//                         ))
//                   ]),
//                 );
//               }
//             },
//           ),
//           nextButtonEnabledCallback: (appState) =>
//               (appState.activeAlert!.building != null),
//           onNextPageCallback: (appState) async {
//             SyncAlert.updateActive(appState.activeAlert!);
//           },
//         );
// }

class FloorFindingPage extends AlertRoutePage {
  FloorFindingPage()
      : super(
          title: "PLEASE INDICATE WHICH FLOOR THE THREAT OCCURED IN.",
          canPop: false,
          form: (appState) {
            return FutureBuilder<Set<Floor>>(
              future: appState.activeAlert!.building == null
                  ? Future.value({})
                  : appState.activeAlert!.building!.allFloors(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While the future is loading
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // If there's an error
                  return BodyText('Error: ${snapshot.error}');
                } else {
                  // Once the future is resolved
                  return Center(
                      child: Column(
                    children: [
                      BodyText(appState.activeAlert!.building == null
                          ? ""
                          : "ALL FLOORS ARE IN ${appState.activeAlert!.building!}."),
                      SizedBox(
      
                          child: RadioSelectionWidget<Floor>(
                            objects: snapshot.data?.toList() ?? [],
                            getSelectedObject: (appState) =>
                                appState.activeAlert!.floor,
                            onItemSelected: (e) {
                              var floor = e as Floor;
                              appState.activeAlert!.floor = floor;
                              appState.updateAlert(appState.activeAlert!);
                            },
                          )),
                    ],
                  ));
                }
              },
            );
          },
          nextButtonEnabledCallback: (appState) =>
              (appState.activeAlert!.floor != null),
          onNextPageCallback: (appState) async {
            SyncAlert.updateActive(appState.activeAlert!);
          },
        );
}

class RoomNodeFindingPage extends AlertRoutePage {
  static List<Point> getSelectedRoomPoint(AppState appState) {
    if (appState.activeAlert!.roomNode == null) {
      return [];
    }

    // if the selected room isn't on the same floor, we don't display it
    if (appState.activeAlert!.roomNode!.floorId !=
        appState.activeAlert!.floor!.id) {
      return [];
    }

    return [
      Point(
          appState.activeAlert!.roomNode!.x, appState.activeAlert!.roomNode!.y)
    ];
  }

  RoomNodeFindingPage()
      : super(
          title:
              "PLEASE INDICATE WHICH ROOM YOU ARE CURRENTLY IN. Tap the room on the map",
          canPop: false,
          form: (appState) => FutureBuilder<String>(
            future: appState.activeAlert!.floor == null
                ? Future.value("")
                : appState.activeAlert!.floor!.floorLayout
                    .then((layout) => layout.layoutImageUrl),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Placeholder for loading indicator
              } else if (snapshot.hasError) {
                return BodyText('Error: ${snapshot.error}');
              } else {
                return Column(children: [
                  BodyText(appState.activeAlert!.roomNode == null
                      ? ""
                      : "Selected room: ${appState.activeAlert!.roomNode!.name}"),
                  ImageWithOverlay(
                    imageUrl: snapshot.data!, // Use snapshot data here
                    points: getSelectedRoomPoint(appState),
                    lines: [],
                    onTapCallback: (Offset o) async {
                      var closestRoomNode =
                          await appState.activeAlert!.floor!.closestRoomNode(o);

                      if (closestRoomNode != null) {
                        appState.activeAlert!.roomNode = (await appState
                            .activeAlert!.floor!
                            .closestRoomNode(o))!;
                        appState.updateAlert(appState.activeAlert!);
                      }
                    },
                  )
                ]);
              }
            },
          ),
          nextButtonEnabledCallback: (appState) =>
              (appState.activeAlert!.roomNode != null),
          onNextPageCallback: (appState) async {
            SyncAlert.updateActive(appState.activeAlert!);
            // If it's a storm, we can't have people going out.
            if (appState.activeAlert!.threat != SyncThreat.storm) {
              appState.alertRoute.extendSome(
                  await EmergencyRoutePage.generateRoute(
                      appState.activeAlert!.roomNode!));
            }
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

    if (currentFloor != null) {
      pages.add(
        EmergencyRoutePage(floor: currentFloor, route: currentFloorRoute));
    }

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
                  child: BodyText('Error: ${snapshot.error}'),
                );
              } else {
                return ImageWithOverlay(
                  imageUrl: snapshot.data!, // Use snapshot data here
                  points: [],
                  lines: getLines(route),
                  onTapCallback: (Offset o) async {},
                );
              }
            },
          ),
          nextButtonEnabledCallback: (appState) => true,
          onNextPageCallback: (_) async {},
        );
}
