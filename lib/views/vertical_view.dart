import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class VerticalView extends StatelessWidget {
  final double size;

  final Color color;

  final List<BoxShadow> boxShadow;

  final Border border;

  final double opacity;

  final Image buttonImage;

  final Icon buttonIcon;

  final String buttonText;

  VerticalView({
    this.size,
    this.color = Colors.transparent,
    this.boxShadow,
    this.border,
    this.opacity,
    this.buttonImage,
    this.buttonIcon,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size / 2,
      height: size,
      child: Center(
        child: buttonIcon != null
            ? buttonIcon
            : (buttonImage != null)
                ? buttonImage
                : (buttonText != null)
                    ? Text(buttonText)
                    : null,
      ),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.rectangle,
        border: border,
        boxShadow: boxShadow,
        borderRadius: new BorderRadius.circular((size / 2)),
      ),
    );
  }

  factory VerticalView.verticalJoystickCircle(double size, Color color) =>
      VerticalView(
        size: size,
        color: color,
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
}
