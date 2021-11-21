#!/bin/bash

# Installing Apache Kafka and Zookeeper on Ubuntu 20.04 {Multi Node Deployment}
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
### Create user for Kafka and run the below Script from that user {sudo ./ScriptName}
#sudo adduser {UsernameforKafka}
#sudo adduser kafka sudo
#su -l kafka

## 03. Installaing Apache Kafka and Zookeeper
curl "https://downloads.apache.org/kafka/2.6.2/kafka_2.13-2.6.2.tgz" -o kafka.tgz

# If having error for the above binaries to download because of the Certificate use the below command
# wget https://downloads.apache.org/kafka/2.6.2/kafka_2.13-2.6.2.tgz --no-check-certificate

# Kafka Base Directory
KafkaBD=/home/kafka/kafka

# Create a directory named "kafka" and change to this directory and extract the binaries
mkdir $KafkaBD && sudo mkdir $KafkaBD/log && cd $KafkaBD && tar -xvzf ~/kafka.tgz --strip 1

#--- Zookeeper MultiNode Deployment ---#

# Create 3 Zookeeper Properties
cp config/zookeeper.properties config/zookeeper.properties.bak &&
mv config/zookeeper.properties config/zookeeper1.properties &&
cp config/zookeeper1.properties config/zookeeper2.properties
cp config/zookeeper1.properties config/zookeeper3.properties

# Create Data Directories for all 3 Zookeeper Instances
mkdir -p data/zookeeper1 &&
mkdir -p data/zookeeper2 &&
mkdir -p data/zookeeper3

# Create a Unique ID for each Zookeeper Instance {ID can be of any digits}
echo 1 > data/zookeeper1/myid
echo 2 > data/zookeeper2/myid
echo 3 > data/zookeeper3/myid

## Update the Zookeeper1 Properties with the following:
cat > config/zookeeper1.properties<< EOF
dataDir=/home/kafka/kafka/data/zookeeper1
clientPort=2181
a non-production config
tickTime=2000
initLimit=5
syncLimit=2
server.1=localhost:2666:3666
server.2=localhost:2667:3667
server.3=localhost:2668:3668
maxClientCnxns=0
EOF

## Update the Zookeeper2 Properties with the following:
cat > config/zookeeper2.properties<< EOF
dataDir=/home/kafka/kafka/data/zookeeper2
clientPort=2182
a non-production config
tickTime=2000
initLimit=5
syncLimit=2
server.1=localhost:2666:3666
server.2=localhost:2667:3667
server.3=localhost:2668:3668
maxClientCnxns=0
EOF

## Update the Zookeeper3 Properties with the following:
cat > config/zookeeper3.properties<< EOF
dataDir=/home/kafka/kafka/data/zookeeper3
clientPort=2183
a non-production config
tickTime=2000
initLimit=5
syncLimit=2
server.1=localhost:2666:3666
server.2=localhost:2667:3667
server.3=localhost:2668:3668
maxClientCnxns=0
EOF

#--- Kafka MultiNode Deployment ---#

# Kafka’s default behavior will not allow you to delete a topic, edit the config and make the change
sudo bash -c "printf delete.topic.enable=true >> $KafkaBD/config/server.properties" &&
printf "Delete a Topic is now enabled in Kafka Config\n" && tail -1 config/server.properties

# Create 3 Kafka Properties
cp config/server.properties config/server.properties.bak &&
mv config/server.properties config/server1.properties &&
cp config/server1.properties config/server2.properties
cp config/server1.properties config/server3.properties

# Create Data Directories for all 3 Kafka Instances
mkdir -p data/kafka1-logs &&
mkdir -p data/kafka2-logs &&
mkdir -p data/kafka3-logs

## Update the Kafka Server 1 Properties with the following:
cat > config/server1.properties<< EOF
broker.id=0
log.dirs=/home/kafka/kafka/logs/kafka1-logs
port=9093
advertised.host.name=localhost
zookeeper.connect=localhost:2181,localhost:2182,localhost:2183
EOF

## Update the Kafka Server 2 Properties with the following:
cat > config/server2.properties<< EOF
broker.id=1
log.dirs=/home/kafka/kafka/logs/kafka2-logs
port=9094
advertised.host.name=localhost
zookeeper.connect=localhost:2181,localhost:2182,localhost:2183
EOF

## Update the Kafka Server 3 Properties with the following:
cat > config/server3.properties<< EOF
broker.id=2
log.dirs=/home/kafka/kafka/logs/kafka3-logs
port=9095
advertised.host.name=localhost
zookeeper.connect=localhost:2181,localhost:2182,localhost:2183
EOF

# Create the Service for Zookeeper Instances 1,2,3 and move it to /etc/systemd/system and change the ownership to root
cat > zookeeper1.service<< EOF
[Unit]
Requires=network.target remote-fs.target
After=network.target remote-fs.target

