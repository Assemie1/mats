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
  double random = 0.0;
  String winner = "Mach mal sonst bin ich unnötig";
  int numberOfSections = 0;
  String input = "";
  List<Color> appliedColors = [];
  final List<Color> colors = [
    Colors.white
  ];

  final List<Color> colorsAfter = [
    Color.fromARGB(130, 244, 67, 54),
    const Color.fromARGB(130, 33, 149, 243),
    const Color.fromARGB(130, 76, 175, 79),
    const Color.fromARGB(130, 255, 153, 0),
    const Color.fromARGB(130, 155, 39, 176),
    const Color.fromARGB(130, 255, 235, 59),
  ];

  List<String> labels = [];
  double spin = 0;

  @override
  void initState() {
    appliedColors = colors;
    super.initState();
    random = Random().nextDouble();
    spin = (random + 1) * 4 * 2 * pi;
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

  void spinwheel() {
    _controller.reset();
    setState(() {
      appliedColors = colors;
    });
    random = Random().nextDouble();
    spin = (random + 1) * 4 * 2 * pi;
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
    _controller.forward().then((_) {
      double normalizedSpin = spin % (2 * pi);
      double adjustedSpin = (normalizedSpin + (pi / 2)) % (2 * pi);
      double sectionAngle = 2 * pi / numberOfSections;
      int winnerSegment =
          ((2 * pi - adjustedSpin) / sectionAngle).floor() % numberOfSections;

      print(wheelLogic.inputArray[winnerSegment]);

      setState(() {
        appliedColors = colorsAfter;
        winner = 'Gewonnen hat "${wheelLogic.inputArray[winnerSegment]}"';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    labels = wheelLogic.inputArray;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text("Rotierendes Glücksrad"),
      ),
      body: Center(
        child: Column(children: [
          const SizedBox(height: 75),
          Padding(
            padding: EdgeInsets.only(left: 25, right: 25),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Was steht zur Wahl?',
                fillColor: Color.fromARGB(255, 217, 217, 217),
                filled: true,
              ),
              onChanged: (value) => input = value,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 25, right: 25), // Hier das Padding einstellen
              child: ElevatedButton(
                onPressed: () {
                  wheelLogic.saveValue(input); // Speichere den Input
                  setState(() {
                    numberOfSections = calculateNewSections();
                  });
                },
                child: const Text("Wert speichern"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, bottom: 25),
            child: GestureDetector(
              onTap:
                  _startRotation, // Drehung starten, wenn das Glücksrad getappt wird
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _animation
                        .value, // Rotationswinkel basierend auf Animation
                    child: child,
                  );
                },
                child: Container(
                  width: 300,
                  height: 300,
                  child: CustomPaint(
                    painter: WheelPainter(
                      numberOfSections: numberOfSections,
                      colors: appliedColors,
                      labels: labels,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Text(
              winner,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10, right: 25, left: 25),
              child: Row(children: [
                ElevatedButton(
                  onPressed: () {
                    spinwheel();
                    wheelLogic.reset();
                    numberOfSections = 0;
                  },
                  child: const Text("Zurücksetzen!"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 179, 38, 30)
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    spinwheel();
                  },
                  child: const Text("NOCHMAL!"),
                ),
              ]))
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

  WheelPainter(
      {required this.numberOfSections,
      required this.colors,
      required this.labels});

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

    if (numberOfSections == 0) {
      paint.color = const Color.fromARGB(255, 217, 217, 217);
      canvas.drawCircle(center, radius, paint);
    } else {
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
        canvas
            .rotate(textAngle); // Text anpassen, sodass er richtig rotiert ist
        textPainter.paint(
          canvas,
          Offset(-textPainter.width / 2, -textPainter.height / 2),
        );
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}