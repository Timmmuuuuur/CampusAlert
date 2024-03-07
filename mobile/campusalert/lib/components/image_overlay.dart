import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageWithOverlay extends StatefulWidget {
  final void Function(Offset)? onTapCallback;

  final String imageUrl;
  final List<Point> points;
  final List<Line> lines;

  ImageWithOverlay(
      {required this.imageUrl,
      required this.points,
      required this.lines,
      this.onTapCallback});

  @override
  ImageWithOverlayState createState() => ImageWithOverlayState();
}

class ImageWithOverlayState extends State<ImageWithOverlay> {
  final GlobalKey _imageKey = GlobalKey();
  late double _imageWidth;
  late double _imageHeight;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapUp: (TapUpDetails details) {
            // Calculate the tapped position in terms of widget coordinates
            final RenderBox renderBox = context.findRenderObject() as RenderBox;
            final globalPosition =
                renderBox.globalToLocal(details.globalPosition);

            // Determine the size of the image
            final imageSize = renderBox.size;

            // Calculate the tapped position in terms of image coordinates
            final tappedPosition = Offset(
              (globalPosition.dx / imageSize.width) *
                  _imageWidth, // Example: Convert to percentage of width
              (globalPosition.dy / imageSize.height) *
                  _imageHeight, // Example: Convert to percentage of height
            );

            print("Tapped at: $tappedPosition");
            if (widget.onTapCallback != null) {
              widget.onTapCallback!(tappedPosition);
            }
          },
          child: FutureBuilder(
            future: _getImageDimensions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: _imageWidth / _imageHeight,
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: ImageOverlayPainter(
                            widget.points,
                            widget.lines,
                            _imageWidth,
                            _imageHeight,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                // You can return a loading indicator or placeholder while waiting
                return CircularProgressIndicator();
              }
            },
          ),
        );
      },
    );
  }

  Future<void> _getImageDimensions() async {
    final completer = Completer<void>();
    final Image image = Image.network(widget.imageUrl, key: _imageKey);

    image.image
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((info, _) {
      // Store image width and height
      _imageWidth = info.image.width.toDouble();
      _imageHeight = info.image.height.toDouble();
      completer.complete();
    }));

    return completer.future;
  }
}

class ImageOverlayPainter extends CustomPainter {
  final List<Point> points;
  final List<Line> lines;
  final Paint defaultPaint = Paint()
    ..color = Colors.red
    ..strokeWidth = 2;

  final double imageWidth;
  final double imageHeight;

  // Constructor
  ImageOverlayPainter(
      this.points, this.lines, this.imageWidth, this.imageHeight);

  @override
  void paint(Canvas canvas, Size size) {
    print(size);
    // Assuming size is the size of the image
    for (Point point in points) {
      canvas.drawCircle(
        Offset(point.x / imageWidth * size.width,
            point.y / imageHeight * size.height),
        8, // Radius of the circle
        defaultPaint,
      );
    }

    for (Line line in lines) {
      canvas.drawLine(
        Offset(line.start.x / imageWidth * size.width,
            line.start.y / imageHeight * size.height),
        Offset(line.end.x / imageWidth * size.width,
            line.end.y / imageHeight * size.height),
        defaultPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Point {
  final double x;
  final double y;

  Point(this.x, this.y);
}

class Line {
  final Point start;
  final Point end;

  Line(this.start, this.end);
}
