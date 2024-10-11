import 'package:flutter/material.dart';
import 'package:mats/bookManager.dart';

class CreateBook extends StatefulWidget {
  @override
  CreateBookState createState() => CreateBookState();
}

class CreateBookState extends State<CreateBook> {
  final bookManager = BookManager();

  final formKey = GlobalKey<FormState>();

  String newBookName = "";
  String newBookAuthor = "";
  String newBookDate = "";

  bool bookState = false;
  bool newValue = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Buch erstellen"),
        ),
        body: Center(
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: 75),
                  TextFormField(
                    style:
                        const TextStyle(color: Color.fromARGB(255, 36, 44, 59)),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      helperText: "Buch Name",
                      hintText: 'Harry Potter ...',
                      fillColor: Color.fromARGB(255, 217, 217, 217),
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Da muss schon was stehen';
                      }
                      return null;
                    },
                    onChanged: (value) => newBookName = value,
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    style:
                        const TextStyle(color: Color.fromARGB(255, 36, 44, 59)),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      helperText: "Autor",
                      hintText: 'George RR Martin',
                      fillColor: Color.fromARGB(255, 217, 217, 217),
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Da muss schon was stehen';
                      }
                      return null;
                    },
                    onChanged: (value) => newBookAuthor = value,
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    style:
                        const TextStyle(color: Color.fromARGB(255, 36, 44, 59)),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      helperText: "Erscheinungsdatum",
                      hintText: '1.2.2022',
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
                          if (formKey.currentState!.validate()) {
                            if (!bookState) {
                              bookManager.writeNewBook(
                                  newBookName, newBookAuthor, newBookDate);
                            } else {
                              bookManager.writeReadBook(
                                  newBookName, newBookAuthor, newBookDate);
                            }
                            formKey.currentState!.reset();
                          }
                        },
                        child: const Text("Wert speichern"),
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }
}
