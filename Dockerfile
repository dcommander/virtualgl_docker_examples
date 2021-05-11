FROM nvidia/opengl:1.0-glvnd-runtime-ubuntu20.04

ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES},graphics,compat32

RUN groupadd -g 1000 docker \
 && useradd -u 1000 -g 1000 -m docker -s /bin/bash \
 && usermod -a -G docker docker

COPY opt /opt
RUN chmod 755 /opt \
 && chmod 755 /opt/slicer \
 && chmod 644 /opt/slicer/*
COPY usr/local /usr/local
RUN chmod 755 /usr/local \
 && chmod 755 /usr/local/shared \
 && chmod 755 /usr/local/shared/backgrounds \
 && chmod 644 /usr/local/shared/backgrounds/*
COPY usr/share/applications /usr/share/applications
RUN chmod 755 /usr/share/applications \
 && chmod 644 /usr/share/applications/*

RUN apt -y update \
 && apt -y upgrade \
 && ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime \
 && apt -y install \
    dbus-x11 \
    emacs-nox \
    firefox \
    libegl1-mesa \
    libglu1-mesa \
    libnss3 \
    libpulse-mainloop-glib0 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render0 \
    libxcb-render-util0 \
    libxcb-xinerama0 \
    libxcb-xkb1 \
    libxkbcommon-x11-0 \
    libxtst6 \
    libxv1 \
    mate-terminal \
    openbox-menu \
    openssh-client \
    tint2 \
    vim-common \
    wget \
    x11-utils \
    x11-xserver-utils \
    xauth \
 && wget https://s3.amazonaws.com/virtualgl-pr/dev/linux/virtualgl_2.6.80_amd64.deb \
 && dpkg -i virtualgl*.deb \
 && rm *.deb \
 && apt install -f \
 && echo 'tint2 &' >>/etc/xdg/openbox/autostart \
 && wget http://download.slicer.org/bitstream/1338641 -O slicer.tar.gz \
 && tar xzf slicer.tar.gz -C /tmp \
 && mv /tmp/Slicer*/* /opt/slicer/ \
 && rm slicer.tar.gz \
 && apt clean \
 && rm -rf /etc/ld.so.cache \
 && rm -rf /var/cache/ldconfig/* \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* \
 && rm -rf /var/tmp/*

RUN perl -i -p0e 's/  <separator \/>\n  <item label=\"Exit\">\n.*\n  <\/item>\n//s' /etc/xdg/openbox/menu.xml
RUN perl -i -p0e 's/  <item label=\"ObConf\">\n[^\n]*\n  <\/item>\n//s' /etc/xdg/openbox/menu.xml
RUN LNUM=$(sed -n '/launcher_item_app/=' /etc/xdg/tint2/tint2rc | head -1) && \
  sed -i "${LNUM}ilauncher_item_app = /usr/share/applications/slicer-vgl.desktop" /etc/xdg/tint2/tint2rc && \
  sed -i "${LNUM}ilauncher_item_app = /usr/share/applications/slicer.desktop" /etc/xdg/tint2/tint2rc && \
  sed -i "/^launcher_item_app = tint2conf\.desktop$/d" /etc/xdg/tint2/tint2rc

USER docker
WORKDIR /home/docker
