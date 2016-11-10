FROM centos:7
MAINTAINER "daleoooo" <daleoooo.z@gmail.com>

ENV OWNER_NAME dale
ENV OWNER_PASSWORD 00000000

ENV container docker
ENV TERM screen-256color

RUN yum -y update && \
    yum -y install vim tmux zsh git-all sudo rubygems openssh-server passwd wget \
        proctools vnstat ncdu lsof htop ack psmisc redhat-lsb-core && \
    yum clean all

RUN useradd -ms /bin/zsh ${OWNER_NAME} && usermod -aG wheel ${OWNER_NAME}

USER ${OWNER_NAME}

ENV SHELL /bin/zsh
ENV EDITOR vim

RUN cd ~ && \
    git clone https://github.com/daleoooo/linux-common-config.git .common-config && \
    /bin/zsh ~/.common-config/setup.sh

RUN mkdir ~/Workspace

USER root

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
RUN chmod 755 /usr/local/bin/dumb-init

ADD ./ssh-init.sh /ssh-init.sh
RUN chmod 755 /ssh-init.sh

RUN mkdir /var/run/sshd

RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' && \
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N '' && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''

RUN ./ssh-init.sh

ADD ./init.sh /init.sh
RUN chmod 755 /init.sh

EXPOSE 22
ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["/init.sh"]
