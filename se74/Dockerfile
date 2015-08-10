# Version 0.0.4
FROM seancummins/se_base
MAINTAINER Sean Cummins "sean.cummins@emc.com"
ADD se7400-Linux-i386-ni.tar.gz /tmp
WORKDIR /tmp
RUN ./se7400_install.sh -install -64bit -silent
WORKDIR /
ENV PATH $PATH:/opt/emc/SYMCLI/bin
ENV SYMCLI_OFFLINE 1
