import 'package:campusalert/components/radio_selection.dart';
import 'package:campusalert/main.dart';
import 'package:campusalert/alert/threat.dart';
import 'package:campusalert/schemas/building.dart';
import 'package:campusalert/schemas/floor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<AlertRoutePage> defaultPages() {
  return [
    ThreatTypePage(),
    BuildingFindingPage(),
    FloorFindingPage(),
  ];
}

class AlertRoutePage extends StatelessWidget {
  final String title;
  final bool canPop; // Whether user is allowed to go to previous apge
  final Widget Function(AppState) form;
  final bool Function(AppState) nextButtonEnabledCallback;
  final VoidCallback onNextPageCallback;

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
                    ? () {
                        if (nextPage == null) {
                          onNextPageCallback();
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
          onNextPageCallback: () => {},
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
                  child: SizedBox(
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
                      )),
                );
              }
            },
          ),
          nextButtonEnabledCallback: (appState) =>
              (appState.selectedBuilding != null),
          onNextPageCallback: () => {},
        );
}

class FloorFindingPage extends AlertRoutePage {
  FloorFindingPage()
      : super(
          title: "PLEASE INDICATE WHICH FLOOR THE THREAT OCCURED IN.",
          canPop: false,
          form: (appState) => FutureBuilder<Set<Floor>>(
            future: appState.selectedBuilding!.allFloors(),
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
                    Text("ALL FLOORS ARE IN ${appState.selectedBuilding!}."),
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
          ),
          nextButtonEnabledCallback: (appState) =>
              (appState.selectedBuilding != null),
          onNextPageCallback: () => {},
        );
}
