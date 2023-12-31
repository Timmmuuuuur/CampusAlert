# Generated by Django 3.2.20 on 2023-11-02 01:57

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Building',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255, unique=True)),
            ],
        ),
        migrations.CreateModel(
            name='Coordinate',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('longitude', models.FloatField(max_length=7)),
                ('latitude', models.FloatField(max_length=7)),
            ],
        ),
        migrations.CreateModel(
            name='Crime',
            fields=[
                ('kind', models.CharField(max_length=20, primary_key=True, serialize=False)),
                ('description', models.CharField(max_length=200)),
            ],
        ),
        migrations.CreateModel(
            name='Floor',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('floor_number', models.IntegerField(unique=True)),
                ('name', models.TextField(unique=True)),
                ('bottomleft', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='bottomleft', to='emergency.coordinate')),
                ('building', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='building', to='emergency.building')),
            ],
        ),
        migrations.CreateModel(
            name='FloorLayout',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.TextField(unique=True)),
                ('layout_image', models.ImageField(blank=True, null=True, upload_to='layout_images/')),
            ],
        ),
        migrations.CreateModel(
            name='Location',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('campus', models.CharField(max_length=25)),
                ('building', models.CharField(max_length=25)),
                ('room', models.CharField(max_length=7)),
                ('floor', models.IntegerField(default=0)),
                ('coordinate', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='emergency.coordinate')),
            ],
        ),
        migrations.CreateModel(
            name='RoomNode',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255)),
                ('x', models.FloatField()),
                ('y', models.FloatField()),
                ('is_exit', models.BooleanField()),
                ('floor', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='floor', to='emergency.floor')),
            ],
            options={
                'unique_together': {('floor', 'name')},
            },
        ),
        migrations.CreateModel(
            name='RoomEdge',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nodes', models.ManyToManyField(related_name='nodes', to='emergency.RoomNode')),
            ],
        ),
        migrations.CreateModel(
            name='Report',
            fields=[
                ('report_number', models.IntegerField(primary_key=True, serialize=False)),
                ('date', models.DateTimeField(auto_now=True)),
                ('status', models.CharField(max_length=20)),
                ('emergency', models.BooleanField()),
                ('crime', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='emergency.crime')),
                ('location', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='emergency.location')),
            ],
        ),
        migrations.AddField(
            model_name='floor',
            name='layout',
            field=models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='layout', to='emergency.floorlayout'),
        ),
        migrations.AddField(
            model_name='floor',
            name='topleft',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='topleft', to='emergency.coordinate'),
        ),
        migrations.AddField(
            model_name='floor',
            name='topright',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='topright', to='emergency.coordinate'),
        ),
        migrations.AlterUniqueTogether(
            name='floor',
            unique_together={('building', 'floor_number')},
        ),
    ]
