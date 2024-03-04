# Generated by Django 3.2.20 on 2024-02-24 23:22

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('emergency', '0004_auto_20240126_2257'),
        ('adminPost', '0003_auto_20240224_1737'),
    ]

    operations = [
        migrations.AddField(
            model_name='blogpost',
            name='report',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='blog_posts', to='emergency.report'),
        ),
    ]
