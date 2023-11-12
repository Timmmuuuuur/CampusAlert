from django import forms

class PhotoUploadForm(forms.Form): # defines behavior of the HTML ./template/photo_test_apps/upload_photo.html
    image = forms.ImageField()
    description = forms.CharField(widget=forms.Textarea)
    location = forms.CharField(max_length=100, required=False, widget=forms.TextInput(attrs={'id': 'locationInput', 'placeholder': 'Type your location...'}))