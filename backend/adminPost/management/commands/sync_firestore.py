# your_django_app/management/commands/sync_firestore.py

from django.core.management.base import BaseCommand
from your_django_app.utils.firestore_sync import sync_blog_posts_to_firestore

class Command(BaseCommand):
    help = 'Synchronize BlogPost data to Firestore'

    def handle(self, *args, **options):
        sync_blog_posts_to_firestore()

