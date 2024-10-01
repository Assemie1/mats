import 'package:flutter/material.dart';
import 'dart:math';

import 'package:mats/wheel/wheel_logik.dart';

class RotatingWheel extends StatefulWidget {
  @override
  _RotatingWheelState createState() => _RotatingWheelState();
}

class _RotatingWheelState extends State<RotatingWheel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  final wheelLogic = WheelLogic();
  int numberOfSections = 0;
  String input = "";
  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
  ];

  List<String> labels = [];
  double spin = 0;
  
  @override
  void initState() {
    super.initState();
    spin = (Random().nextDouble()+1) * 4 * 2 * pi;
    // AnimationController initialisieren
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4), // Dauer der Animation
    );

    // Tween für die Rotation von 0 bis zur zufälligen Endrotation
    _animation = Tween<double>(begin: 0, end: spin).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

  }

  void spinwheel(){
    _controller.reset();
    spin = (Random().nextDouble()+1) * 4 * 2 * pi;
    _animation = Tween<double>(begin: 0, end: spin).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startRotation() {
    _controller.forward();
    double sectionAngle = 2 * pi / numberOfSections;  // Winkel pro Segment berechnen

    double winner = (spin/(4)-1);
    print(winner);
    for (int k = 0; k < numberOfSections; k++){
      if(k*(1/numberOfSections) < winner && winner <= (k+1)*(1/numberOfSections)){
        print(wheelLogic.inputArray[k]);
      }
    }
  }

@override
Widget build(BuildContext context) {
  labels = wheelLogic.inputArray;
  return Scaffold(
    appBar: AppBar(
      title: const Text("Rotierendes Glücksrad"),
    ),
    body: Center(
      child: Column(children: [
        TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Was steht zur Wahl?',
          ),
          onChanged: (value) => input = value,
        ),
        ElevatedButton(
          onPressed: () {
            wheelLogic.saveValue(input); // Speichere den Input
              setState(() {
                numberOfSections = calculateNewSections(); 
              });
            },
          child: const Text("Wert speichern"),
        ),
        GestureDetector(
          onTap: _startRotation, // Drehung starten, wenn das Glücksrad getappt wird
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _animation.value, // Rotationswinkel basierend auf Animation
                child: child,
              );
            },
            child: Container(
              width: 300,
              height: 300,
              child: CustomPaint(
                painter: WheelPainter(
                  numberOfSections: numberOfSections,
                  colors: colors,
                  labels: labels,
                ),
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            spinwheel();
            },
          child: const Text("NOCHMAL!"),
        ),
      ]),
    ),
  );
}

  int calculateNewSections() {
    numberOfSections++;
    return numberOfSections; 
  }

}

class WheelPainter extends CustomPainter {
  final int numberOfSections;
  final List<Color> colors;
  final List<String> labels;

  WheelPainter({required this.numberOfSections, required this.colors, required this.labels});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;
    final sectionAngle = 2 * pi / numberOfSections;
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < numberOfSections; i++) {
      paint.color = colors[i % colors.length];
      final startAngle = i * sectionAngle;
      final sweepAngle = sectionAngle;

      // Zeichne das Kreissegment
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Berechne die Position für den Text
      final textAngle = startAngle + sweepAngle / 2;
      final textX = center.dx + radius / 2 * cos(textAngle);
      final textY = center.dy + radius / 2 * sin(textAngle);

      // Erstelle den Text
      final textSpan = TextSpan(
        text: labels[i],
        style: TextStyle(color: Colors.white, fontSize: 20),
      );

      // Richte den Text aus
      textPainter.text = textSpan;
      textPainter.layout();

      // Zeichne den Text in der Mitte des Segments
      canvas.save();
      canvas.translate(textX, textY);
      canvas.rotate(textAngle); // Text anpassen, sodass er richtig rotiert ist
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

void main() {
  runApp(MaterialApp(
    home: RotatingWheel(),
  ));
}
