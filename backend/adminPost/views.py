from django.shortcuts import render

# Create your views here.
# adminPost/views.py
from django.shortcuts import render
from django.views.generic import ListView, DetailView, CreateView
from .models import BlogPost

class BlogPostListView(ListView):
    model = BlogPost
    template_name = 'adminPost/blogpost_list.html'
    context_object_name = 'posts'

class BlogPostDetailView(DetailView):
    model = BlogPost
    template_name = 'adminPost/blogpost_detail.html'
    context_object_name = 'post'

class BlogPostCreateView(CreateView):
    model = BlogPost
    template_name = 'adminPost/blogpost_form.html'
    fields = ['title', 'content']  # Add other fields as needed

    def form_valid(self, form):
        form.instance.author = self.request.user  # Assuming you have an 'author' field in your BlogPost model
        return super().form_valid(form)
