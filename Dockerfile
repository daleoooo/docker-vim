FROM centos:7
MAINTAINER "daleoooo" <daleoooo.z@gmail.com>

ENV container docker
ENV TERM screen-256color

RUN yum -y update && yum -y install vim tmux zsh git-all sudo rubygems && yum clean all

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service  ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup"  ]

RUN useradd -ms /bin/bash dale && passwd -d dale && usermod -aG wheel dale
USER dale
CMD /bin/zsh

RUN cd ~ && git clone https://github.com/daleoooo/dale-config.git .dale-config && \
    cd .dale-config && git checkout linux && /bin/zsh ~/.dale-config/setup.sh
