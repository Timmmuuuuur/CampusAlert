# adminPost/urls.py
from django.urls import path

from rest_framework.views import APIView

from .views import (
    BlogPostListView,
    BlogPostDetailView,
    BlogPostCreateView,
    AdminPostHomePageView,
    BuildingCrimeAPIView,
    api_post_list, # Import the api_post_list function
    EditPostView,
    delete_post,
)



urlpatterns = [
    #path('posts/', BlogPostListView.as_view(), name='post_list'),
    path('adminPost_home/', AdminPostHomePageView.as_view(), name='adminPost_home'),
    path('posts/new/', BlogPostCreateView.as_view(), name='blogpost_create'),
    path('posts/<int:pk>/', BlogPostDetailView.as_view(), name='post_detail'),
    #APIs for frontend flutter:
    path('api/posts/', api_post_list, name='api_post_list'),
    path('api/building_crime/', BuildingCrimeAPIView.as_view(), name='BuildingCrimeAPIView'),
    path('edit_post/<int:pk>/', EditPostView.as_view(), name='edit_post'),
    path('delete_post/<int:pk>/', delete_post, name='delete_post'),
    


    #redirection hint, but can be removed
    #path('post_submission_success/', AdminPostHomePageView.as_view(), name='adminPost_homePage'),
    
    # Add more patterns as needed
]
