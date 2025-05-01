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
                    return 'Please enter the published date';
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
