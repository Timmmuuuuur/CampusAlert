from django.urls import path
from . import views

#URLconfiguration
urlpatterns = [
    # path('', views.HomeView.as_view()),
    path('', views.index, name='index'),
    path('test_graphs', views.ChartData.as_view())
]
