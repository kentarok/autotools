# docker build -t autotools .
# docker run -d -it -v $(pwd):/autotools --name autotools autotools
# docker exec -it autotools /bin/bash
FROM centos:7

RUN set -x && \
    yum install -y epel-release && \
    yum install -y openssh-clients sshpass which less jq tree gcc make

RUN set -x && \
    yum install -y https://centos7.iuscommunity.org/ius-release.rpm && \
    yum install -y python36u python36u-libs python36u-devel python36u-pip  && \
    pip3 install ansible ansible-lint

RUN set -v && \
    rpm -ivh https://packages.chef.io/files/stable/inspec/4.18.24/el/7/inspec-4.18.24-1.el7.x86_64.rpm && \
    export PATH=/opt/inspec/embedded/bin/:$PATH && \
    gem install serverspec rake highline rubocop

ENV ANSIBLE_CONFIG=/autotools/ansible/ansible.cfg
ENV PATH=/opt/inspec/embedded/bin/:$PATH

