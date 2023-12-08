# models.py in the photo server app

from django.db import models

# some_file.py
import sys
# caution: path[0] is reserved for script path (or '' in REPL)
#sys.path.insert(1, '../emergency/')

#import models

class Photo(models.Model):
    image = models.ImageField(upload_to='photos/')
    latitude = models.FloatField(null=True, blank=True)
    longitude = models.FloatField(null=True, blank=True)
    #building = models.ForeignKey(Building, on_delete=models.CASCADE, null=True, blank=True)
    #floor = models.ForeignKey(Floor, on_delete=models.CASCADE, null=True, blank=True)
    # other fields...

    def __str__(self):
        return f"Photo {self.id}"
