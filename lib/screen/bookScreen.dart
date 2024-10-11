import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mats/bookManager.dart';
import 'package:mats/model/Book.dart';
import 'package:mats/screen/createBook.dart';

class BookScreen extends StatefulWidget {
  @override
  BookScreenState createState() => BookScreenState();
}

class BookScreenState extends State<BookScreen> {
  List<Book> newBooks = [];
  List<Book> readBooks = [];

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  Future<void> loadBooks() async {
    try {
      File jsonFileNewBook = await BookManager().getFileNewBook;
      String jsonStringNewBook = await jsonFileNewBook.readAsString();
      List<dynamic> jsonListNewBook = jsonDecode(jsonStringNewBook);

      File jsonFileReadBook = await BookManager().getFileReadBook;
      String jsonStringReadBook = await jsonFileReadBook.readAsString();
      List<dynamic> jsonListReadBook = jsonDecode(jsonStringReadBook);

      setState(() {
        newBooks = jsonListNewBook.map((json) => Book.fromJson(json)).toList();
        readBooks =
            jsonListReadBook.map((json) => Book.fromJson(json)).toList();
      });
    } catch (e) {
      print('Error reading JSON file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "Gelesen",
                ),
                Tab(
                  text: "Zu lesen",
                ),
              ],
            ),
            title: const Text('Na schon wieder ein neues Buch?'),
          ),
          body: TabBarView(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                readBooks.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : Expanded(
                        child: ListView.builder(
                          itemCount: readBooks.length,
                          itemBuilder: (context, index) {
                            final book = readBooks[index];
                            return Dismissible(
                              key: Key(
                                  book.BookName), // Verwende eine eindeutige ID
                              background: Container(
                                color:
                                    Colors.red, // Hintergrundfarbe beim Wischen
                                alignment: AlignmentDirectional.centerEnd,
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 16.0),
                                  child:
                                      Icon(Icons.delete, color: Colors.white),
                                ),
                              ),
                              confirmDismiss: (direction) async {
                                // Zeige einen Bestätigungsdialog an
                                return await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Buch löschen'),
                                        content: const Text(
                                            'Möchten Sie dieses Buch wirklich löschen?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: const Text('Abbrechen'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: const Text('Löschen'),
                                          ),
                                        ],
                                      ),
                                    ) ??
                                    false;
                              },
                              onDismissed: (direction) {
                                // Entferne das Buch aus der Liste
                                final removedBook = readBooks[index];
                                setState(() {
                                  readBooks.removeAt(index); // Buch entfernen
                                });

                                // Buchmanager zum Löschen aufrufen
                                BookManager().deleteReadBook(index);

                                // Snackbar anzeigen
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${removedBook.BookName} wurde gelöscht'),
                                  ),
                                );
                              },
                              child: ListTile(
                                title: Text(
                                  book.BookName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  book.BookAuthor,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                trailing: Text(
                                  book.BookDate,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 25, right: 25), // Hier das Padding einstellen
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateBook()),
                          ).then((_) => loadBooks());
                        },
                        child: const Text("Erstellen"),
                      ),
                    )),
                ElevatedButton(
                  onPressed: () {
                    BookManager().resetNewBookJson();
                  },
                  child: const Text("reset"),
                ),
              ],
            ),
            Column(
              // Erstelle eine Column für den zweiten Tab
              children: [
                newBooks.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : Expanded(
                        child: ListView.builder(
                          itemCount: newBooks.length,
                          itemBuilder: (context, index) {
                            final book = newBooks[index];
                            return Dismissible(
                              key: Key(
                                  book.BookName), // Verwende eine eindeutige ID
                              background: Container(
                                color:
                                    Colors.red, // Hintergrundfarbe beim Wischen
                                alignment: AlignmentDirectional.centerEnd,
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 16.0),
                                  child:
                                      Icon(Icons.delete, color: Colors.white),
                                ),
                              ),
                              confirmDismiss: (direction) async {
                                // Zeige einen Bestätigungsdialog an
                                return await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Buch löschen'),
                                        content: const Text(
                                            'Möchten Sie dieses Buch wirklich löschen?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: const Text('Abbrechen'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: const Text('Löschen'),
                                          ),
                                        ],
                                      ),
                                    ) ??
                                    false;
                              },
                              onDismissed: (direction) {
                                // Entferne das Buch aus der Liste
                                final removedBook = newBooks[index];
                                setState(() {
                                  newBooks.removeAt(index); // Buch entfernen
                                });

                                // Buchmanager zum Löschen aufrufen
                                BookManager().deleteNewBook(index);

                                // Snackbar anzeigen
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${removedBook.BookName} wurde gelöscht'),
                                  ),
                                );
                              },
                              child: ListTile(
                                title: Text(
                                  book.BookName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  book.BookAuthor,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                trailing: Text(
                                  book.BookDate,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 25, right: 25, bottom: 25), // Hier das Padding einstellen
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateBook()),
                          ).then((_) => loadBooks());
                        },
                        child: const Text("Erstellen"),
                      ),
                    ))
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
