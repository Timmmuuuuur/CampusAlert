from django.shortcuts import render

from rest_framework_jwt.views import ObtainJSONWebToken, RefreshJSONWebToken, VerifyJSONWebToken
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from django.contrib.auth.models import User
from fcm_django.models import FCMDevice

from .serializers import FCMDeviceSerializer


class ObtainAuthToken(ObtainJSONWebToken):
    """Custom authentication view for obtaining JWT tokens."""
    pass

class RefreshAuthToken(RefreshJSONWebToken):
    """Custom authentication view for refreshing JWT tokens."""
    pass

class VerifyAuthToken(VerifyJSONWebToken):
    """Custom authentication view for verifying JWT tokens."""
    pass

# Ideally, we would want to refresh the user secret to invalidate all tokens. But that is overly complicated. It's probably better just for the token to decay on its own.
class LogoutUser(APIView):
    """View for logging out a user."""
    permission_classes = [IsAuthenticated]

    def post(self, request):
        # Implement logout logic here (e.g., invalidate the token)
        return Response(status=status.HTTP_200_OK)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def whoami(request):
    user = request.user
    
    return Response({
        'username': user.username,
        'email': user.email
    })

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def add_firebase_device(request):

    user = request.user

    print(request.body.decode('utf-8'))
    print(request.data.get('token')) # This prints None

    device = FCMDevice.objects.filter(user=user).first()
    if device is None:
        device = FCMDevice.objects.create(user=user, active=True, registration_id=request.data.get('token'))

    device.registration_id = request.data.get('token')
    device.save()

    return Response(FCMDeviceSerializer(device).data, status=status.HTTP_201_CREATED)