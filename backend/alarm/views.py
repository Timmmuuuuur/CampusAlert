# views.py
from django.shortcuts import render
from django.views.generic.base import TemplateView
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Alarm

class AlarmStatus(APIView):
    def get(self, request):
        alarm1 = Alarm.objects.first()  # Assuming only one alarm object exists
        alarm1 = Alarm.objects.first()  # Assuming only one alarm object exists
        return Response({'active': alarm1.active})

    def post(self, request):
        alarm1 = Alarm.objects.first()  # Assuming only one alarm object exists
        alarm1.active = True
        alarm1.save()
        return Response({'message': 'Alarm activated'}, status=status.HTTP_200_OK)

    def delete(self, request):
        alarm1 = Alarm.objects.first()  # Assuming only one alarm object exists
        alarm1.active = False
        alarm1.save()
        return Response({'message': 'Alarm deactivated'}, status=status.HTTP_200_OK)

class AlarmControlView(TemplateView):
    template_name = 'alarm/alarm_set.html'
