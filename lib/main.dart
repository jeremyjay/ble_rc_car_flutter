import 'dart:io';
import 'touch_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLE RC Car!',
      home: MainScreen(),
    );
  }
}


class MainScreen extends  StatelessWidget
{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('BLE RC Car!'),
        ),
      body: _buildButton(context),
    );
  }

//add background fullscreen
  // @override
  // Widget build(BuildContext context){
  //   return Container (
  //     decoration: BoxDecoration(
  //       image: DecorationImage(
  //         image: AssetImage("assets/images/joystick_base.png"), fit: BoxFit.cover)),
  //     child: Scaffold(
  //       backgroundColor: Colors.transparent,
  //       appBar: AppBar(
  //         title: Text('BLE RC Car!'),
  //         ),
  //       body: _buildButton(context),
  //       ),
  //   );
  // }  


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
                  MaterialPageRoute(builder: (context) => PlayRCCarScreen()),
                );
              },
              child: const Text(
                'Scan for BLE Devices',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red)
              ),
            ),
            const SizedBox(height: 30),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
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

class AboutScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"), 
      ),
      body: Center(
        child: Text(
          'This app was made by\nJeremy Jay',
          style: TextStyle(fontSize: 25),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Center(
        child: Text(
          'This is the settings screen',
          style: TextStyle(fontSize: 25),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class PlayRCCarScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan for Devices"),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.list), onPressed: (){}),
          ],               
      ),
      body: new TouchController(),
    );
  }
}













