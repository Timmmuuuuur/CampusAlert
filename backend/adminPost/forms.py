from django import forms
from .models import BlogPost
from emergency.models import Building, Floor, Crime, Report

class BlogPostForm(forms.ModelForm):
    class Meta:
        model = BlogPost
        fields = ['title', 'content', 'building', 'floor', 'crime', 'report', 'photo']
        
    # Define fields as optional dropdowns
    building = forms.ModelChoiceField(queryset=Building.objects.all(), empty_label="Select Building", required=False)
    #roomNode = forms.ModelChoiceField(queryset=RoomNode.objects.all(), empty_label="Select RoomNode", required=False)
    floor = forms.ModelChoiceField(queryset=Floor.objects.all(), empty_label="Select Floor", required=False)
    crime = forms.ModelChoiceField(queryset=Crime.objects.all(), empty_label="Select Crime", required=False)
    report = forms.ModelChoiceField(queryset=Report.objects.all(), empty_label="Select Report", required=False)

    exclude = ['published_date', 'modified_date']