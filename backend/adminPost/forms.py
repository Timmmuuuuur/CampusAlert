# adminPost/forms.py 
# #handle the input and validation of data from users, 
# including data that is not directly related to the database.
from django import forms
from .models import BlogPost

class BlogPostForm(forms.ModelForm):
    # Add an image field for photo uploads
    photo = forms.ImageField(required=False, label='Upload Photo')

    class Meta:
        model = BlogPost
        fields = ['title', 'content', 'photo']
