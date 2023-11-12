# views.py in the photo server app

from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import Photo
from .serializers import PhotoSerializer

@api_view(['GET'])
def get_all_photos(request):
    latitude = request.GET.get('latitude')
    longitude = request.GET.get('longitude')

    # You can add additional filters based on building, floor, etc.
    building_id = request.GET.get('building_id')
    floor_id = request.GET.get('floor_id')

    # Build a filter dictionary based on provided parameters
    filter_dict = {}
    if latitude:
        filter_dict['latitude'] = latitude
    if longitude:
        filter_dict['longitude'] = longitude
    if building_id:
        filter_dict['building_id'] = building_id
    if floor_id:
        filter_dict['floor_id'] = floor_id

    # Query photos based on the filter criteria
    photos = Photo.objects.filter(**filter_dict)

    serializer = PhotoSerializer(photos, many=True)
    return Response(serializer.data)
