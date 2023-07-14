from django.contrib import admin
from .models import Report
from .models import Coordinate
from .models import Crime
from .models import Location

# Register your models here.
admin.site.register(Report)
admin.site.register(Crime)
admin.site.register(Coordinate)
admin.site.register(Location)