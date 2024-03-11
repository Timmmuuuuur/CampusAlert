# models.py
from django.db import models

class Alarm(models.Model):
    alarm1 = models.BooleanField(default=False)
