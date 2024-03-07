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
                  _dragProgress = details.localPosition.dx - (constraints.maxHeight / 2);
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
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  decoration: BoxDecoration(
                    color: _willActivate ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(constraints.maxHeight / 2),
                    shape: BoxShape.rectangle,
                  ),
                  child: Stack(children: [
                    Positioned(
                        left: constraints.maxHeight + 20,
                        top: (constraints.maxHeight / 2 - 20),
                        child: Text(
                          _isDragging
                              ? 'Keep dragging'
                              : 'Drag to activate alarm',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                          )
                        )),
                    Positioned(
                        bottom: 5,
                        left: _dragProgress + 5,
                        child: Container(
                          width: constraints.maxHeight - 10,
                          height: constraints.maxHeight - 10,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(223, 255, 255, 255), // border color
                            shape: BoxShape.circle,
                          ),
                        ))
                  ])));
        },
      ),
    );
  }
}
