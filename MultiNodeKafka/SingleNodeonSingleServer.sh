#!/bin/bash

# Installing Apache Kafka and Zookeeper on Ubuntu 20.04 {Single Node Deployment}
## System Specification ##
# 4vCPU and 4GB RAM running Oracle Virtual Box 6.1 with Extensions
## System Informaiton ##
# DISTRIB_ID=Ubuntu
# DISTRIB_RELEASE=20.04
# DISTRIB_CODENAME=focal
# DISTRIB_DESCRIPTION="Ubuntu 20.04.3 LTS"
## Kernel Informaiton ##

### --- Prerequisites --- ###
### Update the System, Install Java and Set Java Env. Variable
#sudo apt update && sudo apt -y upgrade && sudo apt -y autoremove && sudo apt autoclean && sudo apt clean &&
#sudo apt install -y default-jre &&
#sudo apt install -y default-jdk \
#sudo printf JAVA_HOME='"/usr/lib/jvm/java-11-openjdk-amd64"' >> /etc/environment && source /etc/environment &&
#printf "The Java Env. Variable is set to $JAVA_HOME\n"

### --- IMPORTANT --- ###
### Create user for kafka and run the below Script from that user {sudo ./ScriptName}
#sudo adduser {UsernameforKafka}
#sudo adduser kafka sudo
#su -l kafka

## 03. Installaing Apache Kafka
curl "https://downloads.apache.org/kafka/2.6.2/kafka_2.13-2.6.2.tgz" -o kafka.tgz

# If having error for the above binaries to download because of the Certificate use the below command
# wget https://downloads.apache.org/kafka/2.6.2/kafka_2.13-2.6.2.tgz --no-check-certificate

# Kafka Base Directory
KafkaBD=/home/kafka/kafka

# Create a directory named "kafka" and change to this directory and extract the binaries
mkdir $KafkaBD && sudo mkdir $KafkaBD/log && cd $KafkaBD && tar -xvzf ~/kafka.tgz --strip 1

# Kafka’s default behavior will not allow you to delete a topic, edit the config and make the change
sudo bash -c "printf delete.topic.enable=true >> $KafkaBD/config/server.properties" &&
printf "Delete a Topic is now enabled in Kafka Config\n" && tail -1 config/server.properties

# Change the Kafka Logs directory location
sed -i 's|log.dirs=/tmp/kafka-logs|log.dirs=/home/kafka/kafka/logs|g' config/server.properties

# Create the Service for Zookeeper and move it to /etc/systemd/system and change the ownership to root
cat > zookeeper.service<< EOF
[Unit]
Requires=network.target remote-fs.target
After=network.target remote-fs.target

[Service]
Type=simple
User=kafka
ExecStart=/home/kafka/kafka/bin/zookeeper-server-start.sh /home/kafka/kafka/config/zookeeper.properties
ExecStop=/home/kafka/kafka/bin/zookeeper-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
EOF

sudo mv zookeeper.service /etc/systemd/system/ && sudo chown -R root:root /etc/systemd/system/zookeeper.service

# Create the Service for Kafka and move it to /etc/systemd/system and change the ownership to root
cat > kafka.service<< EOF
[Unit]
Requires=zookeeper.service
After=zookeeper.service

[Service]
Type=simple
User=kafka
ExecStart=/bin/sh -c '/home/kafka/kafka/bin/kafka-server-start.sh /home/kafka/kafka/config/server.properties > /home/kafka/kafka/logs/kafka.log 2>&1'
ExecStop=/home/kafka/kafka/bin/kafka-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
EOF

sudo mv kafka.service /etc/systemd/system/ && sudo chown -R root:root /etc/systemd/system/kafka.service

# Start Kafka and Zookeeper Services and Check the Status
sudo systemctl start kafka &&
systemctl status kafka --no-pager &&
systemctl status zookeeper --no-pager

## 04. Testing {Optional}
# Creating a Test Topic
#bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic FirstTopic

# Seding Text to the Topic
#echo "Hello, World" | bin/kafka-console-producer.sh --broker-list localhost:9092 --topic FirstTopic > /dev/null

# Running the Kafka Consumer
#bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic FirstTopic --from-beginning

# Running the Kafka Producer
#echo "Hello World from Abdul Haseeb!" | bin/kafka-console-producer.sh --broker-list localhost:9092 --topic FirstTopic > /dev/null
