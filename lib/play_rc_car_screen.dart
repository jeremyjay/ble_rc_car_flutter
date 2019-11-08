import 'package:flutter/material.dart';
import 'joystick.dart';
import 'dual_joystick.dart';
import 'size_config.dart';

class PlayRCCarScreen extends StatefulWidget {
  final int joystickOption;

  PlayRCCarScreen({
    @required this.joystickOption,
  });

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

  void _onDualJoystickChanged(Offset offset, int orientation)
  {
    setState(() {
      (orientation == 0) ? xPos = offset.dx:yPos = offset.dy;
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
        padding: EdgeInsets.fromLTRB(0, (widget.joystickOption==0)?joystickSize:joystickSize/2, 0, 0),
        child: Center(
          child: Column(
            children: <Widget>[
              (widget.joystickOption==0)?
                SingleJoystick(
                  onJoystickChanged: (Offset offset) => _onJoystickChanged(offset), 
                  height: joystickSize, 
                  width: joystickSize,
                ):
                DualJoystick(
                  joystickSize: joystickSize, 
                  onJoystickXChanged: (Offset offset) => _onDualJoystickChanged(offset, 0),
                  onJoystickYChanged: (Offset offset) => _onDualJoystickChanged(offset, 1),
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