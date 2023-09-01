#!/bin/bash

# Set the Jenkins master's SSH public key for authentication and create the necessary user and permissions
JENKINS_MASTER_SSH_KEY="JENKINS_MASTER_SSH_PUBLIC_KEY" #to be replaced with your public key
yum install -y openssh-server java-11-openjdk
systemctl start sshd
systemctl enable sshd
useradd -m -s /bin/bash jenkins
passwd jenkins
echo "jenkins ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

mkdir -p /home/jenkins/.ssh
echo "$JENKINS_MASTER_SSH_KEY" | sudo tee -a /home/jenkins/.ssh/authorized_keys
chown -R jenkins:jenkins /home/jenkins/.ssh
chmod -R 700 /home/jenkins/.ssh

# Install Jenkins agent software (adjust URL and agent name).
wget wget https://YOUR_JENKINS_MASTER_URL/jnlpJars/agent.jar -O /home/jenkins/agent.jar


# Start the Jenkins agent as a background process.
sudo -u jenkins nohup java -jar agent.jar -jnlpUrl https://JENKINS_MASTER_URL/computer/AGENT_NAME/slave-agent.jnlp -secret AGENT_SECRET &

yum update -y
yum install docker -y
systemctl enable docker.service
usermod -aG docker jenkins
systemctl start docker