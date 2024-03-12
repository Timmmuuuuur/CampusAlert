# urls.py
from django.urls import path
from .views import AlarmStatus, AlarmControlView

urlpatterns = [
    path('low_late/api', AlarmStatus.as_view(), name='alarm-status'),
    path('low_late/control', AlarmStatus.as_view(), name='alarm-control'),
]
