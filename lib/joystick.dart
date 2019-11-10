import 'dart:math';

import 'package:flutter/material.dart';

class SingleJoystick extends StatefulWidget {
  final double width;
  final double height;
  final double xPos;
  final double yPos;

  final ValueChanged<Offset> onJoystickChanged;

  const SingleJoystick({
    @required this.onJoystickChanged,
    @required this.width, 
    @required this.height,
    this.xPos = 0,
    this.yPos = 0,
    });

  @override
  _SingleJoystickState createState() => _SingleJoystickState();
}

class _SingleJoystickState extends State<SingleJoystick> {

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

      double tempX2 = pow((dx - widget.width/2), 2);
      double tempY2 = pow((dy - widget.height/2), 2);

      if( sqrt(tempX2 + tempY2) > widget.width/2)
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






class JoystickPainter extends CustomPainter {
  double joystickXPosition = 0;
  double joystickYPosition = 0;
  Offset origin;

  Color color = Colors.red;
  // ui.Image image;

  Paint joystickPainter;

  JoystickPainter({
    @required this.joystickXPosition,
    @required this.joystickYPosition,
    @required this.color,
    @required this.origin,
    // @required this.image,
  }): joystickPainter = Paint()
    ..color = Colors.blueGrey
    ..style = PaintingStyle.fill
    ..strokeWidth = origin.dx/10
  ;

  Paint joystickBackground = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

  Paint joystickForeground = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

  Paint joystickCircles = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

  @override
  void paint(Canvas canvas, Size size) {
    _paintJoystick(canvas, size);
  }

  void _paintJoystick(Canvas canvas, Size size) {
    //background
    canvas.drawCircle(Offset(origin.dx, origin.dy), origin.dx, joystickForeground);
    canvas.drawCircle(Offset(origin.dx, origin.dy), origin.dx*8/10, joystickBackground);
    canvas.drawCircle(Offset(origin.dx, origin.dy), origin.dx*8/10, joystickCircles);
    canvas.drawCircle(Offset(origin.dx, origin.dy), origin.dx, joystickCircles);

    //nub at origin
    canvas.drawCircle(Offset(origin.dx, origin.dy), origin.dx/10, joystickPainter);
    // canvas.drawCircle(Offset(origin.dx, origin.dy), origin.dx/10, joystickCircles);
    
    //stick
    canvas.drawLine(Offset(origin.dx, origin.dy), Offset(joystickXPosition, joystickYPosition), joystickPainter);
    // canvas.drawLine(Offset(origin.dx, origin.dy), Offset(joystickXPosition, joystickYPosition), joystickCircles);

    //thumbstick
    canvas.drawCircle(Offset(joystickXPosition, joystickYPosition), origin.dx/2, joystickPainter);
    //circles for some more detail
    canvas.drawCircle(Offset(joystickXPosition, joystickYPosition), origin.dx/2, joystickCircles);
    canvas.drawCircle(Offset(joystickXPosition, joystickYPosition), origin.dx/3, joystickCircles);
  }

  @override
  bool shouldRepaint(JoystickPainter oldDelegate) =>
    joystickXPosition != oldDelegate.joystickXPosition ||
    joystickYPosition != oldDelegate.joystickYPosition;

}