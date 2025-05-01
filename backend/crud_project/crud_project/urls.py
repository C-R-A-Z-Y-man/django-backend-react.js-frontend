"""
URL configuration for crud_project project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('crud_app.urls')), #has both web and api routes.
]

"""
#has both web and api routes.

    Api prefix for api routes

        List all books: GET /api/books/

        Create a new book: POST /api/books/

        Retrieve a book: GET /api/books/<id>/

        Update a book: PUT /api/books/<id>/

        Delete a book: DELETE /api/books/<id>/
        
    Web routes :
    
        List all books: GET /books/

        Create a new book: POST /books/

        Retrieve a book: GET /books/<id>/

        Update a book: PUT /books/<id>/

        Delete a book: DELETE /books/<id>/        
"""