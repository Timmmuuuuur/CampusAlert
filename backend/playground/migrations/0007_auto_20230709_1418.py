# Generated by Django 4.2.2 on 2023-07-09 14:18

from django.db import migrations
import csv

def data_load(apps, schema_editor):
    # Crime = apps.get_model("playground", "Crime")
    Report = apps.get_model("playground", "Report")
    Location = apps.get_model("playground", "location")
    Coordinate = apps.get_model("playground", "Coordinate")

    with open('/Users/jankostrizak/Documents/fydp/foo/storefront/playground/migrations/coordinates.csv') as csv_file:
        reader = csv.reader(csv_file)
        header = next(reader)

        coordinates = []

        for row in reader:
            coordinate = Coordinate(id=row[0], Longitude=row[1], Latitude=row[2])
            coordinates.append(coordinate)


        Coordinate.objects.bulk_create(coordinates)
    
    with open('/Users/jankostrizak/Documents/fydp/foo/storefront/playground/migrations/locations.csv') as csv_file:
        reader = csv.reader(csv_file)
        header = next(reader)

        locations = []

        for row in reader:
            location = Location(id=row[0], Campus=row[1], Building=row[2], Room=row[3], Floor=row[4], Coordinate_id=row[5])
            locations.append(location)


        Location.objects.bulk_create(locations)
    
    with open('/Users/jankostrizak/Documents/fydp/foo/storefront/playground/migrations/reports.csv') as csv_file:
        reader = csv.reader(csv_file)
        header = next(reader)

        reports = []

        for row in reader:
            report = Report(Report_number=row[0], Date=row[1], Status=row[2], Emergency=row[3], Crime_id=row[4], Location_id=row[5])
            reports.append(report)


        Report.objects.bulk_create(reports)

class Migration(migrations.Migration):

    dependencies = [
        ("playground", "0006_auto_20230709_1306"),
    ]

    operations = [migrations.RunPython(data_load)]
