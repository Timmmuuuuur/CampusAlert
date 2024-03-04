import 'package:flutter/material.dart';

class HighlightedTitle extends Text {
  HighlightedTitle(
    super.data, {
    TextAlign super.textAlign = TextAlign.center,
    TextStyle? style,
  }) : super(
          style: TextStyle(
            fontSize: 45,
            color: Colors.red,
            fontWeight: FontWeight.w800,
            height: 1,
          ).merge(style),
        );
}

class HighlightedText extends Text {
  HighlightedText(
    super.data, {
    TextAlign super.textAlign = TextAlign.center,
    TextStyle? style,
  }) : super(
          style: TextStyle(
            fontSize: 25,
            color: Colors.red,
            fontWeight: FontWeight.w800,
            height: 1,
          ).merge(style),
        );
}

class BoxedText extends StatelessWidget {
  final String text;

  BoxedText(this.text);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.all(8),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 45,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        )
      ],
    );
  }
}

class BodyText extends Text {
  BodyText(
    super.data, {
    TextAlign super.textAlign = TextAlign.center,
    TextStyle? style,
  }) : super(
          style: TextStyle(
            fontSize: 16,
            height: 1,
          ).merge(style),
        );
}