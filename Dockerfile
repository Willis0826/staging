FROM python:3.11-alpine

ARG GUNICORN_WORKERS=2
ENV GUNICORN_WORKERS=$GUNICORN_WORKERS

ARG GUNICORN_PORT=8000
ENV GUNICORN_PORT=$GUNICORN_PORT

ARG GUNICORN_RELOAD=False
ENV GUNICORN_RELOAD=$GUNICORN_RELOAD

ARG GUNICORN_PRELOAD_APP=True
ENV GUNICORN_PRELOAD_APP=$GUNICORN_PRELOAD_APP

WORKDIR /usr/src/staging

# install packages first, to prevent image rebuild takes longer.
COPY requirements.txt ./requirements.txt

RUN pip install --no-cache-dir -r ./requirements.txt

COPY . ./

EXPOSE 8000

# prevent using CMD [ "sh", "-c" ... ] can help graceful shutdown in some cases.
ENTRYPOINT [ "gunicorn" ]
CMD [ "--config=gunicorn.conf.py", "main:server" ]
