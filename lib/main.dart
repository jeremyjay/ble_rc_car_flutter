import 'package:flutter/material.dart';
import 'about_screen.dart';
import 'settngs_screen.dart';
import 'play_rc_car_screen.dart';

void main() => runApp(MaterialApp(
  title: 'BLE RC Car!',
  theme: new ThemeData(scaffoldBackgroundColor: Colors.blue[300]),
  home: MainScreen(),
));

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
{

  int joystickOption = 1;

  // PlayRCCarScreen playRCCarScreen = new PlayRCCarScreen();
  // SettingsScreen settingsScreen = new SettingsScreen(joystickOption: joystickOption);

  void onJoystickOptionChanged(newJoystickOption)
  {
    joystickOption = newJoystickOption;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      // backgroundColor: Colors.blue[300],
      appBar: AppBar(
        title: Text('BLE RC Car!'),
        ),
      body: _buildButton(context),
    );
  }

  //button
  Widget _buildButton(BuildContext context)
  {
    return Center(
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'BLE RC Car!',
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(height: 60),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => new PlayRCCarScreen(joystickOption: joystickOption)),
                );
                
              },
              child: const Text(
                'Scan for BLE Devices',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 30),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen(
                    onJoystickOptionChanged,
                    joystickOption)),
                );
              },
              child: const Text(
                'Settings',
                style: TextStyle(fontSize: 20)
              ),
            ),
            const SizedBox(height: 30),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              },
              // fromWindowPadding
              padding: const EdgeInsets.fromLTRB(60.0, 0 ,60.0, 0),
              child: const Text(
                'About',
                style: TextStyle(fontSize: 20)
              ),
            ),
          ],
        ),
      ),
    );
  }
}