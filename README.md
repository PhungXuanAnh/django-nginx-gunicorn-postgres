# Overview

The **master** branch of this project for reusable as production, [see this link](https://phungxuananh.github.io/devops-ci-cd-tools/django-nginx-gunicorn-postgres/) to know how to create this project

# Step to run this project

1.  Add docker-env file

```shell
mkdir -p config/app
touch config/app/docker-env
```

Add to file **config/app/docker-env**:

```conf
SLACK_API_KEY="your-api-key"
SLACK_USERNAME="django-nginx-gunicorn-postgres"
```

2.  Build, run and migrate database

```shell
docker-compose build
docker-compose up -d
docker-compose run --rm django-nginx-gunicorn-postgres /bin/bash -c "python manage.py migrate"
```

Access link: [http://0.0.0.0:81/admin/](http://0.0.0.0:81/admin/) to test
