"""
Serializers in Django REST Framework convert complex data types,
like Django models, into Python data types
that can be easily rendered into JSON, XML, or other content types.
    
"""


from rest_framework import serializers
from .models import Book

class BookSerializer(serializers.ModelSerializer):
    class Meta:
        model = Book
        fields = ['id', 'title', 'author', 'published_date']
