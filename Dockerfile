FROM centos:7

ENV GERRIT_HOME /opt/gerrit
ENV GERRIT_SITE ${GERRIT_HOME}/site_path
ENV GERRIT_WAR ${GERRIT_SITE}/gerrit.war
ENV GERRIT_VERSION 2.11.5
ENV GERRIT_USER gerrit2
ENV GERRIT_URL https://gerrit-releases.storage.googleapis.com/gerrit-${GERRIT_VERSION}.war 

RUN yum -y install epel-release
RUN yum -y install \
        sudo vim java-1.7.0-openjdk \
        git python-pip unzip net-tools

# supervisord
RUN yum -y install supervisor

RUN yum clean -y all

# To avoid error: sudo: sorry, you must have a tty to run sudo
RUN sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers

RUN mkdir -p $GERRIT_SITE
RUN curl -L $GERRIT_URL -o $GERRIT_WAR
RUN useradd -d "$GERRIT_HOME" -U -s /bin/bash $GERRIT_USER
RUN chown -R ${GERRIT_USER}:${GERRIT_USER} $GERRIT_HOME

# add configurations and other files
COPY files/start.sh /start.sh
RUN chmod +x /start.sh
COPY files/supervisord.conf /etc/supervisord.conf

# run as gerrit user
VOLUME $GERRIT_SITE

EXPOSE 8080 29418

CMD ["/start.sh"]
