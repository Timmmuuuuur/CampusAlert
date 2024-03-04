import 'package:campusalert/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RadioSelectionWidget<T> extends StatelessWidget {
  final List<T> objects;
  final Function(T?)? onItemSelected;
  final T? Function(AppState) getSelectedObject;

  const RadioSelectionWidget({
    Key? key,
    required this.objects,
    required this.getSelectedObject,
    this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    T? selectedObject;
    var appState = context.watch<AppState>();
    selectedObject = getSelectedObject(appState);

    return SizedBox(
      height: 200, // Set a fixed height for the container
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(), // Enable scrolling physics
        itemCount: objects.length,
        itemBuilder: (context, index) {
          final object = objects[index];
          return RadioListTile(
            title:
                Text(object.toString()), // Assuming there's a 'name' property
            value: object,
            groupValue: selectedObject,
            onChanged: (value) {
              if (onItemSelected != null) {
                onItemSelected!(value);
              }
            },
            selected: object == selectedObject, // Check if the current item is selected
          );
        },
      ),
    );
  }
}
