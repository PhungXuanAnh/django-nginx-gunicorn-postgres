#!/bin/sh
gunicorn --chdir django-nginx-gunicorn-postgres --bind :8001 django-nginx-gunicorn-postgres.wsgi:application
