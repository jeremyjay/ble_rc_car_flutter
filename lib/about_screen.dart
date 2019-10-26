import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue[300],
      appBar: AppBar(
        title: Text("About"), 
      ),
      body: Center(
        child: Text(
          "This app is to be used in conjunction with a BLE driven, remote controlled vehicle. For more information, visit:\n https://github.com/jeremyjay/ble_rc_car_flutter",
          style: TextStyle(fontSize: 25),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
