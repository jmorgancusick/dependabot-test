FROM python:3.13.4@sha256:eb120d016adcbc8bac194e15826bbb4f1d1569d298d8817bb5049ed5e59f41d9

ARG DJANGO_UID=1000
ARG DJANGO_GID=1000
ARG PIPENV_DEV=false

ENV PIPENV_DEV=$PIPENV_DEV

RUN pip3 install pipenv

RUN groupadd -g "$DJANGO_GID" django
RUN useradd -m -s /bin/bash -u "$DJANGO_UID" -g "$DJANGO_GID" django

# wont be created by root, since already exists
WORKDIR /home/django

USER django

COPY --chown=django:django . .

RUN pipenv install

ENV PYTHONPATH "${PYTHONPATH}:/home/django"

CMD ["pipenv", "run", "python3", "manage.py", "runserver", "0.0.0.0:8000"]
