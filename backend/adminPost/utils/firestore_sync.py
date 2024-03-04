from google.cloud import firestore
from .models import BlogPost

# Initialize Firestore client
firestore_client = firestore.Client()

def sync_blog_posts_to_firestore():
    # Query Django BlogPost model
    blog_posts = BlogPost.objects.all()

    # Iterate over BlogPost instances and write data to Firestore
    for blog_post in blog_posts:
        # Construct Firestore document data
        doc_data = {
            'title': blog_post.title,
            'content': blog_post.content,
            'report': blog_post.report,
            'floor': blog_post.floor,
            'photo': blog_post.photo.url if blog_post.photo else None,
            # Add other fields as needed
        }

        # Write data to Firestore
        doc_ref = firestore_client.collection('blog_posts').add(doc_data)
        print('Document written with ID:', doc_ref.id)
