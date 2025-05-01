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
