from django.contrib.auth.models import User
from rest_framework import serializers
from .models import Alert, Coordinate, Building, Floor, FloorLayout, RoomNode, RoomEdge

class CoordinateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Coordinate
        fields = '__all__'


class BuildingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Building
        fields = '__all__'


class FloorLayoutSerializer(serializers.ModelSerializer):
    name = serializers.CharField()

    class Meta:
        model = FloorLayout
        fields = '__all__'


class FloorSerializer(serializers.ModelSerializer):
    building = BuildingSerializer()
    layout = FloorLayoutSerializer()
    topleft = CoordinateSerializer()
    topright = CoordinateSerializer()
    bottomleft = CoordinateSerializer()

    class Meta:
        model = Floor
        fields = '__all__'


class FloorPKSerializer(serializers.ModelSerializer):

    class Meta:
        model = Floor
        fields = ['id']


class RoomNodeSerializer(serializers.ModelSerializer):
    floor = FloorPKSerializer()  # Include the related FloorSerializer
    name = serializers.CharField()

    x = serializers.FloatField()
    y = serializers.FloatField()

    is_exit = serializers.BooleanField()

    latlong = serializers.SerializerMethodField('get_latlong')

    def get_latlong(self, obj: RoomNode):
        return obj.get_latlong()


    class Meta:
        model = RoomNode
        fields = ['id', 'floor', 'name', 'x', 'y', 'is_exit', 'latlong']


class RoomNodePKSerializer(serializers.ModelSerializer):
    class Meta:
        model = Floor
        fields = ['id']


class RoomEdgeSerializer(serializers.ModelSerializer):
    nodes = RoomNodePKSerializer(many=True)

    class Meta:
        model = RoomEdge
        fields = '__all__'


class BasicUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['username', 'email']


class AlertSerializer(serializers.ModelSerializer):
    syncThreat = serializers.CharField(required=False)
    building = serializers.PrimaryKeyRelatedField(queryset=Building.objects.all(), required=False)
    floor = serializers.PrimaryKeyRelatedField(queryset=Floor.objects.all(), required=False)
    roomNode = serializers.PrimaryKeyRelatedField(queryset=RoomNode.objects.all(), required=False)

    class Meta:
        model = Alert
        fields = ['id', 'syncThreat', 'building', 'floor', 'roomNode', 'time']


class AlertCompleteSerializer(serializers.ModelSerializer):
    syncThreat = serializers.CharField(required=False)
    building = BuildingSerializer()
    floor = FloorSerializer()
    roomNode = RoomNodeSerializer()
    reporter = BasicUserSerializer()
    resolver = BasicUserSerializer()

    class Meta:
        model = Alert
        fields = ['id', 'syncThreat', 'building', 'floor', 'roomNode', 'time', 'reporter', 'resolver']