from django import forms
from .models import Floor, FloorLayout

class FloorLayoutForm(forms.ModelForm):
    class Meta:
        model = FloorLayout
        fields = ['name', 'layout_image']


class FloorForm(forms.ModelForm):
    class Meta:
        model = Floor
        fields = ['level', 'begin', 'end', 'layout']