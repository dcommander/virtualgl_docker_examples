FROM nvidia/opengl:1.0-glvnd-runtime-centos7

ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES},graphics,compat32

RUN yum-config-manager --add-repo https://turbovnc.org/pmwiki/uploads/Downloads/TurboVNC.repo \
 && yum -y install epel-release.noarch \
 && yum -y install \
    glx-utils \
    mesa-dri-drivers.x86_64 \
    mesa-dri-drivers.i686 \
    xorg-x11-utils \
    xorg-x11-xauth \
    yum-utils \
    https://s3.amazonaws.com/virtualgl-pr/dev/linux/VirtualGL-2.6.80.x86_64.rpm \
    https://s3.amazonaws.com/virtualgl-pr/dev/linux/VirtualGL-2.6.80.i386.rpm \
    turbovnc \
 && yum -y groupinstall "MATE Desktop" \
 && sed -i 's/^# \$wm =.*/\$wm = \"mate-session\";/g' /etc/turbovncserver.conf \
 && yum clean all \
 && rm -rf /etc/ld.so.cache \
 && rm -rf /var/cache/ldconfig/* \
 && rm -rf /tmp/*

RUN groupadd -g 1000 docker \
 && useradd -u 1000 -g 1000 -m docker \
 && usermod -a -G docker docker
USER docker
WORKDIR /home/docker
