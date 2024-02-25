# models.py
from django.db import models
from emergency.models import Building,Floor,Crime,Report  # Import the Building model from the emergency app


class BlogPost(models.Model):
    title = models.CharField(max_length=255)
    content = models.TextField()
    pub_date = models.DateTimeField(auto_now_add=True)
    modified_date = models.DateTimeField(auto_now=True)  # Updated automatically on save
    photo = models.ImageField(upload_to='blog_photos/', null=True, blank=True)

     # Add a ForeignKey field referencing the Building & related model
    building = models.ForeignKey(Building, on_delete=models.CASCADE, related_name='blog_posts', null=True, blank=True)
    #Node = models.ForeignKey(RoomNode, on_delete=models.CASCADE, related_name='blog_posts', null=True, blank=True)
    floor = models.ForeignKey(Floor, on_delete=models.CASCADE, related_name='blog_posts', null=True, blank=True)
    
    #other tag 
    crime = models.ForeignKey(Crime, on_delete=models.CASCADE, related_name='blog_posts', null=True, blank=True)
    report = models.ForeignKey(Report, on_delete=models.CASCADE, related_name='blog_posts', null=True, blank=True)
    

    def __str__(self):
        return self.title
