import React, { useState, useEffect } from "react";
import BookService from "../services/BookService";

const BookList = ({ setCurrentBookId, setShowForm }) => {
  const [books, setBooks] = useState([]);

  useEffect(() => {
    // Fetch the books from the API
    BookService.getBooks()
      .then((response) => {
        setBooks(response.data);
      })
      .catch((error) => {
        console.error("There was an error fetching the books:", error);
      });
  }, []);

  const handleEdit = (id) => {
    setCurrentBookId(id);
    setShowForm(true); // Show the form to edit
  };

  const handleDelete = (id) => {
    BookService.deleteBook(id)
      .then(() => {
        setBooks(books.filter((book) => book.id !== id));
      })
      .catch((error) => {
        console.error("There was an error deleting the book:", error);
      });
  };

  return (
    <div>
      <h2>Book List</h2>
      <button onClick={() => setShowForm(true)}>Add New Book</button>
      <ul>
        {books.map((book) => (
          <li key={book.id}>
            <h3>{book.title}</h3>
            <p>{book.author}</p>
            <p>{book.published_date}</p>
            <button onClick={() => handleEdit(book.id)}>Edit</button>
            <button onClick={() => handleDelete(book.id)}>Delete</button>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default BookList;
