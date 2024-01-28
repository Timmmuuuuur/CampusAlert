# models.py
from django.db import models

class BlogPost(models.Model):
    title = models.CharField(max_length=255)
    content = models.TextField()
    pub_date = models.DateTimeField(auto_now_add=True)
    modified_date = models.DateTimeField(auto_now=True)  # Updated automatically on save
    photo = models.ImageField(upload_to='blog_photos/', null=True, blank=True)

    def __str__(self):
        return self.title
