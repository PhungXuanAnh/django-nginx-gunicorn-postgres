# start from an official image
FROM python:3.6

# arbitrary location choice: you can change the directory
RUN mkdir -p /deploy/django-nginx-gunicorn-postgres/
WORKDIR /deploy/django-nginx-gunicorn-postgres/

# copy our project code
COPY . /deploy/django-nginx-gunicorn-postgres/

# install our two dependencies
RUN pip install -r requirement.txt

RUN python manage.py collectstatic --no-input

# define the default command to run when starting the container
CMD ["gunicorn", "--chdir", "django-nginx-gunicorn-postgres", "--bind", ":8001", "django-nginx-gunicorn-postgres.wsgi:application"]