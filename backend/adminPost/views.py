from django.shortcuts import render

# Create your views here.
# adminPost/views.py
from django.shortcuts import render
from django.views.generic import ListView, DetailView, CreateView
from .models import BlogPost
from .forms import BlogPostForm # user submit post, criteria form
from django.views.generic import TemplateView
from django.urls import reverse_lazy




class AdminPostHomePageView(ListView):
    model = BlogPost
    template_name = 'adminPost/home_page.html'
    context_object_name = 'posts'  # for Html template: This is the variable used in the template for the list of posts. 


class BlogPostListView(ListView): #retrieves a specific post
    model = BlogPost
    template_name = 'adminPost/blogpost_list.html'
    context_object_name = 'posts'

class BlogPostDetailView(DetailView):
    model = BlogPost
    template_name = 'adminPost/blogpost_detail.html'
    context_object_name = 'post'

class BlogPostCreateView(CreateView):
    template_name = 'adminPost/blogpost_form.html'
    model = BlogPost
    form_class = BlogPostForm
    success_url = reverse_lazy('adminPost_home')

    def form_valid(self, form):
        # Handle file upload manually
        photo = self.request.FILES.get('photo')
        if photo:
            form.instance.photo = photo

        # Process the form data
        # Save the form or perform other actions
        return super().form_valid(form)

    def get(self, request, *args, **kwargs):
        form = BlogPostForm()
        return render(request, self.template_name, {'form': form})

    def post(self, request, *args, **kwargs):
        form = BlogPostForm(request.POST, request.FILES)
        if form.is_valid():
            return super().form_valid(form)
        else:
            return self.form_invalid(form)