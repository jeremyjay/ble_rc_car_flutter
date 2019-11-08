import 'package:flutter/material.dart';

class DualJoystick extends StatelessWidget {
    final double joystickSize;
    final ValueChanged<Offset> onJoystickXChanged;
    final ValueChanged<Offset> onJoystickYChanged;

    const DualJoystick(
      {
      @required this.joystickSize, 
      @required this.onJoystickXChanged,
      @required this.onJoystickYChanged,
      });


  	Widget build(context) {
		return new Column(
      children: <Widget>[
        Joystick(
          onJoystickChanged: (Offset offset) => onJoystickXChanged(offset), 
          height: joystickSize, 
          width: joystickSize,
          orientation: 0,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, this.joystickSize/4, 0, 0),
        ),
        Joystick(
          onJoystickChanged: (Offset offset) => onJoystickYChanged(offset), 
          height: joystickSize, 
          width: joystickSize,
          orientation: 1,
        ),
      ],
    );
	}
}

class Joystick extends StatefulWidget {
  final double width;
  final double height;
  final double xPos;
  final double yPos;
  final double orientation;
  final ValueChanged<Offset> onJoystickChanged;

  const Joystick({
    @required this.onJoystickChanged,
    @required this.width, 
    @required this.height,
    @required this.orientation,
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

      if(widget.orientation == 0)
      {
        newPanYPosition = widget.height/2;
        if(dx < 0)
        {
          newPanXPosition = 0;
        }
        else if (dx > widget.width)
        {
          newPanXPosition = widget.width;
        }
        else
        {
          newPanXPosition = dx;
        }
      }
      else if(widget.orientation == 1)
      {
        newPanXPosition = widget.width/2;
        if(dy < 0)
        {
          newPanYPosition = 0;
        }
        else if (dy > widget.height)
        {
          newPanYPosition = widget.height;
        }
        else
        {
          newPanYPosition = dy;
        }
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
              orientation: widget.orientation,
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
  double orientation = 0;

  Color color = Colors.red;
  // ui.Image image;

  Paint joystickPainter;

  JoystickPainter({
    @required this.joystickXPosition,
    @required this.joystickYPosition,
    @required this.color,
    @required this.origin,
    @required this.orientation,
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
    
    if(orientation == 1)
    {
      Rect foreRect = new Rect.fromLTRB(origin.dx*2/3, 0, origin.dx*4/3, origin.dx*2);
      canvas.drawRect(foreRect, joystickForeground);
      canvas.drawRect(foreRect, joystickCircles);

      foreRect = Rect.fromLTRB(origin.dx*5/6, 0, origin.dx*7/6, origin.dx*2);
      canvas.drawRect(foreRect, joystickBackground);
      canvas.drawRect(foreRect, joystickCircles);
    }
    else 
    {
      Rect foreRect = new Rect.fromLTRB(0, origin.dx*2/3, origin.dx*2, origin.dx*4/3);
      canvas.drawRect(foreRect, joystickForeground);
      canvas.drawRect(foreRect, joystickCircles);

      foreRect = Rect.fromLTRB(0, origin.dx*5/6, origin.dx*2, origin.dx*7/6);
      canvas.drawRect(foreRect, joystickBackground);
      canvas.drawRect(foreRect, joystickCircles);
    }

    //background


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