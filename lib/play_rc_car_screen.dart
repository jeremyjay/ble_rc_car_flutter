import 'package:flutter/material.dart';
import 'joystick.dart';
import 'size_config.dart';

class PlayRCCarScreen extends StatefulWidget {
  @override
  _PlayRCCarScreenState createState() => _PlayRCCarScreenState();
}

class _PlayRCCarScreenState extends State<PlayRCCarScreen>
{

  double xPos = 0.0;
  double yPos = 0.0;

  void _onJoystickChanged(Offset offset)
  {
    setState(() {
      xPos = offset.dx;
      yPos = offset.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double joystickSize = SizeConfig.screenHeight/4;
    return Scaffold (
      // backgroundColor: Colors.blue[300],
      appBar: AppBar(
        title: Text('Joystick'),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, joystickSize, 0, 0),
        child: Center(
          child: Column(
            children: <Widget>[
              Joystick(
                onJoystickChanged: (Offset offset) => _onJoystickChanged(offset), 
                height: joystickSize, 
                width: joystickSize,
              ),
              Text(xPos.toString()),
              Text(yPos.toString()),
            ],
          ),
        ),
      ),
    );
  }
}