import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: Scaffold(
    appBar: AppBar(
      title: const Text('Shapes'),
    ),
    body: Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: CustomPaint(
                  painter: CirclePainter(),
                ),
              ),
              Expanded(
                child: CustomPaint(
                  painter: LinePainter(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: CustomPaint(
                  painter: SquarePainter(),
                ),
              ),
              Expanded(
                child: CustomPaint(
                  painter: OvalPainter(),
                ),
              ),
            ],
          ),
        )
      ],
    )
    ),
  ),
);

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = const Color(0xffaa44aa)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(100, -10), 50, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size){
    var paint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
    ..strokeWidth=10;
    canvas.drawLine(const Offset(150, 0), const Offset(30, 0), paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }}

class SquarePainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size){
    var paint = Paint()
        ..color=Colors.orange
        ..style=PaintingStyle.fill;
    canvas.drawRect(const Offset(50, -60) & const Size(100, 100), paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }}

class OvalPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size){
    var paint = Paint()
      ..color=Colors.pink
      ..style=PaintingStyle.fill;
    canvas.drawOval(const Offset(50, -60) & const Size(70, 100), paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }}