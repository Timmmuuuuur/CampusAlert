from django.urls import path
from . import views

urlpatterns = [
    path('upload/', views.upload_photo, name='upload_photo'),
    path('photos/', views.view_uploaded_photos, name='view_uploaded_photos'),
]