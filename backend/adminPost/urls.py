# adminPost/urls.py
from django.urls import path
from .views import BlogPostListView, BlogPostDetailView, BlogPostCreateView, AdminPostHomePageView


urlpatterns = [
    #path('posts/', BlogPostListView.as_view(), name='post_list'),
    path('adminPost_home/', AdminPostHomePageView.as_view(), name='adminPost_home'),
    path('posts/new/', BlogPostCreateView.as_view(), name='blogpost_create'),
    path('posts/<int:pk>/', BlogPostDetailView.as_view(), name='post_detail'),

    #redirection hint, but can be removed
    #path('post_submission_success/', AdminPostHomePageView.as_view(), name='adminPost_homePage'),
    
    # Add more patterns as needed
]
