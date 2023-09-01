#!/bin/bash

#installing docker
yum update -y
yum install docker -y
systemctl enable docker.service
usermod -aG docker jenkins
systemctl start docker

#installing jenkins
dnf install java-11-amazon-corretto -y
wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum upgrade
yum install jenkins -y
systemctl enable jenkins
systemctl start jenkins


