FROM ubuntu:10.04

ENV DEBIAN_FRONTEND noninteractive

# Ensure we create the cluster with UTF-8 locale
# Bug: https://bugs.launchpad.net/ubuntu/+source/lxc/+bug/813398
RUN locale-gen en_US.UTF-8 && \
    echo 'LANG="en_US.UTF-8"' > /etc/default/locale

# Set the locale
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US:en
ENV LC_ALL en_US.UTF-8

RUN echo "Europe/Paris" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

RUN echo "deb http://old-releases.ubuntu.com/ubuntu lucid main restricted" > /etc/apt/sources.list; \
 echo "deb http://old-releases.ubuntu.com/ubuntu/ lucid-updates main restricted" >> /etc/apt/sources.list; \
 echo "deb http://old-releases.ubuntu.com/ubuntu/ lucid multiverse" >> /etc/apt/sources.list; \
 echo "deb http://old-releases.ubuntu.com/ubuntu/ lucid-updates multiverse" >> /etc/apt/sources.list; \
 echo "deb http://old-releases.ubuntu.com/ubuntu/ lucid universe" >> /etc/apt/sources.list; \
 echo "deb http://old-releases.ubuntu.com/ubuntu/ lucid-updates universe" >> /etc/apt/sources.list; \
 echo udev hold | dpkg --set-selections; \
 echo initscripts hold | dpkg --set-selections; \
 echo upstart hold | dpkg --set-selections; \
 apt-get update; \
 apt-get upgrade -y
 
RUN apt-get install -y -q postgresql-8.4 libpq-dev

RUN mkdir /etc/ssl/private-copy; mv /etc/ssl/private/* /etc/ssl/private-copy/; rm -r /etc/ssl/private; mv /etc/ssl/private-copy /etc/ssl/private; chmod -R 0700 /etc/ssl/private; chown -R postgres /etc/ssl/private

ADD postgresql.conf /etc/postgresql/8.4/main/postgresql.conf
ADD pg_hba.conf /etc/postgresql/8.4/main/pg_hba.conf
RUN chown postgres:postgres /etc/postgresql/8.4/main/*.conf
ADD init-postgresql /usr/local/bin/init-postgresql
RUN chmod +x /usr/local/bin/init-postgresql

VOLUME ["/var/lib/postgresql"]
EXPOSE 5432

CMD ["/usr/local/bin/init-postgresql"]
