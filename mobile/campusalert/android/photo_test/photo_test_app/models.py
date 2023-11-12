from django.db import models


class PhotoUpload(models.Model):  
    # Photo upload class and allowable paramters upon upload side: download at url.py + views.py
    id = models.AutoField(primary_key=True) # concurrent and thread safe PK assignment 
    image = models.ImageField(upload_to='photos/')
    uploaded_at = models.DateTimeField(auto_now_add=True)
    description = models.TextField() #user adding description upon photo uplaod
    llocation = models.CharField(max_length=100) # type-in location with drop down menu recommendation using location 
    class Meta: ##if the code base is not in conventional Django structure
            app_label = 'photo_test_app'

    def __str__(self): # string identity of Photo
        return f'{self.photo_id}' 
