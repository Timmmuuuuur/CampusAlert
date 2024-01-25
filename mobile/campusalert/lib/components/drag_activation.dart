import 'package:flutter/material.dart';

class DragActivationComponent extends StatefulWidget {
  final Function onActivate;

  const DragActivationComponent({
    super.key,
    required this.onActivate,
  });

  @override
  State<DragActivationComponent> createState() =>
      _DragActivationComponentState();
}

class _DragActivationComponentState extends State<DragActivationComponent> {
  bool _willActivate = false;
  bool _isDragging = false;
  double _dragProgress = 0;

  double _dragger_padding = 5;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 100,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return GestureDetector(
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                setState(() {
                  _dragProgress = details.localPosition.dx;
                  _willActivate = details.localPosition.dx >=
                      constraints.maxWidth - constraints.maxHeight;
                  _isDragging = true;
                });
              },
              onHorizontalDragEnd: (DragEndDetails details) {
                if (_willActivate) {
                  widget.onActivate();
                }

                setState(() {
                  _dragProgress = 0;
                  _willActivate = false;
                  _isDragging = false;
                });
              },
              child: Container(
                  color: _willActivate ? Colors.green : Colors.red,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: Stack(children: [
                    Positioned(
                        left: constraints.maxHeight + 20,
                        child: Text(
                          _isDragging
                              ? 'Keep dragging'
                              : 'Drag from left to right to activate alarm',
                          style: TextStyle(fontSize: 20),
                        )),
                    Positioned(
                        bottom: 0,
                        left: _dragProgress,
                        child: Container(
                          width: constraints.maxHeight,
                          height: constraints.maxHeight,
                          decoration: BoxDecoration(
                            color: Colors.green, // border color
                            shape: BoxShape.circle,
                          ),
                        ))
                  ])));
        },
      ),
    );
  }
}
