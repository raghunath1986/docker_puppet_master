FROM centos:latest
MAINTAINER DevOpsEngineer
######### ENVIRONMENT VARIABLES ##############
ENV container docker

#ENV http_proxy=http://proxy.proxysherwin.com:39000/

######### SYSTEMD & SYSTEMCTL ##################
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done);

RUN rm -f /lib/systemd/system/multi-user.target.wants/* && rm -f /etc/systemd/system/*.wants/* && rm -f /lib/systemd/system/local-fs.target.wants/* && rm -f /lib/systemd/system/sockets.target.wants/*udev* && rm -f /lib/systemd/system/sockets.target.wants/*initctl* && rm -f /lib/systemd/system/basic.target.wants/* && rm -f /lib/systemd/system/anaconda.target.wants/*
VOLUME [ "/sys/fs/cgroup" ]


############# SUDO , TELNET, WHICH PACKAGES #######################
RUN dnf install -y sudo && dnf install -y telnet && dnf install -y which

############# PUPPET REPO, PUPPET SERVER INSTALL ##################
RUN dnf install -y http://yum.puppetlabs.com/puppet-release-el-8.noarch.rpm && dnf install -y puppetserver && dnf install -y pdk && yum install -y git && yum install -y gem 

ENV http_proxy=http://proxy.proxysherwin.com:39000/

RUN gem install r10k 

############ COPY PUPPET CONF FILE ##################
COPY puppet.conf /etc/puppetlabs/puppet/puppet.conf 

############ COPY r10k.yaml #################
COPY r10k.yaml /etc/puppetlabs/r10k/r10k.yaml

############ ZSCALER CERT #########################
#ADD http://swroot.sherwin.com/swroot.pem /etc/pki/ca-trust/source/anchors/swroot.crt

# Update the certificates
#RUN update-ca-trust && echo "Run more commands as root here to save layers" && curl -o /dev/null http://www.google.com


CMD ["/usr/sbin/init"]

#docker run -it --name ppmaster --add-host=puppetmaster:172.17.0.2 --add-host=puppet:172.17.0.2 --privileged=true -v /sys/fs/cgroup:/sys/fs/cgroup:ro -d centos/puppetmaster

