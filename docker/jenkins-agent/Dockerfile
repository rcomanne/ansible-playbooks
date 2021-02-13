FROM jenkins/inbound-agent:latest-jdk11

USER root

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && echo "deb [arch=amd64] https://download.docker.com/linux/debian buster stable" > /etc/apt/sources.list.d/docker.list \
    && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list \
    && apt update \
    && apt upgrade -y \
    && apt autoremove -y \
    && apt install -y git maven docker-ce-cli kubectl \
    && rm -rf /var/lib/apt/lists/*

USER jenkins