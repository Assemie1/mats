class Book {
  String BookName;
  String BookAuthor;
  String BookDate;

  Book(this.BookName, this.BookAuthor, this.BookDate);

  Book.fromJson(Map<String, dynamic> json)
      : BookName = json['BookName'],
        BookAuthor = json['BookAuthor'],
        BookDate = json['BookDate'];

  Map<String, dynamic> toJson() => {
        'BookName': BookName,
        'BookAuthor': BookAuthor,
        'BookDate': BookDate,
      };

  @override
  String toString() {
    return 'Book{BookName: $BookName, BookAuthor: $BookAuthor, BookDate: $BookDate}';
  }
}