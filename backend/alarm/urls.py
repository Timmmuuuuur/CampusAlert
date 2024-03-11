# urls.py
from django.urls import path
from .views import AlarmStatus, AlarmControlView

urlpatterns = [
    path('api/low_late/', AlarmStatus.as_view(), name='alarm-status'),
    path('low_late/control', AlarmControlView.as_view(), name='alarm-control'),
]
