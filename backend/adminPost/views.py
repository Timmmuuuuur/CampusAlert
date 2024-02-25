from django.shortcuts import render

from django import forms
# Create your views here.
# adminPost/views.py
from django.shortcuts import render
from django.views.generic import ListView, DetailView, CreateView
from .models import BlogPost
from .forms import BlogPostForm # user submit post, criteria form
from django.views.generic import TemplateView
from django.urls import reverse_lazy

import requests
from django.http import JsonResponse

from emergency.models import Building, RoomNode, Floor, Crime, Report


class BlogPostForm_emergency(forms.ModelForm): #for linking emergency database, used in adminPost as 
    # optional field
    class Meta:
        model = BlogPost
        fields = ['title', 'content', 'building', 'floor', 'crime', 'report', 'photo']
        
    # Define fields as optional dropdowns
    building = forms.ModelChoiceField(queryset=Building.objects.all(), empty_label="Select Building", required=False)
    #roomNode = forms.ModelChoiceField(queryset=RoomNode.objects.all(), empty_label="Select RoomNode", required=False)
    floor = forms.ModelChoiceField(queryset=Floor.objects.all(), empty_label="Select Floor", required=False)
    crime = forms.ModelChoiceField(queryset=Crime.objects.all(), empty_label="Select Crime", required=False)
    report = forms.ModelChoiceField(queryset=Report.objects.all(), empty_label="Select Report", required=False)



class AdminPostHomePageView(ListView):
    model = BlogPost
    template_name = 'adminPost/home_page.html'
    context_object_name = 'posts'  # for Html template: This is the variable used in the template for the list of posts. 
    def get_queryset(self):
        # Order the blog posts by publication date in descending order
        return BlogPost.objects.order_by('-pub_date')

class BlogPostListView(ListView): #retrieves a specific post
    model = BlogPost
    template_name = 'adminPost/blogpost_list.html'
    context_object_name = 'posts'


class BlogPostDetailView(DetailView):
    model = BlogPost
    template_name = 'adminPost/blogpost_detail.html'
    context_object_name = 'post'

class BlogPostCreateView(CreateView):
    template_name = 'adminPost/blogpost_form.html'
    model = BlogPost
    form_class = BlogPostForm
   
    
    success_url = reverse_lazy('adminPost_home')

    def form_valid(self, form):
        # Handle file upload manually
        photo = self.request.FILES.get('photo')
        if photo:
            form.instance.photo = photo

        # Process the form data
        # Save the form or perform other actions

        # Get emergency form data
        emergency_form = BlogEmergencyForm(self.request.POST)
        if emergency_form.is_valid():
            emergency_form.save()
        return super().form_valid(form)

        
    def send_to_flutter_notification(self, data):
        # Define the URL of the Flutter endpoint
        flutter_endpoint = 'http://<flutter_server_address>/adimPost_notification'

        # Extract picture data if available
        picture_data = None
        if 'photo' in data:
            picture_data = data.pop('photo')  # Remove picture data from the main data

        # Construct the payload to send to Flutter
        payload = {'blog_post_data': data}

        # Send picture data if available
        if picture_data:
            files = {'photo': picture_data}
        else:
            files = None

        # Make a POST request to the Flutter endpoint
        response = requests.post(flutter_endpoint, data=payload, files=files)

        # Check if the request was successful
        if response.status_code == 200:
            print('Notification sent to Flutter successfully')
        else:
            print('Failed to send notification to Flutter')

    def get(self, request, *args, **kwargs):
        form = BlogPostForm()
        return render(request, self.template_name, {'form': form})

    def post(self, request, *args, **kwargs):
        form = self.get_form()  # Use get_form() method to get the form instance
        if form.is_valid():
            return super().form_valid(form)
        else:
            return self.form_invalid(form)



def send_notification(request):
    # Assuming you receive the device token and notification data from the Flutter app
    device_token = request.POST.get('device_token')
    notification_data = {
        'title': 'Your notification title',
        'body': 'Your notification body'
    }
    
    # Send notification to FCM
    fcm_url = 'https://fcm.googleapis.com/fcm/send'
    fcm_key = 'YOUR_FCM_SERVER_KEY'  # Get this from your Firebase project settings
    headers = {
        'Authorization': 'key=' + fcm_key,
        'Content-Type': 'application/json'
    }
    payload = {
        'to': device_token,
        'notification': notification_data
    }
    response = requests.post(fcm_url, headers=headers, json=payload)

    if response.status_code == 200:
        return JsonResponse({'success': True})
    else:
        return JsonResponse({'success': False, 'error': response.text})
