import axios from "axios";

// Base URL for the Django API
const API_URL = "http://127.0.0.1:8000/api/books/";

class BookService {
  // Fetch all books
  getBooks() {
    return axios.get(API_URL);
  }

  // Get a single book by ID
  getBook(id) {
    return axios.get(`${API_URL}${id}/`);
  }

  // Create a new book
  createBook(book) {
    return axios.post(API_URL, book);
  }

  // Update an existing book
  updateBook(id, book) {
    return axios.put(`${API_URL}${id}/`, book);
  }

  // Delete a book by ID
  deleteBook(id) {
    return axios.delete(`${API_URL}${id}/`);
  }
}


//export  { BookService , Postservice };

export default new BookService();
