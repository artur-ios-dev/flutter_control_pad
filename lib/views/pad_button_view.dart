import 'dart:collection';
import 'dart:math' as _math;

import 'package:control_pad/models/gestures.dart';
import 'package:control_pad/models/pad_button_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'circle_view.dart';

typedef PadButtonPressedCallback = void Function(
    int buttonIndex, Gestures gesture);

class PadButtonsView extends StatelessWidget {
  /// [size] optional parameter, space for background circle of all padd buttons. It will be
  /// recalculated for pad buttons size.
  ///
  /// Default value is calculated according to screen size.
  final double? size;

  /// List of pad buttons, default contains 4 buttons
  final List<PadButtonItem> buttons;

  /// [padButtonPressedCallback] contains information which button(index) was
  /// used by user and what gesture was done on it.
  final PadButtonPressedCallback? padButtonPressedCallback;

  /// [buttonsStateMap] contains current colors of each button.
  final Map<int, Color> buttonsStateMap = HashMap<int, Color>();

  /// [buttonsPadding] optional parameter to ad paddings for buttons.
  final double buttonsPadding;

  /// [backgroundPadButtonsColor] optional parameter, when set it shows circle.
  final Color backgroundPadButtonsColor;

  PadButtonsView({
    this.size,
    this.buttons = const [
      PadButtonItem(index: 0, buttonText: "A"),
      PadButtonItem(index: 1, buttonText: "B", pressedColor: Colors.red),
      PadButtonItem(index: 2, buttonText: "C", pressedColor: Colors.green),
      PadButtonItem(index: 3, buttonText: "D", pressedColor: Colors.yellow),
    ],
    this.padButtonPressedCallback,
    this.buttonsPadding = 0,
    this.backgroundPadButtonsColor = Colors.transparent,
  }) : assert(buttons != null && buttons.isNotEmpty) {
    buttons.forEach(
        (button) => buttonsStateMap[button.index] = button.backgroundColor);
  }

  @override
  Widget build(BuildContext context) {
    double actualSize = size != null
        ? size!
        : _math.min(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height) *
            0.5;
    double innerCircleSize = actualSize / 3;

    return Center(
        child: Stack(children: createButtons(innerCircleSize, actualSize)));
  }

  List<Widget> createButtons(double innerCircleSize, double actualSize) {
    List<Widget> list = [];
    list.add(CircleView.padBackgroundCircle(
        actualSize,
        backgroundPadButtonsColor,
        backgroundPadButtonsColor != Colors.transparent
            ? Colors.black45
            : Colors.transparent,
        backgroundPadButtonsColor != Colors.transparent
            ? Colors.black12
            : Colors.transparent));

    for (var i = 0; i < buttons.length; i++) {
      var padButton = buttons[i];
      list.add(createPositionedButtons(
        padButton,
        actualSize,
        i,
        innerCircleSize,
      ));
    }
    return list;
  }

  Positioned createPositionedButtons(PadButtonItem paddButton,
      double actualSize, int index, double innerCircleSize) {
    return Positioned(
      child: StatefulBuilder(builder: (context, setState) {
        return GestureDetector(
          onTap: () {
            _processGesture(paddButton, Gestures.TAP);
          },
          onTapUp: (details) {
            _processGesture(paddButton, Gestures.TAPUP);
            Future.delayed(const Duration(milliseconds: 50), () {
              setState(() => buttonsStateMap[paddButton.index] =
                  paddButton.backgroundColor);
            });
          },
          onTapDown: (details) {
            _processGesture(paddButton, Gestures.TAPDOWN);

            setState(() =>
                buttonsStateMap[paddButton.index] = paddButton.pressedColor);
          },
          onTapCancel: () {
            _processGesture(paddButton, Gestures.TAPCANCEL);

            setState(() =>
                buttonsStateMap[paddButton.index] = paddButton.backgroundColor);
          },
          onLongPress: () {
            _processGesture(paddButton, Gestures.LONGPRESS);
          },
          onLongPressStart: (details) {
            _processGesture(paddButton, Gestures.LONGPRESSSTART);

            setState(() =>
                buttonsStateMap[paddButton.index] = paddButton.pressedColor);
          },
          onLongPressUp: () {
            _processGesture(paddButton, Gestures.LONGPRESSUP);

            setState(() =>
                buttonsStateMap[paddButton.index] = paddButton.backgroundColor);
          },
          child: Padding(
            padding: EdgeInsets.all(buttonsPadding),
            child: CircleView.padButtonCircle(
                innerCircleSize,
                buttonsStateMap[paddButton.index],
                paddButton.buttonImage,
                paddButton.buttonIcon,
                paddButton.buttonText),
          ),
        );
      }),
      top: _calculatePositionYOfButton(index, innerCircleSize, actualSize),
      left: _calculatePositionXOfButton(index, innerCircleSize, actualSize),
    );
  }

  void _processGesture(PadButtonItem button, Gestures gesture) {
    if (padButtonPressedCallback != null &&
        button.supportedGestures.contains(gesture)) {
      padButtonPressedCallback!(button.index, gesture);
      print("$gesture paddbutton id =  ${[button.index]}");
    }
  }

  double _calculatePositionXOfButton(
      int index, double innerCircleSize, double actualSize) {
    double degrees = 360 / buttons.length * index;
    double lastAngleRadians = (degrees) * (_math.pi / 180.0);

    var rBig = actualSize / 2;
    var rSmall = (innerCircleSize + 2 * buttonsPadding) / 2;

    return (rBig - rSmall) + (rBig - rSmall) * _math.cos(lastAngleRadians);
  }

  double _calculatePositionYOfButton(
      int index, double innerCircleSize, double actualSize) {
    double degrees = 360 / buttons.length * index;
    double lastAngleRadians = (degrees) * (_math.pi / 180.0);
    var rBig = actualSize / 2;
    var rSmall = (innerCircleSize + 2 * buttonsPadding) / 2;

    return (rBig - rSmall) + (rBig - rSmall) * _math.sin(lastAngleRadians);
  }
}
