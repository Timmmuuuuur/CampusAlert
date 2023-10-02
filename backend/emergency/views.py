from django.shortcuts import render, redirect, get_object_or_404
from fcm_django.models import FCMDevice
from firebase_admin.messaging import Message, Notification
from .forms import FloorForm, FloorLayoutForm
from django.urls import reverse

from django.http import JsonResponse

from .models import FloorLayout

def call_notification(title, body):
    print('Button pressed! Python function called.')
    message = Message(
        notification=Notification(title=title, body=body, image="url")
    )
    devices = FCMDevice.objects.all()

    for device in devices:
        device.send_message(message)


def notification_test(request):
    if request.method == 'POST':
        title = request.POST.get('notification-title')
        body = request.POST.get('notification-body')
        # Call your Python function here
        call_notification(title, body)

    return render(request, 'notification_test.html')


def create_floor(request):
    if request.method == 'POST':
        form = FloorForm(request.POST, request.FILES)
        if form.is_valid():
            form.save()
            # Add a success message to the context
            context = {'form': form, 'success_message': 'Successfully added!'}
            return render(request, 'create_floor.html', context)
    else:
        form = FloorForm()

    return render(request, 'create_floor.html', {'form': form})

def create_floorlayout(request):
    if request.method == 'POST':
        form = FloorLayoutForm(request.POST, request.FILES)
        if form.is_valid():
            form.save()
            # Add a success message to the context
            context = {'form': form, 'success_message': 'Successfully added!'}
            return render(request, 'create_floorlayout.html', context)
    else:
        form = FloorLayoutForm()

    return render(request, 'create_floorlayout.html', {'form': form})


def get_floorlayout_image_url(request):
    name = request.GET.get('name', '')
    floor_layout = get_object_or_404(FloorLayout, name=name)
    print(floor_layout)

    # Check if layout_image is not empty
    if floor_layout.layout_image:
        # Return the URL to the image
        image_url = floor_layout.layout_image.url
        return JsonResponse({'image_url': image_url})
    else:
        # Handle cases where layout_image is empty
        return JsonResponse({'error': 'Image not found for this name.'})