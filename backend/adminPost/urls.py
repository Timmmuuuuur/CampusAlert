# adminPost/urls.py
from django.urls import path
from .views import BlogPostListView, BlogPostDetailView, BlogPostCreateView

urlpatterns = [
    path('posts/', BlogPostListView.as_view(), name='post_list'),
    path('posts/<int:pk>/', BlogPostDetailView.as_view(), name='post_detail'),
    path('posts/new/', BlogPostCreateView.as_view(), name='post_create'),
    # Add more patterns as needed
]
