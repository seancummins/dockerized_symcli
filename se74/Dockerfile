# Version 0.0.2
FROM centos:centos6
MAINTAINER Sean Cummins "sean.cummins@emc.com"
RUN yum -y update
RUN yum -y install tar hostname glibc.i686 git zsh sudo man
ADD se7400-Linux-i386-ni.tar.gz /tmp
WORKDIR /tmp
RUN ./se7400_install.sh -install -64bit -silent
WORKDIR /
ENV PATH $PATH:/opt/emc/SYMCLI/bin
ENV SYMCLI_OFFLINE 1
