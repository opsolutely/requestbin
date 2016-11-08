FROM ubuntu:14.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update --fix-missing && apt-get install -y \
  build-essential \
  git \
  python \
  python-dev \
  python-setuptools \
  nginx \
  supervisor \
  bcrypt \
  libevent-dev \
  libssl-dev \
  libffi-dev \
  libpq-dev \
  vim \
  rsyslog \
  wget \
  libjpeg-dev \
  libpng-dev
RUN easy_install pip

# stop supervisor service as we'll run it manually
RUN service supervisor stop
RUN mkdir /var/log/gunicorn && mkdir /var/log/deploys
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/default

RUN mkdir /opt/code

# Add service.conf
COPY ./nginx.conf /opt/code/
RUN ln -s /opt/code/nginx.conf /etc/nginx/nginx.conf

# Add supervisor
COPY ./supervisord.conf /opt/code/
RUN ln -s /opt/code/supervisord.conf /etc/supervisor/conf.d/

# Add requirements and install
COPY ./requirements.txt /opt/code/
RUN pip install -r /opt/code/requirements.txt

# Add github repo code to code file
COPY . /opt/code/

WORKDIR /opt/code

# expose port(s)
EXPOSE 80

CMD supervisord -c /etc/supervisor/conf.d/supervisord.conf
