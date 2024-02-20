import numpy as np
import pandas as pd
from django.db.models import Q
from django.http import HttpResponse, JsonResponse
from django.shortcuts import get_object_or_404, redirect, render
from django.urls import reverse
from django.views.decorators.csrf import csrf_exempt
from fcm_django.models import FCMDevice
from firebase_admin.messaging import Message, Notification
from rest_framework import generics
from rest_framework.parsers import JSONParser
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializers import AlertSerializer, RoomNodeSerializer, RoomEdgeSerializer, FloorLayoutSerializer, FloorSerializer, BuildingSerializer

from .forms import BuildingForm, FloorForm, FloorLayoutForm, UploadRoomCSVForm
from .models import Alert, Coordinate, Floor, FloorLayout, RoomEdge, RoomNode, Building


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
            print(form.cleaned_data)
            topleft = Coordinate.objects.create(
                longitude=request.POST.get('longitude1'),
                latitude=request.POST.get('latitude1')
            )
            topright = Coordinate.objects.create(
                longitude=request.POST.get('longitude2'),
                latitude=request.POST.get('latitude2')
            )
            bottomleft = Coordinate.objects.create(
                longitude=request.POST.get('longitude3'),
                latitude=request.POST.get('latitude3')
            )

            building = form.cleaned_data['building']
            floor_number = form.cleaned_data['floor_number']
            layout = form.cleaned_data['layout']
            name = form.cleaned_data['name']

            Floor.objects.create(
                building=building,
                floor_number=floor_number,
                name=name,
                layout=layout,
                topleft=topleft,
                topright=topright,
                bottomleft=bottomleft,
            )

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


def create_building(request):
    if request.method == 'POST':
        form = BuildingForm(request.POST, request.FILES)
        if form.is_valid():
            form.save()
            # Add a success message to the context
            context = {'form': form, 'success_message': 'Successfully added!'}
            return render(request, 'create_building.html', context)
    else:
        form = BuildingForm()

    return render(request, 'create_building.html', {'form': form})


# TODO: outdated, possibly delete
# def create_rooms(request):
#     if request.method == 'POST':
#         form = FloorLayoutForm(request.POST, request.FILES)
#         if form.is_valid():
#             form.save()
#             # Add a success message to the context
#             context = {'form': form, 'success_message': 'Successfully added!'}
#             return render(request, 'create_floorlayout.html', context)
#     else:
#         form = FloorLayoutForm()

#     return render(request, 'create_rooms.html', {'form': form})


def get_floorlayout_image_url(request):
    name = request.GET.get('name', '')
    floor_layout = get_object_or_404(FloorLayout, name=name)

    # Check if layout_image is not empty
    if floor_layout.layout_image:
        # Return the URL to the image
        image_url = floor_layout.layout_image.url
        return JsonResponse({'image_url': image_url})
    else:
        # Handle cases where layout_image is empty
        return JsonResponse({'error': 'Image not found for this name.'})
    

def get_last_edit(request):
    name = request.GET.get('name', '')
    floor_layout = get_object_or_404(FloorLayout, name=name)

    # Check if layout_image is not empty
    if floor_layout.layout_image:
        # Return the URL to the image
        image_url = floor_layout.layout_image.url
        return JsonResponse({'image_url': image_url})
    else:
        # Handle cases where layout_image is empty
        return JsonResponse({'error': 'Image not found for this name.'})


def parse_csv(form, name):
    try:
        # Attempt to read and parse CSV files
        return pd.read_csv(form.cleaned_data[name])
    except Exception as e:
        form.add_error(name, f'This is not a valid .csv')
        raise Exception("An error has occured.")


NODES_COLUMNS = ['name', 'x', 'y', 'is_exit']
EDGES_COLUMNS = ['start_floor', 'start_room_name',
                 'end_floor', 'end_room_name']


def check_columns(form, df, columns, name):
    if all(col in df.columns for col in columns):
        return
    else:
        missing_columns = [col for col in columns if col not in df.columns]
        form.add_error(
            name, f'Desired columns {missing_columns} are missing from the .csv.')
        raise Exception(
            f"Desired columns {missing_columns} are missing from the .csv.")


