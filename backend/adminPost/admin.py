# adminPost/admin.py

from django.contrib import admin
from .models import BlogPost


#admin.site.register(BlogPost)

class BlogPostAdmin(admin.ModelAdmin):
    # Include the fields you want to display in the admin interface
    fields = ['title', 'content', 'report', 'floor','photo']

admin.site.register(BlogPost, BlogPostAdmin)