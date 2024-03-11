# alarm/admin.py
from django.contrib import admin
from .models import Alarm

class AlarmAdmin(admin.ModelAdmin):
    # Include the fields you want to display in the admin interface
    fields = ['active']

admin.site.register(Alarm, AlarmAdmin)