def create_rooms(request):
    if request.method == 'POST':
        form = UploadRoomCSVForm(request.POST, request.FILES)
        if form.is_valid():
            try:
                floor = form.cleaned_data['floor']
                # Attempt to read and parse CSV files
                nodes_csv = parse_csv(form, 'nodes_csv')
                edges_csv = parse_csv(form, 'edges_csv')

                # Check to make sure that all the columns are correct
                check_columns(form, nodes_csv, NODES_COLUMNS, 'nodes_csv')
                check_columns(form, edges_csv, EDGES_COLUMNS, 'edges_csv')

                # print(nodes_csv)
                # print(edges_csv)

                ignored_rooms = set()

                for _, row in nodes_csv.iterrows():
                    rd = row.to_dict()

                    # print(rd, form.cleaned_data['floor'])

                    if RoomNode.objects.filter(floor=floor, name=rd['name']).first() is None:
                        RoomNode.objects.create(
                            floor=floor,
                            name=rd['name'],
                            x=rd['x'],
                            y=rd['y'],
                            is_exit=rd['is_exit']
                        )
                    else:
                        ignored_rooms.add(rd['name'])

                if len(ignored_rooms) != 0:
                    form.add_error(
                        None, f"The following room entries are skipped because they already exist in the database: {[s for s in ignored_rooms]}")

                ignored_edges = set()

                for _, row in edges_csv.iterrows():
                    rd = row.to_dict()

                    if Floor.objects.filter(name=rd['start_floor']).first() is None:
                        form.add_error(
                            'edges_csv', f"{rd['start_floor']} doesn't exist as a floor")
                        raise Exception()

                    if Floor.objects.filter(name=rd['end_floor']).first() is None:
                        form.add_error(
                            'edges_csv', f"{rd['end_floor']} doesn't exist as a floor")
                        raise Exception()

                    start_floor = Floor.objects.filter(
                        name=rd['start_floor']).first()
                    end_floor = Floor.objects.filter(
                        name=rd['end_floor']).first()

                    if RoomNode.objects.filter(floor=start_floor, name=rd['start_room_name']).first() is None:
                        form.add_error(
                            'edges_csv', f"There is no room on {rd['start_floor']} that is called {rd['start_room_name']}")
                        raise Exception()

                    if RoomNode.objects.filter(floor=end_floor, name=rd['end_room_name']).first() is None:
                        form.add_error(
                            'edges_csv', f"There is no room on {rd['end_floor']} that is called {rd['end_room_name']}")
                        raise Exception()

                    start_room = RoomNode.objects.filter(
                        floor=start_floor, name=rd['start_room_name']).first()
                    end_room = RoomNode.objects.filter(
                        floor=end_floor, name=rd['end_room_name']).first()

                    room_edges = RoomEdge.objects.filter(
                        nodes=start_room).filter(nodes=end_room)

                    if not room_edges.exists():
                        room_edge = RoomEdge.objects.create()
                        room_edge.nodes.add(start_room, end_room)
                    else:
                        ignored_edges.add(
                            f"{rd['start_floor']} {rd['start_room_name']} → {rd['end_floor']} {rd['end_room_name']}")

                if len(ignored_rooms) != 0:
                    form.add_error(
                        None, f"The following edge entries are skipped because they already exist in the database: {[s for s in ignored_edges]}")

                # Otherwise a success!
                context = {'form': form,
                           'success_message': 'Successfully added!'}
                return render(request, 'create_floorlayout.html', context)

            except Exception as e:
                # Handle other exceptions
                print(e)
                form.add_error(
                    None, "An error has occurred. Please check your files over.")
        else:
            # Form validation errors
            pass
    else:
        form = UploadRoomCSVForm()

    return render(request, 'create_rooms.html', {'form': form})


def affine_transform(affine_matrix, pos):
    return np.dot(affine_matrix, pos)[:2]


class RoomNodeView(generics.ListAPIView):
    queryset = RoomNode.objects.all()
    serializer_class = RoomNodeSerializer


class RoomEdgeView(generics.ListAPIView):
    queryset = RoomEdge.objects.all()
    serializer_class = RoomEdgeSerializer


class BuildingView(generics.ListAPIView):
    queryset = Building.objects.all()
    serializer_class = BuildingSerializer


class FloorView(generics.ListAPIView):
    queryset = Floor.objects.all()
    serializer_class = FloorSerializer


class FloorLayoutView(generics.ListAPIView):
    queryset = FloorLayout.objects.all()
    serializer_class = FloorLayoutSerializer


def history_latest_change(request):
    watched_models = [RoomNode, RoomEdge, Building, Floor, FloorLayout]
    results = []

    for m in watched_models:
        try:
            results.append(m.history.latest('history_date').history_date)
        except Exception:
            pass # if there's no entry, we don't bother
    
    return JsonResponse({
        'date': str(max(results)),
    })
    

@api_view(['POST'])
def create_alert(request):
    if Alert.objects.filter(is_active=True).exists():
        return Response({"error": "An active alert already exists."}, status=status.HTTP_400_BAD_REQUEST)
    
    serializer = AlertSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['PUT'])
def update_alert(request, pk):
    try:
        alert = Alert.objects.get(pk=pk)
    except Alert.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    serializer = AlertSerializer(alert, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
def check_active_alert(request):
    if Alert.objects.filter(is_active=True).exists():
        return Response({"active_alert": True})
    return Response({"active_alert": False})


@api_view(['PUT'])
def turn_off_alert(request):
    if Alert.objects.filter(is_active=True).exists():
        alert = Alert.objects.filter(is_active=True).first()
        alert.is_active = False
        alert.save()
        return Response({"message": "Alert turned off successfully"})
    return Response({"error": "No active alert found."}, status=status.HTTP_400_BAD_REQUEST)