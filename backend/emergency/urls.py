from django.urls import path
from .views import BuildingView, FloorLayoutView, FloorView, RoomEdgeView, notification_test, create_floor, create_floorlayout, get_floorlayout_image_url, create_rooms, create_building, RoomNodeView, history_latest_change

urlpatterns = [
    path('notificationtest', notification_test, name='notification_test'),

    # Creation forms
    path('floorlayout/create', create_floorlayout, name='create_floorlayout'),
    path('floor/create', create_floor, name='create_floor'),
    path('room/create', create_rooms, 
    name='create_rooms'),
    path('building/create', create_building, name='create_rooms'),

    # GET endpoints
    path('floorlayout/get_image_url', get_floorlayout_image_url, name='get_floorlayout_image_url'),
    path('room/node/all', RoomNodeView.as_view(), name='all_roomnodes'),
    path('room/edge/all', RoomEdgeView.as_view(), name='all_roomedges'),
    path('building/all', BuildingView.as_view(), name='all_buildings'),
    path('floor/all', FloorView.as_view(), name='all_floors'),
    path('floorlayout/all', FloorLayoutView.as_view(), name='all_floorlayouts'),

    path('changes/latest', history_latest_change, name='history_latest_change')

]