FROM phusion/baseimage
MAINTAINER Stuart Wade <stewbawka@gmail.com>

RUN apt-get update -qq && apt-get install -qqy curl

RUN apt-get update -qq && apt-get install -qqy iptables ca-certificates lxc openjdk-6-jdk git-core

ENV JENKINS_HOME /opt/jenkins/data
ENV JENKINS_MIRROR http://mirrors.jenkins-ci.org

RUN mkdir -p $JENKINS_HOME/plugins
RUN curl -sf -o /opt/jenkins/jenkins.war -L $JENKINS_MIRROR/war-stable/latest/jenkins.war

RUN for plugin in chucknorris greenballs scm-api git-client git ws-cleanup ;\
  do curl -sf -o $JENKINS_HOME/plugins/${plugin}.hpi \
    -L $JENKINS_MIRROR/plugins/${plugin}/latest/${plugin}.hpi ; done

ADD ./dockerjenkins.sh /usr/local/bin/dockerjenkins.sh
ADD ./backupjenkins.sh /usr/local/bin/backupjenkins.sh
RUN chmod +x /usr/local/bin/dockerjenkins.sh
RUN chmod +x /usr/local/bin/backupjenkins.sh

RUN crontab -l | { cat; echo "30 2 * * * /user/local/bin/backupjenkins.sh"; } | crontab -

RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
RUN apt-get install -qqy unzip
RUN unzip awscli-bundle.zip
RUN ./awscli-bundle/install -b ~/bin/aws

EXPOSE 8080

CMD [ "usr/local/bin/dockerjenkins.sh" ]

