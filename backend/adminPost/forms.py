# adminPost/forms.py

from django import forms
from .models import BlogPost

class BlogPostForm(forms.ModelForm):
    class Meta:
        model = BlogPost
        exclude = ['published_date', 'modified_date']
