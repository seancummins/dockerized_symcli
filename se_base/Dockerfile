# Version 0.0.4
FROM opensuse:harlequin
MAINTAINER Sean Cummins "sean.cummins@emc.com"
RUN zypper -n install zsh glibc-32bit tar git sudo man wget libopenssl-devel-32bit python-pip vim strace curl ca-certificates-mozilla
RUN easy_install-3.4 prettytable
#RUN easy_install-2.7 prettytable
RUN mkdir /scripts
WORKDIR /scripts
RUN git clone https://github.com/seancummins/fast_report.git
RUN git clone https://github.com/seancummins/sgcapreport.git
RUN ln -s /scripts/fast_report/fastvp_report.py /usr/bin/fastvp_report.py
RUN ln -s /scripts/sgcapreport/sgcapreport.py /usr/bin/sgcapreport.py
