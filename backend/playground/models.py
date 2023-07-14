from pydoc import describe
from re import search
from statistics import mode
from django.db import models

# Create your models here.
class report(models.Model):
    Report_number = models.IntegerField(primary_key=True)
    Date = models.DateTimeField(auto_now=True)
    Status = models.CharField(max_length=20)
    Emergency = models.BooleanField()
    Location = models.ForeignKey("location", on_delete=models.CASCADE)
    Crime = models.ForeignKey("crime", on_delete=models.CASCADE)

class crime(models.Model):
    Type = models.CharField(max_length = 20, primary_key=True)
    Description = models.CharField(max_length = 200)

class coordinate(models.Model):
    Longitude = models.FloatField(max_length=7)
    Latitude = models.FloatField(max_length=7)

class location(models.Model):
    Campus = models.CharField(max_length=25)
    Building = models.CharField(max_length=25)
    Room = models.CharField(max_length=7)
    Floor = models.IntegerField(default=000)
    Coordinate = models.ForeignKey("coordinate", on_delete=models.CASCADE)
