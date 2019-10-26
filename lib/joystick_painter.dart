import 'package:flutter/material.dart';

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