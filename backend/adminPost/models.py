# models.py
from django.db import models
from emergency.models import Building,Floor,Crime,Report  # Import the Building model from the emergency app

#for real time update with referenced parameters
from django.db.models.signals import post_save
from django.dispatch import receiver

class BlogPost(models.Model):
    title = models.CharField(max_length=255)
    content = models.TextField()
    pub_date = models.DateTimeField(auto_now_add=True)
    modified_date = models.DateTimeField(auto_now=True)  # Updated automatically on save
    photo = models.ImageField(upload_to='blog_photos/', null=True, blank=True)

     # Add a ForeignKey field referencing the Building & related model
    building = models.ForeignKey(Building, on_delete=models.CASCADE, related_name='blog_post_building', null=True, blank=True)
    #Node = models.ForeignKey(RoomNode, on_delete=models.CASCADE, related_name='blog_posts', null=True, blank=True)
    floor = models.ForeignKey(Floor, on_delete=models.CASCADE, related_name='blog_post_floor', null=True, blank=True)
    
    #other tag 
    crime = models.ForeignKey(Crime, on_delete=models.CASCADE, related_name='blog_post_crime', null=True, blank=True)
    report = models.ForeignKey(Report, on_delete=models.CASCADE, related_name='blog_post_report', null=True, blank=True)
    

    def __str__(self):

        return self.title
# code below: update with emergency model in real time
# @receiver(post_save, sender=Building)
# def update_blog_posts_with_building(sender, instance, **kwargs):
#     BlogPost.objects.filter(building=instance).update(building_name=instance.name)

# @receiver(post_save, sender=Floor)
# def update_blog_posts_with_floor(sender, instance, **kwargs):
#     BlogPost.objects.filter(floor=instance).update(floor_name=instance.name)

# @receiver(post_save, sender=Crime)
# def update_blog_posts_with_crime(sender, instance, **kwargs):
#     BlogPost.objects.filter(crime=instance).update(crime_name=instance.name)

# @receiver(post_save, sender=Report)
# def update_blog_posts_with_report(sender, instance, **kwargs):
#     BlogPost.objects.filter(report=instance).update(report_name=instance.name)
