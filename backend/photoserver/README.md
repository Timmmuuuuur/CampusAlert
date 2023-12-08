
# While in dev,
1. deploy photo server
1.1 pip install django 
1.2 pip install firebase-admin

# You might need to install other dependencies as well
1.3
python manage.py runserver


2. copy photo server end point to ../lib/service/photo_service where noted

3. run photo app

4. cd photoapp
4.1 flutter run

--------

test run and create super user:
1. Run Migrations:
python manage.py makemigrations photoapp
python manage.py migrate

2.Create Superuser (Optional): 
python manage.py createsuperuser
3.python manage.py runserver
