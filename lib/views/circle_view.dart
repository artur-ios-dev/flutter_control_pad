import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CircleView extends StatelessWidget {
  final double size;

  final Color color;

  final List<BoxShadow> boxShadow;

  final Border border;

  CircleView({this.size, this.color, this.boxShadow, this.border});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: border,
        boxShadow: boxShadow,
      ),
    );
  }

  factory CircleView.joystickCircle(double size) => CircleView(
        size: size,
        color: Colors.blueGrey,
        border: Border.all(
          color: Colors.black45,
          width: 4.0,
          style: BorderStyle.solid,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 8.0,
            blurRadius: 8.0,
          )
        ],
      );

  factory CircleView.joystickInnerCircle(double size) => CircleView(
        size: size,
        color: Colors.blueGrey,
        border: Border.all(
          color: Colors.black26,
          width: 2.0,
          style: BorderStyle.solid,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 8.0,
            blurRadius: 8.0,
          )
        ],
      );
}
