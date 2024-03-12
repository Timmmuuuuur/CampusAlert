# models.py
from django.db import models

class Alarm(models.Model):
    active = models.BooleanField(default=False)

# Create an instance of Alarm
#alarm1 = Alarm.objects.get(pk=1)