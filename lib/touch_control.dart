import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'size_config.dart';

double xOrigin = 0;
double yOrigin = 0;
double maxRadius = 0;

void updateData(double xPos, double yPos)
{
  Widget build(BuildContext context) {
  }
}

class TouchController extends StatelessWidget
{

  // double xPos = 0;
  // double yPos = 0;
  // //write your callback function here:
  // touchCallback(double newX, newY) {
  //   setState(() {
  //     xPos = newX;
  //     yPos = newY;
  //   });
  // }


  // @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    xOrigin = SizeConfig.screenWidth/2 - 50;
    yOrigin = SizeConfig.screenWidth/2 - 48;
    maxRadius = SizeConfig.screenWidth/3;
    return Container(
        padding: const EdgeInsets.all(50.0),
        height: SizeConfig.screenWidth,
        width: SizeConfig.screenWidth,
          child: Stack(
            children: <Widget>[
                 new Container (
                  height: SizeConfig.screenWidth,
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/joystick_base.png"), 
                      fit: BoxFit.fill),
                  ),
                ),
                new TouchControl(),
            ],
          ),
      );
  }

}

class TouchControl extends StatefulWidget {
  final double xPos;
  final double yPos;
  final ValueChanged<Offset> onChanged;

  TouchControl({Key key,
    this.onChanged,
    this.xPos:0.0,
    this.yPos:0.0}) : super(key: key);

  @override
  _TouchControlState createState() => new _TouchControlState(xPos: 10, yPos: 10);
}




class _TouchControlState extends State<TouchControl> {
  
  double xPos = 0.0;
  double yPos = 0.0;
  // static const double x_origin = SizeConfig().screenWidth;
  // static const double y_origin = 161.40625;  

  // GlobalKey _painterKey = new GlobalKey();

  _TouchControlState({
    this.xPos,
    this.yPos,
  });
  
  ui.Image image;
  bool isImageloaded = false;
  void initState() {
    super.initState();
    init();
  }

  Future <Null> init() async {
    final ByteData data = await rootBundle.load('assets/images/joystick.png');
    image = await loadImage(new Uint8List.view(data.buffer));
  }

  Future<ui.Image> loadImage(List<int> img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      setState(() {
        isImageloaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }


  void onChanged(Offset offset) {
    final RenderBox referenceBox = context.findRenderObject();
    Offset position = referenceBox.globalToLocal(offset);
    if (widget.onChanged != null)
      widget.onChanged(position);
    setState(() {
      double tempX = position.dx - xOrigin;
      double tempY = position.dy - yOrigin;
      if( sqrt(pow(tempX, 2) + pow(tempY, 2)) > maxRadius)
      {
        double theta = atan((tempY)/(tempX));
        if(position.dx < xOrigin)
        {
          xPos = -maxRadius*cos(theta)+xOrigin;
          yPos = -maxRadius*sin(theta)+yOrigin;
        }
        else
        {
          xPos = maxRadius*cos(theta)+xOrigin;
          yPos = maxRadius*sin(theta)+yOrigin;
        }
      }
      else
      {
        xPos = position.dx;
        yPos = position.dy;
      }
      //TODO: broadcast BLE data, instead of print
      // better to return data though, and broadcast
      // in main.dart, rather than in the widget.
      updateData(xPos, yPos);
      // print(xPos);
      // print(yPos);
    });
  }


  void _handlePanStart(DragStartDetails details) {
    onChanged(details.globalPosition);
  }

  void _handlePanEnd(DragEndDetails details) {
    //TODO: use ScreenConfig().screenWidth to calculate offset
    // or change the onChanged function when converting from these to local coord.
    xPos = xOrigin+52;
    yPos = yOrigin+129;
    onChanged(Offset(xPos, yPos));
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    onChanged(details.globalPosition);

  }

  Widget _buildImage(newxPos, newyPos) {
    if (this.isImageloaded) {
      // return new CustomPaint(
      //     painter: new ImageEditor(
      //       image: image,
      //       xPos: newxPos,
      //       yPos: newyPos,
      //     ),
      //   );
      return Center(
        child: Align(
          alignment: Alignment.topLeft,
          child:  Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CustomPaint(
                painter: new ImageEditor(
                  image: image,
                  xPos: newxPos,
                  yPos: newyPos,
                ),
              ),
              Text('xPos : $xPos'),
              Text('yPos : $yPos'),
            ]    
          ),
        ),  
      );
    } else {
      return new Center(child: new Text('loading'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
      constraints: new BoxConstraints.expand(),
      child: new GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart:_handlePanStart,
        onPanEnd: _handlePanEnd,
        onPanUpdate: _handlePanUpdate,
        child: _buildImage(xPos, yPos),
      ),
    );
  }

}

class ImageEditor extends CustomPainter {
  static const markerRadius = 10.0;
  final double xPos;
  final double yPos;

  ImageEditor({this.xPos, this.yPos, this.image});

  ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
      final paint = new Paint()
    ..color = Colors.blueGrey
    ..style = PaintingStyle.fill
    ..strokeWidth = 35.0;
    canvas.drawLine(Offset(xOrigin, yOrigin), Offset(xPos, yPos), paint);
    canvas.drawCircle(Offset(xOrigin, yOrigin), 25, paint);
    canvas.drawImage(image, new Offset(xPos-110, yPos-110), paint);
  }

  @override
  bool shouldRepaint(ImageEditor old) => xPos != old.xPos && yPos !=old.yPos;
}

