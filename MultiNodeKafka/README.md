# Kafka Deployment with Zookeeper
On-Prem/Data Center Kafka + Zookeeper Multi-Node (Clustered) Deployment on 3 Servers having [3 (Kafka Brokers) + 3 (Zookeepers)]

**Important | Change Hostname and IPs**
1. Change "**host**" file to accomodate the Server's Hostnames and IPs
2. Change "**roles/kafka/defaults/main.yml**" file to accomodate the Server's Hostnames and IPs

## For Installation | Supported Commands and Switches
The playbook support the following operations with the respective tags using "**kafka-install.yml**"
1. install
2. uninstall

**Install/Deploy on Multiple Instances**
```
ansible-playbook -i hosts kafka-installer.yml --extra-vars "target_hosts=kafka_hosts role_name=kafka run_option=install"
```
**Uninstall/Remove the Deployment**
```
ansible-playbook -i hosts kafka-installer.yml --extra-vars "target_hosts=kafka_hosts role_name=kafka run_option=uninstall"
```
## For Services  | Supported Commands and Switches
The playbook support the following operations with the respective tags using "**kafka-status.yml**"
1. start
2. stop
3. restart

**Start the Services**
```
ansible-playbook -i hosts kafka-status.yml --extra-vars "target_hosts=kafka_hosts role_name=kafka run_option=start"
```
**Stop the Running Services**
```
ansible-playbook -i hosts kafka-status.yml --extra-vars "target_hosts=kafka_hosts role_name=kafka run_option=stop"
```
**Restart the Services**
```
ansible-playbook -i hosts kafka-status.yml --extra-vars "target_hosts=kafka_hosts role_name=kafka run_option=restart"
```
## For Testing the Deployment {optional}
Perform the following operations by going to Kafka Home Dir: "**/opt/kafka/**" and enter the respective Server IPs (without brackets{}) in the commands below on any of the server:

**Create a Topic**

The command below creates a new topic named **FirstTopic** with 6 partitions. Each cluster will be responsible for 2 partitions. The replication-factor has been set to 1, which means data is not being replicated and the data for a particular partition will only be stored on one server.
```
bin/kafka-topics.sh --create --zookeeper {Server1IP}:2181,{Server2IP}:2181,{Server3IP}:2181 --replication-factor 1 --partitions 6 --topic FirstTopic --config cleanup.policy=delete --config delete.retention.ms=60000
```
**List the available/existing Topics {optional}**
```
bin/kafka-topics.sh --list --zookeeper {AnyServerIP}:2181
```
**Get the detail description of the newly created Topic**
```
bin/kafka-topics.sh --describe --zookeeper {AnyServerIP}:2181 --topic FirstTopic
```
**Running the Kafka Producer**

The command opens a prompt and anything entered here will be sent to the topic.
```
bin/kafka-console-producer.sh --broker-list {AnyServerIP}:9092 --topic FirstTopic --from-beginning
```
**Running the Kafka Consumer**

Open it on another terminal rather than a producer, so whenever a string entered in the producer prompt it will be printed out in our consumer terminal.
```
bin/kafka-console-consumer.sh --bootstrap-server {AnyServerIP}:9092 --topic FirstTopic
```
