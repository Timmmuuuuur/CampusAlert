from django.db import models
import numpy as np
from simple_history.models import HistoricalRecords


class Report(models.Model):
    report_number = models.IntegerField(primary_key=True)
    date = models.DateTimeField(auto_now=True)
    status = models.CharField(max_length=20)
    emergency = models.BooleanField()
    location = models.ForeignKey("location", on_delete=models.CASCADE)
    crime = models.ForeignKey("crime", on_delete=models.CASCADE)

    history = HistoricalRecords()

    class Meta:
        app_label = 'emergency'


class Crime(models.Model):
    kind = models.CharField(max_length = 20, primary_key=True)
    description = models.CharField(max_length = 200)

    history = HistoricalRecords()

    class Meta:
        app_label = 'emergency'


class Coordinate(models.Model):
    longitude = models.FloatField(max_length=7)
    latitude = models.FloatField(max_length=7)

    def __str__(self):
        return f"Lat: {self.latitude}, Lon: {self.longitude}"
    
    def as_dict(self):
        return {
            'latitude': self.latitude,
            'longitude': self.longitude,
        }

    class Meta:
        app_label = 'emergency'
        ordering = ['longitude', 'latitude']


class Location(models.Model):
    campus = models.CharField(max_length=25)
    building = models.CharField(max_length=25)
    room = models.CharField(max_length=7)
    floor = models.IntegerField(default=000)
    coordinate = models.ForeignKey("coordinate", on_delete=models.CASCADE)

    history = HistoricalRecords()

    class Meta:
        app_label = 'emergency'
        ordering = ['building', 'floor', 'room']


class FloorLayout(models.Model):
    name = models.TextField(unique=True)
    layout_image = models.ImageField(upload_to='layout_images/', null=True, blank=True)

    history = HistoricalRecords()

    class Meta:
        app_label = 'emergency'
        ordering = ['name']

    def __str__(self):
        return self.name  # Display the 'name' field as the representation


class Building(models.Model):
    name = models.CharField(max_length=255, unique=True)

    history = HistoricalRecords()

    class Meta:
        ordering = ['name']

    def __str__(self):
        return str.capitalize(self.name)


class Floor(models.Model):
    building = models.ForeignKey(Building, on_delete=models.CASCADE, related_name='building')
    floor_number = models.IntegerField()
    layout = models.OneToOneField(FloorLayout, on_delete=models.CASCADE, related_name='layout')
    name = models.TextField(unique=True)

    # top left
    topleft = models.ForeignKey(Coordinate, on_delete=models.CASCADE, related_name='topleft')
    topright = models.ForeignKey(Coordinate, on_delete=models.CASCADE, related_name='topright')
    bottomleft = models.ForeignKey(Coordinate, on_delete=models.CASCADE, related_name='bottomleft')

    history = HistoricalRecords()

    class Meta:
        app_label = 'emergency'
        unique_together = ('building', 'floor_number')
        ordering = ['building', 'floor_number']

    def __str__(self):
        return f"{self.name} i.e. {str(self.building)} Floor {self.floor_number}"
    
    @staticmethod
    def _calculate_transformation_matrix(
        top_left, top_right, bottom_left,
        new_top_left, new_top_right, new_bottom_left
    ):
        # Convert points to NumPy arrays
        top_left = np.array(top_left)
        top_right = np.array(top_right)
        bottom_left = np.array(bottom_left)
        new_top_left = np.array(new_top_left)
        new_top_right = np.array(new_top_right)
        new_bottom_left = np.array(new_bottom_left)

        # Construct matrices A and B
        A = np.array([
            [new_top_left[0], new_top_right[0], new_bottom_left[0]],
            [new_top_left[1], new_top_right[1], new_bottom_left[1]],
            [1, 1, 1]
        ])

        B = np.array([
            [top_left[0], top_right[0], bottom_left[0]],
            [top_left[1], top_right[1], bottom_left[1]],
            [1, 1, 1]
        ])

        # Calculate the transformation matrix T
        T = np.dot(A, np.linalg.inv(B))

        return T


    def get_transform(self):
        width_of_image = self.layout.layout_image.width
        height_of_image = self.layout.layout_image.height

        top_left = (0, 0)
        top_right = (width_of_image, 0)
        bottom_left = (0, height_of_image)

        new_top_left = (self.topleft.longitude, self.topleft.latitude)
        new_top_right = (self.topright.longitude, self.topright.latitude)
        new_bottom_left = (self.bottomleft.longitude, self.bottomleft.latitude)

        # Calculate the affine transformation matrix
        return self._calculate_transformation_matrix(
            top_left, top_right, bottom_left,
            new_top_left, new_top_right, new_bottom_left
        )


class RoomNode(models.Model):
    floor = models.ForeignKey(Floor, on_delete=models.CASCADE, related_name='floor')
    name = models.CharField(max_length=255)

    x = models.FloatField()
    y = models.FloatField()

    is_exit = models.BooleanField()

    history = HistoricalRecords()

    class Meta:
        app_label = 'emergency'
        unique_together = ('floor', 'name')
        ordering = ['floor', 'name']

    def __str__(self):
        return f"{str(self.floor.building)} {self.name}"
    
    def get_latlong(self):
        # Define a 2D point on the original image
        original_point = np.array([self.x, self.y, 1])

        # Use matrix-vector multiplication to transform the point, then throw away the extra dimension necessary for affine transform
        
        l = np.dot(self.floor.get_transform(), original_point)[:2][::-1]
        return Coordinate(latitude=l[0], longitude=l[1]).as_dict()


class RoomEdge(models.Model):
    nodes = models.ManyToManyField(RoomNode, related_name='nodes')

    history = HistoricalRecords()

    class Meta:
        ordering = ['id']

    def __str__(self):
        return '→'.join([str(n) for n in self.nodes.all()])


class Alert(models.Model):
    SYNC_THREAT_CHOICES = [
        ('fire', 'Fire'),
        ('attacker', 'Attacker'),
        ('storm', 'Storm'),
    ]

    syncThreat = models.CharField(max_length=10, choices=SYNC_THREAT_CHOICES)
    building = models.ForeignKey(Building, on_delete=models.CASCADE)
    floor = models.ForeignKey(Floor, on_delete=models.CASCADE)
    roomNode = models.ForeignKey(RoomNode, on_delete=models.CASCADE)
    time = models.DateTimeField(auto_now_add=True)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return f"{self.syncThreat} Alert at {self.roomNode} - {self.time}"
