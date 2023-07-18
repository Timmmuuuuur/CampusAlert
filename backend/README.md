# CampusAlert backend

## Set up
Pip requirement packages:
```
Django
django-debug-toolbar
django-rest-framework
firebase_admin
fcm-django
djangorestframework-jwt
```

NOTE: there is a risk that installing firebase_admin can cause damage to the OpenSSL package in Python distro. See here on how to fix it: https://stackoverflow.com/questions/73830524/attributeerror-module-lib-has-no-attribute-x509-v-flag-cb-issuer-check

After that, you need to get the Firebase secret JSON file from the Discord server and put that somewhere on your computer. Then have your environment variable `GOOGLE_APPLICATION_CREDENTIALS` point to it.

If you have Linux, Linux subsystem for Windows, or MacOS, you can do the following to add it to Bash:
```
sudo nano ~/.bashrc
```

Then add this line
```
export GOOGLE_APPLICATION_CREDENTIAL=<path to the JSON file>
```

Make sure to restart your terminal and you are in Bash and not zsh. zsh requires similar steps.

## Running + developing

To start the program, run

```py
python3 manage.py runserver 8080
```

Every time you update the field name or add new fields to a model, you MUST run this before committing!

```py
python3 manage.py makemigrations
python3 manage.py migrate
```
- and accept each rename correctly in the terminal prompts

### Create an admin account



Kevin's admin account:
- username: KevinLeeFM
- password: 123