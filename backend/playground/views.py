from django.shortcuts import render
from django.http import HttpResponse
from .models import report, location, coordinate, crime
import random
from django.views.generic import View

from rest_framework.views import APIView
from rest_framework.response import Response
# from ipware import get_client_ip

# Create your views here.
#request -> respond
#request handler
#action
class HomeView(View):
    def get(self, request, *args, **kwargs):
        return render(request, 'chartjs/index_chart.html')

class ChartData(APIView):
    authentication_classes = []
    permission_classes = []
   
    def get(self, request, format = None):
        labels = [
            'January',
            'February', 
            'March', 
            'April', 
            'May', 
            'June', 
            'July'
            ]
        chartLabel = "my data"
        chartdata = [0, 10, 5, 2, 20, 30, 45]
        data ={
            "labels":labels,
            "chartLabel":chartLabel,
            "chartdata":chartdata,
        }
        return render(request, 'chartjs/index_chart.html', data)

def index(request):

    # obj = report(report_num = random.randrange(20), status = "complete", emergency = False)
    # obj.save()

    num_crimes = crime.objects.count()
    num_location = location.objects.filter(Campus='main').count()
    num_reports = report.objects.count()
    num_coordinates = coordinate.objects.filter(Latitude='12.345').count()

    num_visits = request.session.get('num_visits', 0)
    request.session['num_visits'] = num_visits + 1

    context = {
        'num_visits': num_visits,
        'num_crimes': num_crimes,
        'num_locations': num_location,
        'num_coordinates': num_coordinates,
        'num_reports': num_reports
    }
    
    return render(request, 'index.html', context=context)