from django import forms
from .models import Building, Floor, FloorLayout

class FloorLayoutForm(forms.ModelForm):
    class Meta:
        model = FloorLayout
        fields = ['name', 'layout_image']


class FloorForm(forms.ModelForm):
    class Meta:
        model = Floor
        fields = ['building', 'floor_number', 'layout', 'name']


class BuildingForm(forms.ModelForm):
    class Meta:
        model = Building
        fields = ['name']


class UploadRoomCSVForm(forms.Form):
    floor = forms.ModelChoiceField(Floor.objects)
    nodes_csv = forms.FileField(label='Nodes .csv file (named nodes.csv)')
    edges_csv = forms.FileField(label='Edges .csv file (named edges.csv)')
    