import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Operator extends StatefulWidget {
  @override
  OperatorState createState() => OperatorState();
}

class OperatorState extends State<Operator> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text("Operator picker"),
      ),
      body: Center(
          child: Column(
        children: [
          const SizedBox(height: 75),
          const Text(
            "Wo seits denn?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 50),
          Padding(
              padding: const EdgeInsets.only(top: 10, right: 25, left: 25),
              child: Row(children: [
                GestureDetector(
                  onTap: () {
                    print("ÜBERRASCHUNG");
                  },
                  child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 217, 217, 217),
                      ),
                      child: const Align(
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          "Attack",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 40,
                          ),
                          maxLines: 4,
                          wrapWords: false,
                        ),
                      )),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    print("ÜBERRASCHUNG");
                  },
                  child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 217, 217, 217),
                      ),
                      child: const Align(
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          "Defense",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 40,
                          ),
                          maxLines: 4,
                          wrapWords: false,
                        ),
                      )),
                )
              ])),
        ],
      )),
    );
  }
}
