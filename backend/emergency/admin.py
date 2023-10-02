from django.contrib import admin
from .models import Report
from .models import Coordinate
from .models import Crime
from .models import Location
from .models import Floor
from .models import FloorLayout

# Register your models here.
admin.site.register(Report)
admin.site.register(Crime)
admin.site.register(Coordinate)
admin.site.register(Location)
admin.site.register(Floor)
admin.site.register(FloorLayout)