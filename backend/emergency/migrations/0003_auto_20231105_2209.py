# Generated by Django 3.2.20 on 2023-11-05 22:09

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('emergency', '0002_historicalbuilding_historicalcrime_historicalfloor_historicalfloorlayout_historicallocation_historic'),
    ]

    operations = [
        migrations.AlterField(
            model_name='floor',
            name='floor_number',
            field=models.IntegerField(),
        ),
        migrations.AlterField(
            model_name='historicalfloor',
            name='floor_number',
            field=models.IntegerField(),
        ),
    ]