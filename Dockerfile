FROM python:3.7.0-slim-stretch
LABEL maintainer="appsvc-images@microsoft.com"

# Web Site Home
ENV HOME_SITE "/home/site/wwwroot"

#Install system dependencies
RUN apt-get update --allow-unauthenticated \
    && apt-get install -y --no-install-recommends --allow-unauthenticated \
        libpq-dev \
        openssh-server \
        vim \
        curl \
        wget \
        tcptraceroute \
		python3-dev \
		gcc \
		python3-pip \
		libxml2-dev \
		libxslt1-dev \
		zlib1g-dev \
		g++ \
    && pip install --upgrade pip \
    && pip install subprocess32 \
    && pip install gunicorn \ 
    && pip install virtualenv \
    && pip install flask
	
RUN apt-get install unixodbc-dev -y --allow-unauthenticated
WORKDIR ${HOME_SITE}

EXPOSE 8000
# setup SSH
RUN mkdir -p /home/LogFiles \
     && echo "root:Docker!" | chpasswd \
     && echo "cd /home" >> /etc/bash.bashrc 

COPY sshd_config /etc/ssh/
RUN mkdir -p /opt/startup
COPY init_container.sh /opt/startup/init_container.sh

# setup default site
RUN mkdir /opt/defaultsite
COPY hostingstart.html /opt/defaultsite
COPY application.py /opt/defaultsite
COPY requirements.txt /home/site/wwwroot

RUN pip install -r requirements.txt

# configure startup
RUN chmod -R 777 /opt/startup
COPY entrypoint.py /usr/local/bin

ENTRYPOINT ["/opt/startup/init_container.sh"]
