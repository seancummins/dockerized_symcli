# Version 0.0.1
FROM centos:latest
MAINTAINER Sean Cummins "sean.cummins@emc.com"
RUN yum -y update
RUN yum -y install tar hostname git zsh sudo man
ADD se8020-Linux-x86_64-ni.tar.gz /tmp
WORKDIR /tmp
RUN ./se8020_install.sh -install -silent
WORKDIR /
ENV PATH $PATH:/opt/emc/SYMCLI/bin
ENV SYMCLI_OFFLINE 1
