from django.urls import path
from .views import notification_test, create_floor, create_floorlayout, get_floorlayout_image_url, create_rooms, godot_game

urlpatterns = [
    path('notificationtest', notification_test, name='notification_test'),
    path('floorlayout/create', create_floorlayout, name='create_floorlayout'),
    path('floor/create', create_floor, name='create_floor'),
    path('floorlayout/get_image_url', get_floorlayout_image_url, name='get_floorlayout_image_url'),
    path('room/create', create_rooms, name='create_rooms'),
    path('godottest', godot_game, name='godot_game')
]