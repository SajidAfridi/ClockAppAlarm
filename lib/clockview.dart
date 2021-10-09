import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ClockView extends StatefulWidget {
  const ClockView({Key? key, required this.size}) : super(key: key);
  final double size;
  @override
  _ClockViewState createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Transform.rotate(
        angle: -pi / 2,
        child: CustomPaint(
          painter: ClockPainter(),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  var dateTime = DateTime.now();

  // to move a second line we need to move it 6 degree to one second

  @override
  void paint(Canvas canvas, Size size) {
    // THis is used to calculate center point
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    //  This is used to calculate radius. we need it to draw circle with it
    var radius = min(centerX, centerY);

    // The last thing we need for a circle is paint. wth is paint well lets find out
    var fillBrush = Paint()..color = const Color(0xFF444974);

    // Starting painting on the canvas and first we draw circle

    // Now this code is for the outline of circle to get that clock perfect
    var outlineBrush = Paint()
      ..color = const Color(0xFFEAECFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width/20; // this width make this inner circle visible

    // Now this code is for the outline of circle to get that clock perfect
    var centerFillBrush = Paint()..color = const Color(0xFFEAECFF);

    // Now I will create 2nd brush this is for seconds in the clock
    var secHandBrush = Paint()
      ..color = Colors.orangeAccent
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width/60;
    //for minutes
    var minHandBrush = Paint()
      ..shader =
          const RadialGradient(colors: [Color(0xFF748EF6), Color(0xFF77DDFF)])
              .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width/30;
    //for hours
    var hourHandBrush = Paint()
      ..shader = const RadialGradient(colors: [
        Color(0xFFEA74AB),
        Color(0xFFC279FB)
      ]) // Shader is collection of Multiple colors: Very cool
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width/24;

    // this brush for the outside of the line of the clock
    var dashBrush = Paint()
      ..color = const Color(0xFFEAECFF)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    // All Canvases are on one side and be a correct manner otherwise it work as intended
    // Reduce the circle radius by 40 pixels to shrink it down a bit
    canvas.drawCircle(center, radius *0.75, fillBrush);
    canvas.drawCircle(center, radius *0.75, outlineBrush);

    // We have to find coordinates of the circle using maths for the min sec and hour line on which it had to move

    var hourHandX = centerX +
        radius *
            0.4 *
            cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    var hourHandY = centerY +
        radius *
            0.4 *
            sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

    var minHandX = centerX + radius * 0.6 * cos(dateTime.minute * 6 * pi / 180);
    var minHandY = centerY + radius * 0.6 * sin(dateTime.minute * 6 * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);

    var secHandX = centerX + radius * 0.6 * cos(dateTime.second * 6 * pi / 180);
    var secHandY = centerY + radius * 0.6 * sin(dateTime.second * 6 * pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);

    canvas.drawCircle(center, radius*0.12, centerFillBrush); // this for the middle dot

    // This code is for outer dashes

    var outerCircleRadius = radius;
    var innerCircleRadius = radius *0.9;
    for (double i = 0; i < 360; i += 12) {
      var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
      var y1 = centerY + outerCircleRadius * sin(i * pi / 180);

      var x2 = centerX + innerCircleRadius * cos(i * pi / 180);
      var y2 = centerY + innerCircleRadius * sin(i * pi / 180);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
