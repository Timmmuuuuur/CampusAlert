# adminPost/urls.py
from django.urls import path
from .views import (
    BlogPostListView,
    BlogPostDetailView,
    BlogPostCreateView,
    AdminPostHomePageView,
    api_post_list  # Import the api_post_list function
)



urlpatterns = [
    #path('posts/', BlogPostListView.as_view(), name='post_list'),
    path('adminPost_home/', AdminPostHomePageView.as_view(), name='adminPost_home'),
    path('posts/new/', BlogPostCreateView.as_view(), name='blogpost_create'),
    path('posts/<int:pk>/', BlogPostDetailView.as_view(), name='post_detail'),
    #APIs for frontend flutter:
    path('api/posts/', api_post_list, name='api_post_list'),



    #redirection hint, but can be removed
    #path('post_submission_success/', AdminPostHomePageView.as_view(), name='adminPost_homePage'),
    
    # Add more patterns as needed
]
