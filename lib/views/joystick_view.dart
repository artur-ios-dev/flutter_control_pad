import 'dart:math' as Math;

import 'package:control_pad/views/circle_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef JoystickDirectionCallback = void Function(
    double degrees, double distance);

class JoystickView extends StatelessWidget {
  final double size;
  final Color iconsColor;
  final JoystickDirectionCallback onDirectionChanged;

  JoystickView(
      {this.size, this.iconsColor = Colors.white54, this.onDirectionChanged});

  @override
  Widget build(BuildContext context) {
    Offset lastPosition;
    double actualSize = size != null
        ? size
        : Math.min(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height) *
            0.5;

    return Center(
      child: StatefulBuilder(
        builder: (context, setState) {
          return GestureDetector(
            onPanStart: (details) {
              _processGesture(
                  actualSize, actualSize / 2, details.localPosition);
              setState(() => lastPosition = details.localPosition);
            },
            onPanEnd: (details) {
              onDirectionChanged(0, 0);
              setState(() => lastPosition = null);
            },
            onPanUpdate: (details) {
              // print('onPanUpdate ${details.localPosition}');
              _processGesture(
                  actualSize, actualSize / 2, details.localPosition);
              setState(() => lastPosition = details.localPosition);
            },
            child: Stack(
              children: <Widget>[
                CircleView.joystickCircle(actualSize),
                Positioned.fill(
                  child: Align(
                    child: CircleView.joystickInnerCircle(actualSize / 2),
                    alignment: Alignment.center,
                  ),
                ),
                if (lastPosition != null)
                  Positioned(
                    child: CircleView.touchIndicatorCircle(actualSize / 5),
                    top: Math.max(
                        Math.min(lastPosition.dy - actualSize / 10,
                            actualSize - actualSize / 10),
                        0),
                    left: Math.max(
                        Math.min(lastPosition.dx - actualSize / 10,
                            actualSize - actualSize / 10),
                        0),
                  ),
                ...createArrows(),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> createArrows() {
    return [
      Positioned(
        child: Icon(
          Icons.arrow_upward,
          color: iconsColor,
        ),
        top: 16.0,
        left: 0.0,
        right: 0.0,
      ),
      Positioned(
        child: Icon(
          Icons.arrow_back,
          color: iconsColor,
        ),
        top: 0.0,
        bottom: 0.0,
        left: 16.0,
      ),
      Positioned(
        child: Icon(
          Icons.arrow_forward,
          color: iconsColor,
        ),
        top: 0.0,
        bottom: 0.0,
        right: 16.0,
      ),
      Positioned(
        child: Icon(
          Icons.arrow_downward,
          color: iconsColor,
        ),
        bottom: 16.0,
        left: 0.0,
        right: 0.0,
      ),
    ];
  }

  void _processGesture(double size, double ignoreSize, Offset offset) {
    double middle = size / 2.0;

    double angle = Math.atan2(offset.dy - middle, offset.dx - middle);
    double degrees = angle * 180 / Math.pi + 90;
    if (offset.dx < middle && offset.dy < middle) {
      degrees = 360 + degrees;
    }

    double dx = Math.max(0, Math.min(offset.dx, size));
    double dy = Math.max(0, Math.min(offset.dy, size));

    double distance =
        Math.sqrt(Math.pow(middle - dx, 2) + Math.pow(middle - dy, 2));

    double normalizedDistance = Math.min(distance / (size / 2), 1.0);

    if (onDirectionChanged != null) {
      onDirectionChanged(degrees, normalizedDistance);
    }
  }
}
