
# Following are used by react.js or flutter or anyother thirdparty applications to interact with our application.


#  List all books: GET /api/books/
```
Method : GET

Headers :
    Content-Type : application/json
    Accept : application/json

URL : http://127.0.0.1:8000/api/books/

output :

    [
        {
            "id": 1,
            "title": "fuck book",
            "author": "420",
            "published_date": "today"
        }
    ]

```

# Create a new book: POST /api/books/

```
Method : POST

Headers :
    Content-Type : application/json
    Accept : application/json

URL : http://127.0.0.1:8000/api/books/

Input :

    {
    "title": "Second book",
    "author": "007",
    "published_date": "today"
    }

Output : 

    Status Code : 201 

    {
        "id": 2,
        "title": "Second book",
        "author": "007",
        "published_date": "today"
    }


```

# Retrieve a book: GET /api/books/<id>/

```
Status: 200 

    http://127.0.0.1:8000/api/books/2
    http://127.0.0.1:8000/api/books/1 ...

```

# Update a book: PUT /api/books/<id>/
```
Method : PUT

Headers :
    Content-Type : application/json
    Accept : application/json

URL : http://127.0.0.1:8000/api/books/<id>/

Input :

    {
        "title": "Second book",
        "author": "007",
        "published_date": "today"
    }

OUTPUT : 
    Status Code : 200 

    {
        "id": 2,
        "title": "Second book",
        "author": "007 - 420",
        "published_date": "today"
    }

```

# Delete a book: DELETE /api/books/<id>/
```

Method : Delete

Headers :
    Content-Type : application/json
    Accept : application/json

URL : http://127.0.0.1:8000/api/books/<id>/

Output : 
    Status Code: 204 No Content  => book deleted

```