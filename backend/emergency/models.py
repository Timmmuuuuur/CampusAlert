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
    

class Floor(models.Model):
    level = models.IntegerField(unique=True)

    # top left
    topleft = models.ForeignKey(Coordinate, on_delete=models.CASCADE, related_name='topleft')
    topright = models.ForeignKey(Coordinate, on_delete=models.CASCADE, related_name='topright')
    bottomleft = models.ForeignKey(Coordinate, on_delete=models.CASCADE, related_name='bottomleft')
    layout = models.OneToOneField(FloorLayout, on_delete=models.CASCADE, related_name='layout')

    class Meta:
        app_label = 'emergency'
