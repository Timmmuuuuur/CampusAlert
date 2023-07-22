# photo_test_app/views.py
from django.http import HttpResponse
from rest_framework import viewsets
from .models import Photo
from .serializers import PhotoSerializer

class PhotoViewSet(viewsets.ModelViewSet):
    queryset = Photo.objects.all()
    serializer_class = PhotoSerializer

# Your other view functions or classes here
# ...
# views.py
from django.http import HttpResponse

def upload_photo(request):
    if request.method == 'POST':
        form = PhotoUploadForm(request.POST, request.FILES)
        if form.is_valid():
            # Process the uploaded photo here
            # For example, save it to the database or storage
            form.save()
            return render(request, 'success.html')
    else:
        form = PhotoUploadForm()
    return render(request, 'upload_photo.html', {'form': form})

    

def view_uploaded_photos(request):
    # Your view logic here
    return HttpResponse("Viewing uploaded photos")
