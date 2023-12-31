# Generated by Django 4.2.2 on 2023-07-09 13:06

from django.db import migrations
import csv

def data_load(apps, schema_editor):
    Crime = apps.get_model("playground", "Crime")
    # Report = apps.get_model("playground", "Report")
    # Location = apps.get_model("playground", "location")
    # Coordinate = apps.get_model("playground", "Coordinate")

    with open('./playground/migrations/crimes.csv') as csv_file:
        reader = csv.reader(csv_file)
        header = next(reader)

        crimes = []

        for row in reader:
            crime = Crime(Type=row[0],Description=row[1])
            crimes.append(crime)

        # Report_number=row[0], Date = row[1], Status=row[2], Emergency=row[3], Location=row[4], Crime=row[5]

        Crime.objects.bulk_create(crimes)

class Migration(migrations.Migration):

    dependencies = [
        ("playground", "0005_remove_coordinate_floor_location_floor"),
    ]

    operations = [migrations.RunPython(data_load)]
