import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:mats/screen/bookScreen.dart';
import 'package:mats/screen/operator.dart';
import 'package:mats/screen/wheel.dart';

final random = new Random();
String wisdom = "...";

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    readJson();
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/wisdom.json');
    final data = await json.decode(response);

    int index = random.nextInt(data['quotes'].length);
    setState(() {
      wisdom = data['quotes'][index]['quote'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 75),
        const Padding(
          padding: EdgeInsets.only(left: 25),
          child: Text(
            "Was gibts zu tuen",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 50),
        Container(
            height: 200,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              const SizedBox(width: 25),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RotatingWheel()),
                  );
                },
                child: Container(
                  width: 160,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 217, 217, 217),
                      image: const DecorationImage(
                        image: AssetImage('assets/roulette.png'),
                      )),
                ),
              ),
              const SizedBox(width: 25),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Operator()),
                  );
                },
                child: Container(
                  width: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 217, 217, 217),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child:
                        Image.asset('assets/R6Logo.png', fit: BoxFit.contain),
                  ),
                ),
              ),
              const SizedBox(width: 25),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookScreen()),
                  );
                },
                child: Container(
                  width: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 217, 217, 217),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Image.asset('assets/book.png', fit: BoxFit.contain),
                  ),
                ),
              ),
              const SizedBox(width: 25),
            ])),
        const Padding(
          padding: EdgeInsets.only(left: 25, top: 75),
          child: Text(
            "#FFFFFFheit des Tages",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 25),
        Align(
          alignment: Alignment.center,
          child: Transform(
            transform: Matrix4.skewX(-0.3),
            alignment: Alignment.center,
            child: Container(
                width: 300,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 217, 217, 217),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    wisdom,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    maxLines: 4,
                    wrapWords: false,
                  ),
                )),
          ),
        ),
      ]),
    );
  }
}
