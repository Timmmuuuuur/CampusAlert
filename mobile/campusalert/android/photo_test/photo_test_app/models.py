from django.db import models


class Photo(models.Model):
    id = models.AutoField(primary_key=True)
    image = models.ImageField(upload_to='photos/')
    uploaded_at = models.DateTimeField(auto_now_add=True)
    class Meta:
            app_label = 'photo_test_app'

    def __str__(self):
        return self.image.name
