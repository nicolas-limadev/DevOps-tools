#!/bin/bash
useradd sonar
echo "instalando dependencias"
apt install wget unzip openjdk-11-jdk -y
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.0.0.68432.zip
unzip sonarqube-10.0.0.68432.zip -d /opt/
mv /opt/sonarqube-10.0.0.68432 /opt/sonarqube
chown -R sonar:sonar /opt/sonarqube
touch /etc/systemd/system/sonar.service
echo > /etc/systemd/system/sonar.service
cat <<EOT >> /etc/systemd/system/sonar.service
[Unit]
Description=SonarQube service
After=syslog.target network.target
[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonar
Group=sonar
Restart=always
[Install]
WantedBy=multi-user.target
EOT
systemctl daemon-reload
service sonar start