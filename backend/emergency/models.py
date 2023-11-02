from django.db import models


class Report(models.Model):
    report_number = models.IntegerField(primary_key=True)
    date = models.DateTimeField(auto_now=True)
    status = models.CharField(max_length=20)
    emergency = models.BooleanField()
    location = models.ForeignKey("location", on_delete=models.CASCADE)
    crime = models.ForeignKey("crime", on_delete=models.CASCADE)

    class Meta:
        app_label = 'emergency'


class Crime(models.Model):
    kind = models.CharField(max_length = 20, primary_key=True)
    description = models.CharField(max_length = 200)

    class Meta:
        app_label = 'emergency'


class Coordinate(models.Model):
    longitude = models.FloatField(max_length=7)
    latitude = models.FloatField(max_length=7)

    def __str__(self):
        return f"Lat: {self.latitude}, Lon: {self.longitude}"

    class Meta:
        app_label = 'emergency'


class Location(models.Model):
    campus = models.CharField(max_length=25)
    building = models.CharField(max_length=25)
    room = models.CharField(max_length=7)
    floor = models.IntegerField(default=000)
    coordinate = models.ForeignKey("coordinate", on_delete=models.CASCADE)

    class Meta:
        app_label = 'emergency'


class FloorLayout(models.Model):
    name = models.TextField(unique=True)
    layout_image = models.ImageField(upload_to='layout_images/', null=True, blank=True)

    class Meta:
        app_label = 'emergency'

    def __str__(self):
        return self.name  # Display the 'name' field as the representation


class Building(models.Model):
    name = models.CharField(max_length=255, unique=True)

    def __str__(self):
        return str.capitalize(self.name)


class Floor(models.Model):
    building = models.ForeignKey(Building, on_delete=models.CASCADE, related_name='building')
    floor_number = models.IntegerField(unique=True)
    layout = models.OneToOneField(FloorLayout, on_delete=models.CASCADE, related_name='layout')
    name = models.TextField(unique=True)

    # top left
    topleft = models.ForeignKey(Coordinate, on_delete=models.CASCADE, related_name='topleft')
    topright = models.ForeignKey(Coordinate, on_delete=models.CASCADE, related_name='topright')
    bottomleft = models.ForeignKey(Coordinate, on_delete=models.CASCADE, related_name='bottomleft')

    class Meta:
        app_label = 'emergency'
        unique_together = ('building', 'floor_number')

    def __str__(self):
        return f"{self.name} i.e. {str(self.building)} Floor {self.floor_number}"


class RoomNode(models.Model):
    floor = models.ForeignKey(Floor, on_delete=models.CASCADE, related_name='floor')
    name = models.CharField(max_length=255)

    x = models.FloatField()
    y = models.FloatField()

    is_exit = models.BooleanField()

    class Meta:
        app_label = 'emergency'
        unique_together = ('floor', 'name')

    def __str__(self):
        return f"{str(self.floor.building)} {self.name}"


class RoomEdge(models.Model):
    nodes = models.ManyToManyField(RoomNode, related_name='nodes')

    def __str__(self):
        return '→'.join([str(n) for n in self.nodes.all()])