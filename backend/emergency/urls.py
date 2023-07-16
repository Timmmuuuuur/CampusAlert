from django.urls import path
from .views import notification_test

urlpatterns = [
    path('notificationtest', notification_test, name='notification-test'),
]