from django.contrib import admin
from .models import report
from .models import coordinate
from .models import crime
from .models import location

# Register your models here.
admin.site.register(report)
admin.site.register(crime)
admin.site.register(coordinate)
admin.site.register(location)