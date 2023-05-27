#!/bin/bash
useradd sonar
echo "instalando dependencias"
apt install wget unzip openjdk-11-jdk -y
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.1.0.47736.zip
unzip -o sonarqube-9.1.0.47736.zip -d /opt/
mv /opt/sonarqube-9.1.0.47736 /opt/sonarqube
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

wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.2.2472-linux.zip
unzip -o sonar-scanner-cli-4.6.2.2472-linux.zip -d /opt/
mv /opt/sonar-scanner-cli-4.6.2.2472-linux /opt/sonar-scanner
chown -R sonar:sonar /opt/sonar-scanner
echo 'export PATH=$PATH:/opt/sonar-scanner/bin' | sudo tee -a /etc/profile
cd ~
curl -sL https://deb.nodesource.com/setup_10.x -o /tmp/nodesource_setup.sh
bash /tmp/nodesource_setup.sh
apt install nodejs -y