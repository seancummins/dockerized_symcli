# Version 0.0.2
FROM centos:centos6
MAINTAINER Sean Cummins "sean.cummins@emc.com"
RUN yum -y update
RUN yum -y install tar hostname git zsh sudo man
ADD se8030-Linux-x86_64-ni.tar.gz /tmp
WORKDIR /tmp
RUN ./se8030_install.sh -install -silent
WORKDIR /
ENV PATH $PATH:/opt/emc/SYMCLI/bin
ENV SYMCLI_OFFLINE 1
