import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mats/screen/home.dart';

class Operator extends StatefulWidget {
  @override
  OperatorState createState() => OperatorState();
}

class OperatorState extends State<Operator> {
  var attack;

  var defense;

  String operatorname = "";
  String primary = "";
  String secondary = "";
  String gadget = "";

  @override
  void initState() {
    super.initState();
    readJson();
  }

  Future<void> readJson() async {
    final String attackJson = await rootBundle.loadString('assets/attack.json');
    attack = await json.decode(attackJson);

    final String defenseJson =
        await rootBundle.loadString('assets/defense.json');
    defense = await json.decode(defenseJson);
  }

  randomAttacker() {
    int indexName = random.nextInt(attack['attacker'].length);

    int indexPrimary =
        random.nextInt(attack['attacker'][indexName]['primary'].length);
    int indexSecondary =
        random.nextInt(attack['attacker'][indexName]['secondary'].length);
    int indexGadget =
        random.nextInt(attack['attacker'][indexName]['gadget'].length);

    setState(() {
      operatorname = attack['attacker'][indexName]['operatorname'];
      primary = attack['attacker'][indexName]['primary'][indexPrimary];
      secondary = attack['attacker'][indexName]['secondary'][indexSecondary];
      gadget = attack['attacker'][indexName]['gadget'][indexGadget];
    });
  }

  randomDefender() {
    int indexName = random.nextInt(defense['defender'].length);

    int indexPrimary =
        random.nextInt(defense['defender'][indexName]['primary'].length);
    int indexSecondary =
        random.nextInt(defense['defender'][indexName]['secondary'].length);
    int indexGadget =
        random.nextInt(defense['defender'][indexName]['gadget'].length);

    setState(() {
      operatorname = defense['defender'][indexName]['operatorname'];
      primary = defense['defender'][indexName]['primary'][indexPrimary];
      secondary = defense['defender'][indexName]['secondary'][indexSecondary];
      gadget = defense['defender'][indexName]['gadget'][indexGadget];
    });
  }

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
                    randomAttacker();
                  },
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 217, 217, 217),
                        image: const DecorationImage(
                          image: AssetImage('assets/attacker.png'),
                        )),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    randomDefender();
                  },
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 217, 217, 217),
                        image: const DecorationImage(
                          image: AssetImage('assets/defender.png'),
                        )),
                  ),
                )
              ])),
          const SizedBox(height: 75),
          Text(
            operatorname,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
          ),
          const SizedBox(height: 25),
          Text(
            primary,
            style: const TextStyle(
              fontSize: 30,
            ),
          ),
          Text(
            secondary,
            style: const TextStyle(
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 10),
          Text(gadget,
              style: const TextStyle(
                fontSize: 30,
              ))
        ],
      )),
    );
  }
}
