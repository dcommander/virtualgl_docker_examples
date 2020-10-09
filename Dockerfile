FROM nvidia/opengl:1.0-glvnd-runtime-centos7

ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES},graphics,compat32

RUN groupadd -g 1000 docker \
 && useradd -u 1000 -g 1000 -m docker \
 && usermod -a -G docker docker

RUN yum -y install epel-release.noarch \
 && yum -y install \
    git \
    glx-utils \
    mesa-dri-drivers.x86_64 \
    mesa-dri-drivers.i686 \
    xorg-x11-utils \
    xorg-x11-xauth \
    yum-utils \
    https://s3.amazonaws.com/virtualgl-pr/dev/linux/VirtualGL-2.6.80.x86_64.rpm \
    https://s3.amazonaws.com/virtualgl-pr/dev/linux/VirtualGL-2.6.80.i386.rpm \
    https://s3.amazonaws.com/turbovnc-pr/dev/linux/turbovnc-2.2.80.x86_64.rpm \
 && yum -y groupinstall "MATE Desktop" \
 && sed -i 's/^# \$wm =.*/\$wm = \"mate-session\";/g' /etc/turbovncserver.conf \
 && sed -i 's/^# \$noVNC =.*/\$noVNC = \"\/home\/docker\/noVNC\";/g' /etc/turbovncserver.conf \
 && git clone https://github.com/novnc/noVNC.git \
 && mv noVNC /home/docker/ \
 && chown -R 1000:1000 /home/docker/noVNC \
 && yum clean all \
 && rm -rf /etc/ld.so.cache \
 && rm -rf /var/cache/ldconfig/* \
 && rm -rf /tmp/*

USER docker
WORKDIR /home/docker
