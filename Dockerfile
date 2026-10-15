FROM python:3.15.0@sha256:16e7e5fc4e79fe153c818ac9b46595c7addddaad744d49595377836e300ad1c6

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
