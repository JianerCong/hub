# syntax=docker/dockerfile:1

FROM python:latest

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY . .
RUN python3 manage.py migrate
CMD [ "python3", "manage.py", "runserver", "0.0.0.0:9002"]
