class Book {
  final int id;
  final String title;
  final String author;
  final String publishedDate;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.publishedDate,
  });

  // Convert a Book into a Map (for POST/PUT requests)
  Map<String, dynamic> toMap() {
    return {'title': title, 'author': author, 'published_date': publishedDate};
  }

  // Convert a Map into a Book object (for API response)
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      publishedDate: map['published_date'],
    );
  }
}
