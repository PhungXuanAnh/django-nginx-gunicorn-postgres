# start from an official image
FROM python:3.6

# arbitrary location choice: you can change the directory
RUN mkdir -p /deploy/django-nginx-gunicorn-postgres/
WORKDIR /deploy/django-nginx-gunicorn-postgres/

# copy our project code
COPY . /deploy/django-nginx-gunicorn-postgres/

# install our two dependencies
RUN pip install -r requirement.txt

# expose the port 8000
# EXPOSE 8000

# define the default command to run when starting the container
CMD ["python", "manage.py", "runserver", "0.0.0.0:8001"]