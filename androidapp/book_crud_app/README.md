To consume the Django REST API in a Flutter application, you'll use the `http` package to send requests to your API and handle responses. Below are the steps to set up a Flutter app that interacts with your Django REST API for the `Book` CRUD operations.

### 1. Set Up a New Flutter Project

First, create a new Flutter project using the Flutter CLI.

```bash
flutter create book_crud_app
cd book_crud_app
```

### 2. Install the `http` Package

In your `pubspec.yaml` file, add the `http` package under dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^0.13.3
```

Run the following command to install the package:

```bash
flutter pub get
```

### 3. Create a Book Model

In `lib/models/book.dart`, create a model class to map the book data to and from JSON:

```dart
class Book {
  final int id;
  final String title;
  final String author;
  final String publishedDate;

  Book({required this.id, required this.title, required this.author, required this.publishedDate});

  // Convert a Book into a Map (for POST/PUT requests)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'published_date': publishedDate,
    };
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
```

### 4. Create an API Service to Handle HTTP Requests

Create a new file called `lib/services/book_service.dart` where we will handle all the HTTP requests related to `Book`.

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:book_crud_app/models/book.dart';

class BookService {
  static const String baseUrl = "http://127.0.0.1:8000/api/books/";

  // Fetch all books
  Future<List<Book>> getBooks() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((book) => Book.fromMap(book)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  // Get a single book by ID
  Future<Book> getBook(int id) async {
    final response = await http.get(Uri.parse('$baseUrl$id/'));

    if (response.statusCode == 200) {
      return Book.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to load book');
    }
  }

  // Create a new book
  Future<Book> createBook(Book book) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(book.toMap()),
    );

    if (response.statusCode == 201) {
      return Book.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to create book');
    }
  }

  // Update an existing book
  Future<Book> updateBook(int id, Book book) async {
    final response = await http.put(
      Uri.parse('$baseUrl$id/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(book.toMap()),
    );

    if (response.statusCode == 200) {
      return Book.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to update book');
    }
  }

  // Delete a book
  Future<void> deleteBook(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl$id/'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete book');
    }
  }
}
```

### 5. Create the UI for Displaying and Managing Books

Now, create the Flutter UI to interact with the API.

#### 5.1 Create the Book List Screen

This screen will display a list of books fetched from the API.

`lib/screens/book_list_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:book_crud_app/models/book.dart';
import 'package:book_crud_app/services/book_service.dart';
import 'package:book_crud_app/screens/book_form_screen.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  late Future<List<Book>> _books;

  @override
  void initState() {
    super.initState();
    _books = BookService().getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book List")),
      body: FutureBuilder<List<Book>>(
        future: _books,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No books available'));
          }

          final books = snapshot.data!;

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];

              return ListTile(
                title: Text(book.title),
                subtitle: Text('Author: ${book.author}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookFormScreen(bookId: book.id),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await BookService().deleteBook(book.id);
                        setState(() {
                          _books = BookService().getBooks();
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookFormScreen(bookId: 0)),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
```

#### 5.2 Create the Book Form Screen

This screen will handle creating and updating books.

`lib/screens/book_form_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:book_crud_app/models/book.dart';
import 'package:book_crud_app/services/book_service.dart';

class BookFormScreen extends StatefulWidget {
  final int bookId;

  BookFormScreen({required this.bookId});

  @override
  _BookFormScreenState createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _publishedDateController;

  late Book _book;

  @override
  void initState() {
    super.initState();
    if (widget.bookId != 0) {
      _book = Book(id: 0, title: "", author: "", publishedDate: "");
      _loadBook();
    } else {
      _book = Book(id: 0, title: "", author: "", publishedDate: "");
    }

    _titleController = TextEditingController(text: _book.title);
    _authorController = TextEditingController(text: _book.author);
    _publishedDateController = TextEditingController(text: _book.publishedDate);
  }

  _loadBook() async {
    Book book = await BookService().getBook(widget.bookId);
    setState(() {
      _book = book;
      _titleController.text = book.title;
      _authorController.text = book.author;
      _publishedDateController.text = book.publishedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookId == 0 ? "Add Book" : "Edit Book"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the book title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(labelText: 'Author'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the author name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _publishedDateController,
                decoration: InputDecoration(labelText: 'Published Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please

 enter the published date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _book = Book(
                      id: widget.bookId == 0 ? 0 : widget.bookId,
                      title: _titleController.text,
                      author: _authorController.text,
                      publishedDate: _publishedDateController.text,
                    );

                    if (widget.bookId == 0) {
                      await BookService().createBook(_book);
                    } else {
                      await BookService().updateBook(widget.bookId, _book);
                    }

                    Navigator.pop(context);
                  }
                },
                child: Text(widget.bookId == 0 ? "Add Book" : "Update Book"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### 6. Set Up Navigation

In `lib/main.dart`, set up the main entry point and navigation for the app.

```dart
import 'package:flutter/material.dart';
import 'package:book_crud_app/screens/book_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book CRUD App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookListScreen(),
    );
  }
}
```

### 7. Run the Flutter App

Now, you can run your Flutter app on an emulator or a physical device:

```bash
flutter run
```

### Recap of Features:
1. **Book List Screen**: Displays a list of books fetched from the Django API.
2. **Add New Book**: Allows the user to add a new book.
3. **Edit Book**: Allows the user to update an existing book.
4. **Delete Book**: Allows the user to delete a book.

Your Flutter app is now able to interact with the Django REST API and perform CRUD operations on books.