[Service]
Type=simple
User=kafka
ExecStart=/home/kafka/kafka/bin/zookeeper-server-start.sh /home/kafka/kafka/config/zookeeper1.properties
ExecStop=/home/kafka/kafka/bin/zookeeper-server-stop.sh /home/kafka/kafka/config/zookeeper1.properties
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
EOF

cat > zookeeper2.service<< EOF
[Unit]
Requires=network.target remote-fs.target
After=network.target remote-fs.target

[Service]
Type=simple
User=kafka
ExecStart=/home/kafka/kafka/bin/zookeeper-server-start.sh /home/kafka/kafka/config/zookeeper2.properties
ExecStop=/home/kafka/kafka/bin/zookeeper-server-stop.sh /home/kafka/kafka/config/zookeeper2.properties
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
EOF

cat > zookeeper3.service<< EOF
[Unit]
Requires=network.target remote-fs.target
After=network.target remote-fs.target

[Service]
Type=simple
User=kafka
ExecStart=/home/kafka/kafka/bin/zookeeper-server-start.sh /home/kafka/kafka/config/zookeeper3.properties
ExecStop=/home/kafka/kafka/bin/zookeeper-server-stop.sh /home/kafka/kafka/config/zookeeper3.properties
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
EOF

sudo mv zookeeper*.service /etc/systemd/system/ && sudo chown -R root:root /etc/systemd/system/zookeeper*.service

# Create the Service for Kafka Servers 1,2,3 and move it to /etc/systemd/system and change the ownership to root
cat > kafka1.service<< EOF
[Unit]
Requires=zookeeper1.service
After=zookeeper1.service

[Service]
Type=simple
User=kafka
ExecStart=/bin/sh -c '/home/kafka/kafka/bin/kafka-server-start.sh /home/kafka/kafka/config/server1.properties > /home/kafka/kafka/logs/kafka1.log 2>&1'
ExecStop=/home/kafka/kafka/bin/kafka-server-stop.sh /home/kafka/kafka/config/server1.properties
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
EOF

cat > kafka2.service<< EOF
[Unit]
Requires=zookeeper2.service
After=zookeeper2.service

[Service]
Type=simple
User=kafka
ExecStart=/bin/sh -c '/home/kafka/kafka/bin/kafka-server-start.sh /home/kafka/kafka/config/server2.properties > /home/kafka/kafka/logs/kafka2.log 2>&1'
ExecStop=/home/kafka/kafka/bin/kafka-server-stop.sh /home/kafka/kafka/config/server2.properties
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
EOF

cat > kafka3.service<< EOF
[Unit]
Requires=zookeeper3.service
After=zookeeper3.service

[Service]
Type=simple
User=kafka
ExecStart=/bin/sh -c '/home/kafka/kafka/bin/kafka-server-start.sh /home/kafka/kafka/config/server3.properties > /home/kafka/kafka/logs/kafka3.log 2>&1'
ExecStop=/home/kafka/kafka/bin/kafka-server-stop.sh /home/kafka/kafka/config/server3.properties
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
EOF

sudo mv kafka*.service /etc/systemd/system/ && sudo chown -R root:root /etc/systemd/system/kafka*.service

# Reload the System Deamon to load the Newly Created Services and wait for the Services to be Started
sudo systemctl deamon-reload && sleep 10s && echo 'Waiting for the Services to be Started ...' &&

# Start Kafka and Zookeeper Services and Check the Status
sudo systemctl start kafka1 &&
sudo systemctl start kafka2 &&
sudo systemctl start kafka3

# Check the Services and Ports are running
systemctl status kafka* --no-pager &&
systemctl status zookeeper* --no-pager

netstat - nltp | grep '2181\|2182\|2183\|9093\|9094\|9095'

# Enable the Services on Startup
sudo systemctl enable kafka1 &&
sudo systemctl enable kafka2 &&
sudo systemctl enable kafka3

## 04. Testing {Optional}
# Creating a Test Topic
#bin/kafka-topics.sh --create --zookeeper localhost:2181,localhost:2182,localhost:2183 --replication-factor 3 --partitions 3 --topic FirstTopic

# Seding Text to the Topic
#echo "Hello, World" | bin/kafka-console-producer.sh --broker-list localhost:9093,localhost:9094,localhost:9095 --topic FirstTopic > /dev/null

# Running the Kafka Consumer
#bin/kafka-console-consumer.sh --bootstrap-server localhost:9093,localhost:9094,localhost:9095 --topic FirstTopic --from-beginning

# Running the Kafka Producer
#echo "Hello World from Abdul Haseeb!" | bin/kafka-console-producer.sh --broker-list localhost:9093,localhost:9094,localhost:9095 --topic FirstTopic > /dev/null
