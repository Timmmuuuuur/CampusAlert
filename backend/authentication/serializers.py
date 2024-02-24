from django.contrib.auth.models import User
from rest_framework import serializers
from fcm_django.models import FCMDevice

class BasicUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['username', 'email']


class FCMDeviceSerializer(serializers.ModelSerializer):
    user = BasicUserSerializer()

    class Meta:
        model = FCMDevice
        fields = ['user', 'registration_id']
