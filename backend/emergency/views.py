from django.shortcuts import render
from fcm_django.models import FCMDevice
from firebase_admin.messaging import Message, Notification

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