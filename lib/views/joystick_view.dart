import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'circle_view.dart';

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
    double actualSize = size != null
        ? size
        : Math.min(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height) *
            0.5;
    double innerCircleSize = actualSize / 2;
    Offset lastPosition = new Offset(innerCircleSize, innerCircleSize);
    Offset joystickInnerPosition = _calculatePositionOfInnerCircle(
        lastPosition, innerCircleSize, actualSize, Offset(0, 0));

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
              if (onDirectionChanged != null) {
                onDirectionChanged(0, 0);
              }
               joystickInnerPosition = _calculatePositionOfInnerCircle(
                  new Offset(innerCircleSize, innerCircleSize),
                  innerCircleSize,
                  actualSize,
                  new Offset(0, 0));
              setState(() =>
                  lastPosition = new Offset(innerCircleSize, innerCircleSize));
            },
            onPanUpdate: (details) {
              _processGesture(
                  actualSize, actualSize / 2, details.localPosition);
              joystickInnerPosition = _calculatePositionOfInnerCircle(
                  lastPosition,
                  innerCircleSize,
                  actualSize,
                  details.localPosition);

              setState(() => lastPosition = details.localPosition);
            },
            child: Stack(
              children: <Widget>[
                CircleView.joystickCircle(actualSize),
                Positioned(
                  child: CircleView.joystickInnerCircle(actualSize / 2),
                  top: joystickInnerPosition.dy,
                  left: joystickInnerPosition.dx,
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

  Offset _calculatePositionOfInnerCircle(
      Offset lastPosition, double innerCircleSize, double size, Offset offset) {
    double middle = size / 2.0;

    double angle = Math.atan2(offset.dy - middle, offset.dx - middle);
    double degrees = angle * 180 / Math.pi;
    if (offset.dx < middle && offset.dy < middle) {
      degrees = 360 + degrees;
    }
    bool isStartPosition = lastPosition.dx == innerCircleSize &&
        lastPosition.dy == innerCircleSize;
    double lastAngleRadians =
        (isStartPosition) ? 0 : (degrees) * (Math.pi / 180.0);

    var rBig = size / 2;
    var rSmall = innerCircleSize / 2;

    var x = (lastAngleRadians == -1)
        ? rBig - rSmall
        : (rBig - rSmall) + (rBig - rSmall) * Math.cos(lastAngleRadians);
    var y = (lastAngleRadians == -1)
        ? rBig - rSmall
        : (rBig - rSmall) + (rBig - rSmall) * Math.sin(lastAngleRadians);

    var xPosition = lastPosition.dx - rSmall;
    var yPosition = lastPosition.dy - rSmall;

    var angleRadianPlus = lastAngleRadians + Math.pi / 2;
    if (angleRadianPlus < Math.pi / 2) {
      if (xPosition > x) {
        xPosition = x;
      }
      if (yPosition < y) {
        yPosition = y;
      }
    } else if (angleRadianPlus < Math.pi) {
      if (xPosition > x) {
        xPosition = x;
      }
      if (yPosition > y) {
        yPosition = y;
      }
    } else if (angleRadianPlus < 3 * Math.pi / 2) {
      if (xPosition < x) {
        xPosition = x;
      }
      if (yPosition > y) {
        yPosition = y;
      }
    } else {
      if (xPosition < x) {
        xPosition = x;
      }
      if (yPosition < y) {
        yPosition = y;
      }
    }
    return new Offset(xPosition, yPosition);
  }
}