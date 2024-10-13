import 'dart:convert';
import 'dart:io';
import 'package:mats/model/Book.dart';
import 'package:path_provider/path_provider.dart';

class BookManager {
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

  Future writeNewBook(
      String newBookName, String newBookAuthor, String newBookDate) async {
    final Book newBook = Book(newBookName, newBookAuthor, newBookDate);

    File fileNewBook;

    fileNewBook = await getFileNewBook;

    List<dynamic> jsonListNewBook = await listNewBook(fileNewBook);
    jsonListNewBook.add(newBook.toJson());
    print(jsonListNewBook);
    print("-------------------------------------");
    await fileNewBook.writeAsString(json.encode(jsonListNewBook), flush: true);
  }

  Future resetNewBookJson() async {
    File fileNewBook = await getFileNewBook;
    await fileNewBook.writeAsString("", flush: true);
  }

  Future deleteNewBook(newBookIndex) async {
    File fileNewBook = await getFileNewBook;

    List<dynamic> jsonListNewBook = await listNewBook(fileNewBook);

    jsonListNewBook.removeAt(newBookIndex);

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

  Future writeReadBook(
      String ReadBookName, String ReadBookAuthor, String ReadBookDate) async {
    final Book ReadBook = Book(ReadBookName, ReadBookAuthor, ReadBookDate);

    File fileReadBook;

    fileReadBook = await getFileReadBook;

    List<dynamic> jsonListReadBook = await listReadBook(fileReadBook);
    jsonListReadBook.add(ReadBook.toJson());
    print(jsonListReadBook);
    print("-------------------------------------");
    await fileReadBook.writeAsString(json.encode(jsonListReadBook),
        flush: true);
  }

  Future resetReadBookJson() async {
    File fileReadBook = await getFileReadBook;
    await fileReadBook.writeAsString("", flush: true);
  }

  Future deleteReadBook(ReadBookIndex) async {
    File fileReadBook = await getFileReadBook;

    List<dynamic> jsonListReadBook = await listReadBook(fileReadBook);

    jsonListReadBook.removeAt(ReadBookIndex);

    await fileReadBook.writeAsString(json.encode(jsonListReadBook),
        flush: true);
  }
}
