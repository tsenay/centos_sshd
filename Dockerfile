FROM centos:7

LABEL MAINTAINER="Thomas Senay <tomgva@me.com>" ImageVersion="20181220"

ADD entrypoint.sh /usr/bin/entrypoint.sh

RUN ( yum update -y; \
      # Update System and install essential packs
      yum install -y openssh-server initscripts epel-release wget passwd tar unzip yum-utils git;\
      # Install docker-ce \
      yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo \
      yum install -y docker-ce \
      # Configure OpenSSH-Server (Part. 1)
      sed -i 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config; \
      sed -i 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config; \
      sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config; \
      # Configure OpenSSH-Server (Part. 2)
      mkdir -p /root/.ssh/; \
      echo "StrictHostKeyChecking=no" > /root/.ssh/config; \
      echo "UserKnownHostsFile=/dev/null" >> /root/.ssh/config; \
      # Configure SSH Key
      ssh-keygen -A ;\
      # Configure yum repo
      sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/CentOS-Base.repo; \
      # Set the root password
      echo "root:root" | chpasswd ;\
      # Cleaning up images
      yum clean all ;\
      rm -rf /var/cache/yum )

RUN ( cp -f /usr/share/zoneinfo/Europe/Paris /etc/localtime )

EXPOSE 22

# What to do when start the docker image
ENTRYPOINT [ "bash", "/usr/bin/entrypoint.sh" ]
