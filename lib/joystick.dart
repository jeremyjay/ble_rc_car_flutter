import 'dart:math';

import 'package:flutter/material.dart';
import 'joystick_painter.dart';

class Joystick extends StatefulWidget {
  final double width;
  final double height;
  final double xPos;
  final double yPos;

  final ValueChanged<Offset> onJoystickChanged;

  const Joystick({
    @required this.onJoystickChanged,
    @required this.width, 
    @required this.height,
    this.xPos = 0,
    this.yPos = 0,
    });

  @override
  _JoystickState createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {

  double _panXPosition = 0;
  double _panYPosition = 0;

  double _panStartXOffset = 0;
  double _panStartYOffset = 0;

  bool dragging;

  @override
  void initState() {
    _panXPosition = widget.width/2;
    _panYPosition = widget.height/2;
    super.initState();
  }

  void _updatePanPosition(Offset val)
  {
    if(dragging)
    {
      double newPanXPosition = 0;
      double newPanYPosition = 0;

      //dx and dy are the distance from the top left of the widget
      double dx = val.dx - _panStartXOffset + widget.width/2;
      double dy = val.dy - _panStartYOffset + widget.height/2;

      double temp_x2 = pow((dx - widget.width/2), 2);
      double temp_y2 = pow((dy - widget.height/2), 2);

      if( sqrt(temp_x2 + temp_y2) > widget.width/2)
      {
        double theta = atan((-dy+widget.height/2)/(dx-widget.width/2));
        if(dx < widget.width/2)
        {
          newPanXPosition = -widget.width/2 * cos(theta) + widget.width/2;
          newPanYPosition = widget.height/2 * sin(theta) + widget.height/2;
        }
        else
        {
          newPanXPosition = widget.width/2 * cos(theta) + widget.width/2;
          newPanYPosition = -widget.height/2 * sin(theta) + widget.height/2;
        }
      }
      else {
          newPanXPosition = dx;
          newPanYPosition = dy;
      }

      setState(() {
        _panXPosition = newPanXPosition;
        _panYPosition = newPanYPosition;
      });

      widget.onJoystickChanged(new Offset(_panXPosition-widget.width/2, -_panYPosition+widget.height/2));
    }
  }

  void _onPanStart(BuildContext context, DragStartDetails start)
  {
    RenderBox box = context.findRenderObject();
    Offset offset = box.globalToLocal(start.globalPosition);
    _panStartXOffset = offset.dx;
    _panStartYOffset = offset.dy;

    dragging = true;
    if((widget.width/2 - _panStartXOffset).abs() > widget.width/4)
    {
      dragging = false;
    }
    else if((widget.height/2-_panStartYOffset).abs() > widget.height/4)
    {
      dragging = false;
    }    
  }

  void _onPanUpdate(BuildContext context, DragUpdateDetails update) {
    RenderBox box = context.findRenderObject();
    Offset offset = box.globalToLocal(update.globalPosition);
    _updatePanPosition(offset);
  }
  
  void _onPanEnd(BuildContext contect, DragEndDetails end) {
    //reset joystick to origin
    _panStartXOffset = widget.width/2;
    _panStartYOffset = widget.height/2;
    _updatePanPosition(new Offset(_panStartXOffset, _panStartYOffset));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        child: Container(
          width: widget.width,
          height: widget.height,
          // color: Colors.red,
          child: CustomPaint(
            painter:JoystickPainter(
              color: Colors.green, 
              joystickXPosition: _panXPosition,
              joystickYPosition: _panYPosition,
              origin: Offset(widget.width/2, widget.height/2),
              ),
          ),
        ),
        onPanStart: (DragStartDetails start) => _onPanStart(context, start),
        onPanUpdate: (DragUpdateDetails update) => _onPanUpdate(context, update),
        onPanEnd: (DragEndDetails end) => _onPanEnd(context, end),
      ),
    );
  }

}