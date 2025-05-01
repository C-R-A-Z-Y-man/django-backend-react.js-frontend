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
