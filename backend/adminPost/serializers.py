# serializers.py
from rest_framework import serializers
from .models import Building


class BuildingCrimeSerializer(serializers.Serializer):
    building_name = serializers.CharField()
    crime_count_30_days = serializers.IntegerField()


