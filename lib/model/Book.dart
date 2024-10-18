class Book {
  String BookID;
  String BookName;
  String BookAuthor;
  String BookDate;

  Book(this.BookID, this.BookName, this.BookAuthor, this.BookDate);

  Book.fromJson(Map<String, dynamic> json)
      : BookID = json['BookID'],
        BookName = json['BookName'],
        BookAuthor = json['BookAuthor'],
        BookDate = json['BookDate'];

  Map<String, dynamic> toJson() => {
        'BookID': BookID,
        'BookName': BookName,
        'BookAuthor': BookAuthor,
        'BookDate': BookDate,
      };

  @override
  String toString() {
    return 'Book{BookID: $BookID, BookName: $BookName, BookAuthor: $BookAuthor, BookDate: $BookDate}';
  }
}