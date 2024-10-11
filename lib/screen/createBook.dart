import 'package:flutter/material.dart';
import 'package:mats/bookManager.dart';

class CreateBook extends StatefulWidget {
  @override
  CreateBookState createState() => CreateBookState();
}

class CreateBookState extends State<CreateBook> {
  final bookManager = BookManager();

  String newBookName = "";
  String newBookAuthor = "";
  String newBookDate = "";

  bool bookState = false;
  bool newValue = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buch erstellen"),
      ),
      body: Center(
          child: Column(
        children: [
          const SizedBox(height: 75),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Buch Name',
              fillColor: Color.fromARGB(255, 217, 217, 217),
              filled: true,
            ),
            onChanged: (value) => newBookName = value,
          ),
          const SizedBox(height: 25),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Buch Autor',
              fillColor: Color.fromARGB(255, 217, 217, 217),
              filled: true,
            ),
            onChanged: (value) => newBookAuthor = value,
          ),
          const SizedBox(height: 25),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Buch Erscheinungsdatum',
              fillColor: Color.fromARGB(255, 217, 217, 217),
              filled: true,
            ),
            onChanged: (value) => newBookDate = value,
          ),
          const SizedBox(height: 25),
          CheckboxListTile(
            title: const Text(
              "Gelesen",
              style: TextStyle(color: Colors.white),
            ),
            value: bookState,
            onChanged: (newValue) {
              setState(() {
                bookState = newValue!;
              });
            },
          ),
          const SizedBox(height: 25),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 25, right: 25),
              child: ElevatedButton(
                onPressed: () {
                  if (!bookState) {
                    bookManager.writeNewBook(
                        newBookName, newBookAuthor, newBookDate);
                  } else {
                    bookManager.writeReadBook(
                        newBookName, newBookAuthor, newBookDate);
                  }
                },
                child: const Text("Wert speichern"),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
