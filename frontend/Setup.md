To consume the REST API you created with Django and Django REST Framework (DRF) in a React.js application, follow these steps:

### 1. Set Up a New React Project

If you don't already have a React project, you can create one using `create-react-app`:

```bash
npx create-react-app book-crud
cd book-crud
```

### 2. Install Axios

We'll use Axios for making HTTP requests to the Django API. Install Axios by running:

```bash
npm install axios
```

### 3. Create the React Components

Let's create the React components that will interact with the Django API to perform the CRUD operations.

#### 3.1 Create a Service to Handle API Requests

In your React project, create a folder called `services` and a file `BookService.js` to handle the API requests.

`src/services/BookService.js`:

```javascript
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

export default new BookService();
```

#### 3.2 Create the Book List Component

This component will display the list of books fetched from the API.

`src/components/BookList.js`:

```javascript
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
```

#### 3.3 Create the Book Form Component

This component will handle both creating and editing books.

`src/components/BookForm.js`:

```javascript
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
```

### 4. Create the Main App Component

Now, we’ll create the main component that controls the state for the `BookList` and `BookForm` components.

`src/App.js`:

```javascript
import React, { useState } from "react";
import BookList from "./components/BookList";
import BookForm from "./components/BookForm";

const App = () => {
  const [showForm, setShowForm] = useState(false);
  const [currentBookId, setCurrentBookId] = useState(null);

  return (
    <div>
      <h1>Book Management App</h1>
      {showForm ? (
        <BookForm currentBookId={currentBookId} setShowForm={setShowForm} />
      ) : (
        <BookList setCurrentBookId={setCurrentBookId} setShowForm={setShowForm} />
      )}
    </div>
  );
};

export default App;
```

### 5. Run the React App

Now, you can run your React application:

```bash
npm start
```

This will start the React app on `http://localhost:3000`. It will be able to interact with the Django API running at `http://localhost:8000`.

### Key Features:

- **Book List**: Displays all books in a list.
- **Add New Book**: Allows you to create a new book.
- **Edit Book**: Allows you to edit an existing book.
- **Delete Book**: Allows you to delete a book.

### Recap of Steps:
1. Set up the React app with `create-react-app`.
2. Install Axios for HTTP requests.
3. Create a service to handle API requests (e.g., `BookService.js`).
4. Create components for displaying books (`BookList.js`) and for adding/updating books (`BookForm.js`).
5. Integrate the components in the main `App.js` component.
6. Run the React app and interact with the Django API.

With this setup, you've created a simple React.js front-end that interacts with your Django-based REST API.