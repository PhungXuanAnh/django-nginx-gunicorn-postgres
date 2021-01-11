# start from an official image
FROM python:3.8.0

RUN apt-get update -qq

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y supervisor

# arbitrary location choice: you can change the directory
RUN mkdir -p /deploy/django-nginx-gunicorn-postgres/
WORKDIR /deploy/django-nginx-gunicorn-postgres/

# copy our project code
COPY . /deploy/django-nginx-gunicorn-postgres/

# install our two dependencies
RUN pip install -r requirements.txt

RUN python manage.py collectstatic --no-input

# define the default command to run when starting the container
CMD ["/usr/bin/supervisord", "-n"]
