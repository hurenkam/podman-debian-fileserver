FROM ghcr.io/hurenkam/debian-cockpit:bookworm
MAINTAINER Mark Hurenkamp <mark.hurenkamp@xs4all>

# install fileserver related packages
# avahi / wsdd / nfs / samba
RUN apt-get update && apt-get install -y \
	avahi-daemon \
	avahi-utils \
	libnfs-utils \
	nfs-kernel-server \
	wsdd \
	samba 

RUN apt-get install -y \
	curl wget git make

RUN curl -sSL https://repo.45drives.com/setup | sudo bash

RUN apt-get install -y \
    cockpit-file-sharing

# clean-up
RUN apt-get remove -y git make && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
    /var/log/alternatives.log \
    /var/log/apt/history.log \
    /var/log/apt/term.log \
    /var/log/dpkg.log

# copy overlay directories
COPY etc/ /etc/



# Build final image.
# Create an image without the deleted files in the intermediate layers.

FROM ghcr.io/hurenkam/debian-cockpit:bookworm
COPY --from=0 / /


# expose ssh port
EXPOSE 22

# expose samba ports
EXPOSE 445 137/udp 138/udp

# expose afp port
EXPOSE 548

# expose nfs ports
EXPOSE 111 2049 32765 32766 32767 32768

# expose cockpit port
EXPOSE 9090


# configure systemd
ENV container docker
STOPSIGNAL SIGRTMIN+3


VOLUME ["/sys/fs/cgroup"] 

CMD [ "/sbin/init" ]


# TODO:
# - set root password

