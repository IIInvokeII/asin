import "package:flutter/material.dart";
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';

void main() => runApp(MaterialApp(
  theme: ThemeData(
    primarySwatch:Colors.indigo
  ),
  home: const Gyro()
));

class Gyro extends StatefulWidget {
  const Gyro({Key? key}) : super(key: key);
  @override
  State<Gyro> createState() => _GyroState();
}
class _GyroState extends State<Gyro> {
  double dx=0, dy=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Gyroscope Application'
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Center(
                child: Text(
                  'Use Virtual Sensors to move the Gyroscope Dot!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: StreamBuilder<GyroscopeEvent>(
              stream: SensorsPlatform.instance.gyroscopeEvents,
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  dy = dy + snapshot.data!.y * 10;
                  dx = dx + snapshot.data!.x *10;
                }
                return Stack(
                  children: [
                    Positioned(
                      top: dy,
                      left: dx,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            dy = max(0, dy + details.delta.dy);
                            dx = max(0, dx + details.delta.dx);
                          });
                        },
                        child: const CircleAvatar(),
                      ),
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
