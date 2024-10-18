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

class BookScreenState extends State<BookScreen>
    with SingleTickerProviderStateMixin {
  List<Book> newBooks = [];
  List<Book> readBooks = [];
  List<Book> readBooksfiltered = [];
  List<Book> newBooksfiltered = [];
  TextEditingController editingController = TextEditingController();
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);

    // Listener hinzufügen, um auf Tab-Wechsel zu reagieren
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        setState(() {
          loadBooks(); // loadBooks() aufrufen bei Tab-Wechsel
          editingController.clear();
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
        readBooksfiltered = readBooks;
        newBooksfiltered = newBooks;
      });
    } catch (e) {
      print('Error reading JSON file: $e');
    }
  }

  void readFilterSearchResults(query) {
    setState(() {
      readBooksfiltered = readBooks
          .where((readBooks) =>
              readBooks.BookName.toLowerCase().contains(query.toLowerCase()) ||
              readBooks.BookAuthor.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void newFilterSearchResults(query) {
    setState(() {
      newBooksfiltered = newBooks
          .where((newBooks) =>
              newBooks.BookName.toLowerCase().contains(query.toLowerCase()) ||
              newBooks.BookAuthor.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
          body: TabBarView(controller: tabController, children: [
            Column(
              children: [
                TextField(
                  onChanged: (value) {
                    readFilterSearchResults(value);
                  },
                  style:
                      const TextStyle(color: Color.fromARGB(255, 36, 44, 59)),
                  controller: editingController,
                  decoration: const InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 25),
                readBooksfiltered.isEmpty
                    ? const Center(
                        child: Text("Hier gibt es absolut nix zu sehen"))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: readBooksfiltered.length,
                          itemBuilder: (context, index) {
                            final book = readBooksfiltered[index];
                            return Dismissible(
                              key: Key(readBooksfiltered[index]
                                  .BookID
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
                                  final removedBook = readBooksfiltered[index];
                                  BookManager().writeNewBook(
                                      readBooksfiltered[index].BookID,
                                      readBooksfiltered[index].BookName,
                                      readBooksfiltered[index].BookAuthor,
                                      readBooksfiltered[index].BookDate);
                                  setState(() {
                                    readBooksfiltered.removeWhere((book) =>
                                        book.BookID == removedBook.BookID);
                                    readBooks.removeWhere((book) =>
                                        book.BookID == removedBook.BookID);
                                  });
                                  BookManager()
                                      .deleteReadBook(removedBook.BookID);
                                }
                              },
                              onDismissed: (direction) async {
                                if (direction == DismissDirection.startToEnd) {
                                  final removedBook = readBooksfiltered[index];
                                  setState(() {
                                    readBooksfiltered.removeWhere((book) =>
                                        book.BookID == removedBook.BookID);
                                    readBooks.removeWhere((book) =>
                                        book.BookID == removedBook.BookID);
                                  });

                                  BookManager()
                                      .deleteReadBook(removedBook.BookID);

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
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .stretch, // Macht die Texte über die gesamte Breite
                                  children: [
                                    Align(
                                      alignment: Alignment
                                          .centerLeft, // Links ausgerichtet
                                      child: Text(
                                        book.BookAuthor,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment
                                          .centerRight, // Rechts ausgerichtet
                                      child: Text(
                                        book.BookDate,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
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
              children: [
                TextField(
                  onChanged: (value) {
                    newFilterSearchResults(value);
                  },
                  style:
                      const TextStyle(color: Color.fromARGB(255, 36, 44, 59)),
                  controller: editingController,
                  decoration: const InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 25),
                newBooksfiltered.isEmpty
                    ? const Center(
                        child:
                            Text("Stell dir einfach vor das hier was stehet"))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: newBooksfiltered.length,
                          itemBuilder: (context, index) {
                            final book = newBooksfiltered[index];
                            return Dismissible(
                              key: Key(
                                  newBooksfiltered[index].BookID.toString()),
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
                                  final removedBook = newBooksfiltered[index];
                                  BookManager().writeReadBook(
                                      newBooksfiltered[index].BookID,
                                      newBooksfiltered[index].BookName,
                                      newBooksfiltered[index].BookAuthor,
                                      newBooksfiltered[index].BookDate);
                                  setState(() {
                                    newBooksfiltered.removeWhere((book) =>
                                        book.BookID == removedBook.BookID);
                                    newBooks.removeWhere((book) =>
                                        book.BookID == removedBook.BookID);
                                  });
                                  BookManager()
                                      .deleteNewBook(removedBook.BookID);
                                }
                              },
                              onDismissed: (direction) {
                                if (direction == DismissDirection.startToEnd) {
                                  // Entferne das Buch aus der Liste
                                  final removedBook = newBooksfiltered[index];
                                  setState(() {
                                    newBooksfiltered.removeWhere((book) =>
                                        book.BookID == removedBook.BookID);
                                    newBooks.removeWhere((book) =>
                                        book.BookID == removedBook.BookID);
                                  });

                                  // Buchmanager zum Löschen aufrufen
                                  BookManager()
                                      .deleteNewBook(removedBook.BookID);
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
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .stretch, // Macht die Texte über die gesamte Breite
                                  children: [
                                    Align(
                                      alignment: Alignment
                                          .centerLeft, // Links ausgerichtet
                                      child: Text(
                                        book.BookAuthor,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment
                                          .centerRight, // Rechts ausgerichtet
                                      child: Text(
                                        book.BookDate,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
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
