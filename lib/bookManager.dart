import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mats/model/Book.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class BookManager {
  var uuid = Uuid();

  Future<String> get directoryPath async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  //---------------------------------NEW BOOK--------------------------------------------------

  Future<File> get getFileNewBook async {
    final path = await directoryPath;
    final file = File('$path/NewBook.json');

    // Überprüfe, ob die Datei existiert, und erstelle sie gegebenenfalls.
    if (!(await file.exists())) {
      await file.create();
      // Optional: Initialen JSON-Inhalt schreiben, z. B. eine leere Liste von Büchern.
      await file.writeAsString('[]'); // Leere JSON-Liste als Platzhalter
    }

    return file;
  }

  Future<List<dynamic>> listNewBook(fileNewBook) async {
    List<dynamic> jsonListNewBook = [];
    try {
      if (await fileNewBook.exists()) {
        String fileContentNewBook = await fileNewBook.readAsString();

        if (fileContentNewBook.isNotEmpty) {
          dynamic currentJsonListNewBook = json.decode(fileContentNewBook);
          if (currentJsonListNewBook is List) {
            jsonListNewBook = currentJsonListNewBook;
          } else if (currentJsonListNewBook is Map) {
            jsonListNewBook = [currentJsonListNewBook];
          }
        }
      }
    } catch (e) {
      //loggin later?
    }
    return jsonListNewBook;
  }

  Future writeNewBook(newBookID, String newBookName, String newBookAuthor,
      String newBookDate) async {
    newBookID ??= uuid.v1();
    print(newBookID);
    final Book newBook =
        Book(newBookID, newBookName, newBookAuthor, newBookDate);
    print(newBook);
    File fileNewBook;

    fileNewBook = await getFileNewBook;

    List<dynamic> jsonListNewBook = await listNewBook(fileNewBook);
    jsonListNewBook.add(newBook.toJson());
    jsonListNewBook.sort((a, b) => a['BookAuthor'].compareTo(b['BookAuthor']));
    await fileNewBook.writeAsString(json.encode(jsonListNewBook), flush: true);
  }

  Future resetNewBookJson() async {
    File fileNewBook = await getFileNewBook;
    await fileNewBook.writeAsString("", flush: true);
  }

  Future deleteNewBook(bookID) async {
    File fileNewBook = await getFileNewBook;

    List<dynamic> jsonListNewBook = await listNewBook(fileNewBook);

    // Entferne das Buch mit der passenden BookID
    jsonListNewBook.removeWhere((book) => book['BookID'] == bookID);

    await fileNewBook.writeAsString(json.encode(jsonListNewBook), flush: true);
  }

//------------------------------------------------------Read Book----------------------------------------

  Future<File> get getFileReadBook async {
    final path = await directoryPath;
    final file = File('$path/ReadBook.json');

    if (!(await file.exists())) {
      await file.create();
      // Optional: Initialen JSON-Inhalt schreiben, z. B. eine leere Liste von Büchern.
      await file.writeAsString('[]'); // Leere JSON-Liste als Platzhalter
    }

    return file;
  }

  Future<List<dynamic>> listReadBook(fileReadBook) async {
    List<dynamic> jsonListReadBook = [];
    try {
      if (await fileReadBook.exists()) {
        String fileContentReadBook = await fileReadBook.readAsString();

        if (fileContentReadBook.isNotEmpty) {
          dynamic currentJsonListReadBook = json.decode(fileContentReadBook);
          if (currentJsonListReadBook is List) {
            jsonListReadBook = currentJsonListReadBook;
          } else if (currentJsonListReadBook is Map) {
            jsonListReadBook = [currentJsonListReadBook];
          }
        }
      }
    } catch (e) {
      //loggin later?
    }
    return jsonListReadBook;
  }

  Future writeReadBook(readBookID, String ReadBookName, String ReadBookAuthor,
      String ReadBookDate) async {
    readBookID ??= uuid.v1();
    final Book ReadBook =
        Book(readBookID, ReadBookName, ReadBookAuthor, ReadBookDate);

    File fileReadBook;

    fileReadBook = await getFileReadBook;

    List<dynamic> jsonListReadBook = await listReadBook(fileReadBook);
    jsonListReadBook.add(ReadBook.toJson());
    jsonListReadBook.sort((a, b) => a['BookAuthor'].compareTo(b['BookAuthor']));
    await fileReadBook.writeAsString(json.encode(jsonListReadBook),
        flush: true);
  }

  Future resetReadBookJson() async {
    File fileReadBook = await getFileReadBook;
    await fileReadBook.writeAsString("", flush: true);
  }

  Future deleteReadBook(String bookID) async {
    File fileReadBook = await getFileReadBook;

    List<dynamic> jsonListReadBook = await listReadBook(fileReadBook);

    // Entferne das Buch mit der passenden BookID
    jsonListReadBook.removeWhere((book) => book['BookID'] == bookID);

    await fileReadBook.writeAsString(json.encode(jsonListReadBook),
        flush: true);
  }
}
