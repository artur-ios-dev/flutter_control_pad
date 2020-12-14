import 'package:control_pad/views/vertical_joystick_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ExampleApp());
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control Pad Example',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control Pad Example'),
      ),
      body: Container(
        child: VerticalJoystickView(
          onDirectionChanged: (distance) {
            print(distance);
          },
        ),
      ),
    );
  }
}
