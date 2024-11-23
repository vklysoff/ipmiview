FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0.0

ADD IPMIView_2.21.0_build.221118_bundleJRE_Linux_x64.tar.gz /opt/
RUN mv /opt/IPMIView_2.21.0_build.221118_bundleJRE_Linux_x64 /opt/IPMIView
ADD *.so /opt/IPMIView/

#RUN add-apt-repository ppa:no1wantdthisname/ppa
#RUN add-apt-repository ppa:no1wantdthisname/openjdk-fontfix
RUN apt-get update
RUN apt-get dist-upgrade -y --no-install-recommends
RUN apt-get install -y --no-install-recommends \
	software-properties-common \
	xvfb \
	x11vnc \
	supervisor \
	fluxbox \
#	fontconfig-infinality \
	libfreetype6 \
	fontconfig \
	fonts-dejavu \
	git
RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC
RUN git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify

RUN apt-get remove --purge -y git && \
	apt-get autoremove -y && \
	apt-get clean && \
	rm -rf /build && \
	rm -rf /tmp/* /var/tmp/* && \
	rm -rf /var/lib/apt/lists/*
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080

CMD ["/usr/bin/supervisord"]
