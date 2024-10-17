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

  final formKey = GlobalKey<FormState>();

  final wheelLogic = WheelLogic();
  double random = 0.0;
  String winner = "Mach mal sonst bin ich unnötig";
  int numberOfSections = 0;
  String input = "";
  List<Color> appliedColors = [];
  final List<Color> colors = [
    Color.fromARGB(255, 244, 67, 54),
    const Color.fromARGB(255, 33, 149, 243),
    const Color.fromARGB(255, 76, 175, 79),
    const Color.fromARGB(255, 255, 153, 0),
    const Color.fromARGB(255, 155, 39, 176),
    const Color.fromARGB(255, 255, 235, 59),
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
        title: const Text("Rotierendes Glücksrad"),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 75),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: TextFormField(
                  style:
                      const TextStyle(color: Color.fromARGB(255, 36, 44, 59)),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    helperText: "Auswahl",
                    hintText: 'Was steht zur Wahl?',
                    fillColor: Color.fromARGB(255, 217, 217, 217),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Da muss schon was stehen';
                    }
                    return null;
                  },
                  onChanged: (value) => input = value,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 25, right: 25),
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        wheelLogic.saveValue(input); // Save the input
                        setState(() {
                          numberOfSections = calculateNewSections();
                        });
                      }
                    },
                    child: const Text("Wert speichern"),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Transform.rotate(
                angle: 3.14159, // 180 Grad in Bogenmaß (π)
                child: CustomPaint(
                  size: const Size(15, 15), // Größe der Canvas
                  painter: ArrowTipPainter(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 25),
                child: GestureDetector(
                  onTap: _startRotation, // Start rotation on tap
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _animation
                            .value, // Rotation angle based on animation
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
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 25, left: 25),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        spinwheel();
                        wheelLogic.reset();
                        setState(() {
                          numberOfSections = 0;
                        });
                      },
                      child: const Text("Zurücksetzen!"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 179, 38, 30),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        spinwheel();
                      },
                      child: const Text("NOCHMAL!"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int calculateNewSections() {
    numberOfSections++;
    return numberOfSections;
  }
}

class ArrowTipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Pfeilspitze zeichnen
    Paint paint = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.fill;

    Path path = Path();
    // Spitze definieren (Dreieck)
    path.moveTo(size.width / 2, 0); // Obere Spitze
    path.lineTo(0, size.height); // Linke Ecke
    path.lineTo(size.width, size.height); // Rechte Ecke
    path.close(); // Dreieck schließen

    // Zeichne den Pfad auf die Leinwand
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
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
          style: const TextStyle(color: Colors.white, fontSize: 20),
        );

        // Richte den Text aus
        textPainter.text = textSpan;
        textPainter.layout();

        // Zeichne den Text in der Mitte des Segments
        canvas.save();
        canvas.translate(textX, textY);
        canvas.rotate(
            textAngle - pi); // Text anpassen, sodass er richtig rotiert ist
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
