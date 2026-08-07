FROM python:3.14.7@sha256:b5998102f95c4b44edf1e7cb5cecbe1f49e0bf054f345c1db5b854e166e6e17a

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
