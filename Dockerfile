FROM centos:7
MAINTAINER "daleoooo" <daleoooo.z@gmail.com>

ENV container docker
ENV TERM screen-256color

RUN yum -y update &&\
yum -y install vim tmux zsh git-all sudo rubygems openssh-server passwd &&\
yum clean all

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service  ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup"  ]

RUN useradd -ms /bin/zsh dale && passwd -d dale && usermod -aG wheel dale

ADD ./start.sh /start.sh
RUN mkdir /var/run/sshd

RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' &&\
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N '' &&\
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''

RUN chmod 755 /start.sh
EXPOSE 22
RUN ./start.sh
RUN /usr/sbin/sshd

USER dale
CMD /bin/zsh

ENV SHELL /bin/zsh
ENV EDITOR vim
RUN cd ~ && git clone https://github.com/daleoooo/dale-config.git .dale-config && \
    cd .dale-config && git checkout linux && /bin/zsh ~/.dale-config/setup.sh

RUN mkdir ~/Workspace
