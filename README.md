# control_pad

A virtual pad with joystick controller and configurable buttons.

<img src="https://i.imgur.com/ZwfNg9W.jpg" width="384"> <img src="https://i.imgur.com/lOdTedp.png" width="240">

## Features

- [X] Joystick controller
- [X] Pad's buttons
- [X] Configurable events interval
- [X] Configurable colors

## Usage

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control Pad Example'),
      ),
      body: Container(
        color: Colors.white,
        child: JoystickView(),
      ),
    );
  }
}
```

## Questions or Feedback?

Feel free to [open an issue](https://github.com/artrmz/flutter_control_pad/issues/new).
