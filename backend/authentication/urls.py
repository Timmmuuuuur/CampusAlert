from django.urls import include, path
from .views import ObtainAuthToken, RefreshAuthToken, VerifyAuthToken, LogoutUser, add_firebase_device, whoami
from rest_framework_jwt.views import obtain_jwt_token, refresh_jwt_token


urlpatterns = [
    path('login/', ObtainAuthToken.as_view()),
    path('logout/', LogoutUser.as_view()),

    # the below 3 APIs are useless for now, since user is not allowed to refresh their
    # path('refresh/', RefreshAuthToken.as_view()),
    # path('verify/', VerifyAuthToken.as_view()),
    # path('logout/', LogoutUser.as_view()),
    path('whoami/', whoami),
    path('add-fcm/', add_firebase_device),
]
