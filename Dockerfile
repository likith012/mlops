FROM ubuntu:22.04

LABEL maintainer="Likith Reddy"

# Anaconda 
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

# Prevent docker build get stopped by requesting user interaction
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

# Python byte-code
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Encoding
ENV PYTHONIOENCODING=UTF-8
ENV LANG=C.UTF-8 
ENV LC_ALL=C.UTF-8

# Framework
ARG PYTHON=python 
ARG PYTHON_PIP=python-pip
ARG PIP=pip
ARG PYTHON_VERSION=3.9
ARG CONDA_ENV=mlops

WORKDIR /root

# Linux dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    nano \
    openssh-client \
    openssh-server \
    rsync \
    unzip \
    wget \
    nginx \
    gunicorn \
    supervisor

# Conda install
RUN cd /root \
    && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && sh Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 

RUN /bin/bash -c "source /root/.bashrc \
    && conda create -y -n ${CONDA_ENV} ${PYTHON}=${PYTHON_VERSION}"

RUN conda init bash

RUN echo 'conda activate mlops' >> ~/.bashrc

COPY requirements.txt .

RUN /bin/bash -c "source ~/.bashrc \
    && source activate ${CONDA_ENV} \
    && ${PIP} install -r requirements.txt"

COPY . ${CONDA_ENV}

# Setup nginx
RUN rm /etc/nginx/sites-enabled/default
COPY flask.conf /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/flask.conf /etc/nginx/sites-enabled/flask.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Setup supervisord
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY gunicorn.conf /etc/supervisor/conf.d/gunicorn.conf

# RUN chmod +x /usr/local/bin/deep_learning_container.py

CMD ["/usr/bin/supervisord"]