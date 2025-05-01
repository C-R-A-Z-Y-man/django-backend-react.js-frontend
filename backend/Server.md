To create a simple CRUD (Create, Read, Update, Delete) application using MySQL and Django, follow the steps below. This example assumes that you already have Python and Django installed.

### Step-by-Step Guide:

#### 1. Set up your environment

Make sure you have Django and MySQL client installed. You can do this by running:

```bash
pip install django mysqlclient
```

#### 2. Create a Django project

Run the following commands to create a new Django project and application:

```bash
django-admin startproject crud_project
cd crud_project
python manage.py startapp crud_app
```

#### 3. Configure MySQL Database

- Ensure you have MySQL running locally (or you can set it up on a remote server).
- Create a database in MySQL for your project.

```sql
CREATE DATABASE crud_db;
```

#### 4. Configure Database Settings in Django

Open `crud_project/settings.py` and find the `DATABASES` section. Update it to use MySQL as the database engine:

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'crud_db',
        'USER': 'your_mysql_user',
        'PASSWORD': 'your_mysql_password',
        'HOST': 'localhost',  # or use the MySQL server address if remote
        'PORT': '3306',
    }
}
```

#### 5. Create a Model for CRUD Operations

Now, we’ll create a simple model for a `Book` in `crud_app/models.py`:

```python
from django.db import models

class Book(models.Model):
    title = models.CharField(max_length=255)
    author = models.CharField(max_length=255)
    published_date = models.DateField()

    def __str__(self):
        return f"{self.title} by {self.author}"
```

#### 6. Migrate the Database

Run the following commands to create the necessary database tables for your `Book` model:

```bash
python manage.py makemigrations
python manage.py migrate
```

#### 7. Create Views for CRUD Operations

In `crud_app/views.py`, write views for each CRUD operation. You can use Django's built-in class-based views or function-based views.

For simplicity, we’ll use function-based views:

```python
from django.shortcuts import render, redirect, get_object_or_404
from .models import Book
from .forms import BookForm

# Create Book
def create_book(request):
    if request.method == 'POST':
        form = BookForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('book_list')
    else:
        form = BookForm()
    return render(request, 'create_book.html', {'form': form})

# Read Book List
def book_list(request):
    books = Book.objects.all()
    return render(request, 'book_list.html', {'books': books})

# Update Book
def update_book(request, pk):
    book = get_object_or_404(Book, pk=pk)
    if request.method == 'POST':
        form = BookForm(request.POST, instance=book)
        if form.is_valid():
            form.save()
            return redirect('book_list')
    else:
        form = BookForm(instance=book)
    return render(request, 'update_book.html', {'form': form})

# Delete Book
def delete_book(request, pk):
    book = get_object_or_404(Book, pk=pk)
    if request.method == 'POST':
        book.delete()
        return redirect('book_list')
    return render(request, 'delete_book.html', {'book': book})
```

#### 8. Create Forms for Book CRUD

Create a `forms.py` file in the `crud_app` folder to handle the form creation for books.

```python
from django import forms
from .models import Book

class BookForm(forms.ModelForm):
    class Meta:
        model = Book
        fields = ['title', 'author', 'published_date']
```

#### 9. Create Templates

Now, create the HTML templates for the CRUD operations.

1. `templates/create_book.html`:

```html
<!DOCTYPE html>
<html>
<head><title>Create Book</title></head>
<body>
    <h1>Create Book</h1>
    <form method="POST">
        {% csrf_token %}
        {{ form.as_p }}
        <button type="submit">Save</button>
    </form>
    <a href="{% url 'book_list' %}">Back to Book List</a>
</body>
</html>
```

2. `templates/book_list.html`:

```html
<!DOCTYPE html>
<html>
<head><title>Book List</title></head>
<body>
    <h1>Book List</h1>
    <a href="{% url 'create_book' %}">Create New Book</a>
    <ul>
        {% for book in books %}
            <li>{{ book.title }} by {{ book.author }}
                <a href="{% url 'update_book' book.pk %}">Edit</a>
                <a href="{% url 'delete_book' book.pk %}">Delete</a>
            </li>
        {% endfor %}
    </ul>
</body>
</html>
```

3. `templates/update_book.html`:

```html
<!DOCTYPE html>
<html>
<head><title>Update Book</title></head>
<body>
    <h1>Update Book</h1>
    <form method="POST">
        {% csrf_token %}
        {{ form.as_p }}
        <button type="submit">Save</button>
    </form>
    <a href="{% url 'book_list' %}">Back to Book List</a>
</body>
</html>
```

4. `templates/delete_book.html`:

```html
<!DOCTYPE html>
<html>
<head><title>Delete Book</title></head>
<body>
    <h1>Are you sure you want to delete "{{ book.title }}"?</h1>
    <form method="POST">
        {% csrf_token %}
        <button type="submit">Yes, delete</button>
    </form>
    <a href="{% url 'book_list' %}">Cancel</a>
</body>
</html>
```

#### 10. Add URL Patterns

In `crud_app/urls.py`, add the URL patterns for each CRUD operation:

```python
from django.urls import path
from . import views

urlpatterns = [
    path('', views.book_list, name='book_list'),
    path('create/', views.create_book, name='create_book'),
    path('update/<int:pk>/', views.update_book, name='update_book'),
    path('delete/<int:pk>/', views.delete_book, name='delete_book'),
]
```

Make sure to include `crud_app.urls` in the `crud_project/urls.py`:

```python
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('crud_app.urls')),
]
```

#### 11. Run the Server

Finally, run the server to check everything:

```bash
python manage.py runserver
```

Visit `http://127.0.0.1:8000/` in your browser to see the application in action.

### Recap:
1. Set up MySQL in Django settings.
2. Created a simple `Book` model.
3. Built views for Create, Read, Update, and Delete operations.
4. Set up forms for data input.
5. Created the necessary HTML templates.
6. Defined the URL patterns to map to the views.

You now have a simple CRUD application using Django and MySQL!