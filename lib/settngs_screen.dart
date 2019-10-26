import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {

  final int joystickOption;

  final ValueChanged<int> onJoystickOptionChanged;

  const SettingsScreen(
    this.onJoystickOptionChanged,
    this.joystickOption,
  );

  @override
  _SettingsScreenState createState() => _SettingsScreenState(joystickOption);
}

class _SettingsScreenState extends State<SettingsScreen>
{
  int joystickOption = 1;
  Color selectedColor = Colors.blueGrey[400];
  Color unselectedColor = Colors.blueGrey[200];

  _SettingsScreenState(this.joystickOption);

  void toggleJoystick(int option)
  {
    widget.onJoystickOptionChanged(option);
    setState(() {
      joystickOption = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      // backgroundColor: Colors.blue[300],
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              'This is the settings screen. Select wether you would like to use 1 joystick or 2 joysticks',
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
            RaisedButton(
              onPressed: () {
                toggleJoystick(1);
                // widget.onJoystickOptionChanged(1);
              },
              color: joystickOption == 1 ? selectedColor:unselectedColor,
              child: Text(
                "Single Joystick",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white)
              ),
            ),
            RaisedButton(
              onPressed: () {
                toggleJoystick(2);
                // widget.onJoystickOptionChanged(2);
              },
              color: joystickOption == 2 ? selectedColor:unselectedColor,
              child: Text(
                "Dual Joystick",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white)
              ),
            ),
          ]
        )
      ),
    );
  }
}