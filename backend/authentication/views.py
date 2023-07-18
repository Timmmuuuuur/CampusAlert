from django.shortcuts import render

from rest_framework_jwt.views import ObtainJSONWebToken, RefreshJSONWebToken, VerifyJSONWebToken
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from django.contrib.auth.models import User


class ObtainAuthToken(ObtainJSONWebToken):
    """Custom authentication view for obtaining JWT tokens."""
    pass

class RefreshAuthToken(RefreshJSONWebToken):
    """Custom authentication view for refreshing JWT tokens."""
    pass

class VerifyAuthToken(VerifyJSONWebToken):
    """Custom authentication view for verifying JWT tokens."""
    pass

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