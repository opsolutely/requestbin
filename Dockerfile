FROM python:2.7-onbuild

EXPOSE 8000

CMD [ "gunicorn", "--worker-class", "gevent", "--workers", "2", "--max-requests", "1000", "-b", "0.0.0.0:8000", "requestbin:app"]
