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

class BookScreenState extends State<BookScreen> with SingleTickerProviderStateMixin {
  List<Book> newBooks = [];
  List<Book> readBooks = [];
  late TabController tabController;

@override
  void initState() {
    super.initState();
    // TabController initialisieren
    tabController = TabController(length: 2, vsync: this);

    // Listener hinzufügen, um auf Tab-Wechsel zu reagieren
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        setState(() {
          loadBooks();  // loadBooks() aufrufen bei Tab-Wechsel
        });
      }
    });

    // Initial die Bücher laden
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
      resizeToAvoidBottomInset: false,
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              controller: tabController,
              tabs: const [
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
          body: TabBarView(
            controller: tabController,
            children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                readBooks.isEmpty
                    ? const Center(
                        child: Text("Hier gibt es absolut nix zu sehen"))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: readBooks.length,
                          itemBuilder: (context, index) {
                            final book = readBooks[index];
                            return Dismissible(
                              key: Key(index
                                  .toString()), // Verwende eine eindeutige ID
                              background: Container(
                                color:
                                    Colors.red, // Hintergrundfarbe beim Wischen
                                alignment: AlignmentDirectional.centerStart,
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 16.0),
                                  child:
                                      Icon(Icons.delete, color: Colors.white),
                                ),
                              ),
                              secondaryBackground: Container(
                                color: Colors
                                    .green, // Hintergrundfarbe beim Wischen
                                alignment: AlignmentDirectional.centerEnd,
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 16.0),
                                  child: Icon(Icons.save, color: Colors.white),
                                ),
                              ),
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.startToEnd) {
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
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text('Löschen'),
                                            ),
                                          ],
                                        ),
                                      ) ??
                                      false;
                                } else {
                                  BookManager().writeNewBook(
                                      readBooks[index].BookName,
                                      readBooks[index].BookAuthor,
                                      readBooks[index].BookDate);
                                  setState(() {
                                    readBooks.removeAt(index);
                                  });
                                  BookManager().deleteReadBook(index);
                                }
                              },
                              onDismissed: (direction) async {
                                if (direction == DismissDirection.startToEnd) {
                                  final removedBook = readBooks[index];
                                  setState(() {
                                    readBooks.removeAt(index); // Buch entfernen
                                  });

                                  BookManager().deleteReadBook(index);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '${removedBook.BookName} wurde gelöscht'),
                                    ),
                                  );
                                }
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
                const SizedBox(height: 50),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                newBooks.isEmpty
                    ? const Center(
                        child:
                            Text("Stell dir einfach vor das hier was stehet"))
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
                                alignment: AlignmentDirectional.centerStart,
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 16.0),
                                  child:
                                      Icon(Icons.delete, color: Colors.white),
                                ),
                              ),
                              secondaryBackground: Container(
                                color: Colors
                                    .green, // Hintergrundfarbe beim Wischen
                                alignment: AlignmentDirectional.centerEnd,
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 16.0),
                                  child: Icon(Icons.save, color: Colors.white),
                                ),
                              ),
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.startToEnd) {
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
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text('Löschen'),
                                            ),
                                          ],
                                        ),
                                      ) ??
                                      false;
                                } else {
                                  BookManager().writeReadBook(
                                      newBooks[index].BookName,
                                      newBooks[index].BookAuthor,
                                      newBooks[index].BookDate);
                                  setState(() {
                                    newBooks.removeAt(index);
                                  });
                                  BookManager().deleteNewBook(index);
                                }
                              },
                              onDismissed: (direction) {
                                if (direction == DismissDirection.startToEnd) {
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
                                }
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
                const SizedBox(height: 50),
              ],
            ),
          ]),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Increment',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateBook()),
              ).then((_) => loadBooks());
            },
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}
