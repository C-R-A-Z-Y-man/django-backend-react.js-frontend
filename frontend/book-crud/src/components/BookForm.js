import React, { useState, useEffect } from "react";
import BookService from "../services/BookService";

const BookForm = ({ currentBookId, setShowForm }) => {
  const [book, setBook] = useState({
    title: "",
    author: "",
    published_date: "",
  });

  useEffect(() => {
    if (currentBookId) {
      // Fetch the book details to edit
      BookService.getBook(currentBookId)
        .then((response) => {
          setBook(response.data);
        })
        .catch((error) => {
          console.error("Error fetching book details:", error);
        });
    }
  }, [currentBookId]);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setBook({ ...book, [name]: value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (currentBookId) {
      // Update an existing book
      BookService.updateBook(currentBookId, book)
        .then(() => {
          setShowForm(false); // Close the form after updating
        })
        .catch((error) => {
          console.error("There was an error updating the book:", error);
        });
    } else {
      // Create a new book
      BookService.createBook(book)
        .then(() => {
          setShowForm(false); // Close the form after creating
        })
        .catch((error) => {
          console.error("There was an error creating the book:", error);
        });
    }
  };

  return (
    <div>
      <h2>{currentBookId ? "Edit Book" : "Add Book"}</h2>
      <form onSubmit={handleSubmit}>
        <div>
          <label>Title</label>
          <input
            type="text"
            name="title"
            value={book.title}
            onChange={handleInputChange}
          />
        </div>
        <div>
          <label>Author</label>
          <input
            type="text"
            name="author"
            value={book.author}
            onChange={handleInputChange}
          />
        </div>
        <div>
          <label>Published Date</label>
          <input
            type="date"
            name="published_date"
            value={book.published_date}
            onChange={handleInputChange}
          />
        </div>
        <button type="submit">{currentBookId ? "Update Book" : "Add Book"}</button>
        <button type="button" onClick={() => setShowForm(false)}>
          Cancel
        </button>
      </form>
    </div>
  );
};

export default BookForm;
