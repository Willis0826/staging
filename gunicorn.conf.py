import os

# https://docs.gunicorn.org/en/stable/settings.html#settings

bind = f"0.0.0.0:{os.environ.get('GUNICORN_PORT')}"
workers = os.environ.get('GUNICORN_WORKERS')
reload = os.environ.get('GUNICORN_RELOAD') == 'True'
preload_app = os.environ.get('GUNICORN_PRELOAD_APP') == 'True'