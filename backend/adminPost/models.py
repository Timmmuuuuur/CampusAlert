# adminPost/models.py
# like a non-SQL database, to describe a schema
from django.db import models

class BlogPost(models.Model):
    title = models.CharField(max_length=255)
    content = models.TextField()
    pub_date = models.DateTimeField(auto_now_add=True)
    photo = models.ImageField(upload_to='blog_photos/', null=True, blank=True)

    def __str__(self):
        return self.title
