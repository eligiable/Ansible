# Magento2 via Ansible - Basic Installation

> Ansible provisioned Ubuntu 16.04.02 LTS.

Definitely not full-featured but useful to bootstrap a dev project.

## Prerequisites (on Client, where you want to run this Script)

- Ubuntu 16.04.02 LTS with all updates

```bash
sudo apt install update && sudo apt -y upgrade
```
- SSH

```bash
sudo apt install -y openssh-server
ssh-keygen -t rsa
```
- Ansible

```bash
sudo apt install -y ansible
```

## Get started

### 1. Add the SSH Key to the Server (from where you want to run this Script)

```bash
cd ~/
cat .ssh/id_rsa.pub
```
- Copy the key to the Server

```bash
nano authorized_keys
```

### 2. Getting the Script
```bash
cd ~/
git clone https://github.com/eligiable/Ansible.git
```

### 3. Changes to be made in the Script (MUST DO)
- Change the "host" value in install.yml
- Rename Magento Database Username and Password in install.yml under:

```bash
- name: Create Magento2 Database
- name: Import Magento2 Database Dump
- name: Add Deploy DB User and Allow Access to the Server
```

- Change Magento Variable's in installmagento.sh
- Change "server_name" value in magento

### 4. Running the Script
If you don't want to use the inventory.ini file edit the Ansible Host
```bash
nano /etc/ansible/hosts
```
and @ the end of the file, copy and paste everything from inventory.ini and change the parameters

#### Edit the inventory.ini to put the IP or Host where you want to run the script
```bash
cd Magento2viaAnsible
nano inventory.ini
```
- Replace the Name of the Server (optional)
- Replace the IP or Host
- Replace the Assible User
- Replace the Ansible Password

#### Run the Script
```bash
sudo ansible-playbook -i inventory.ini install.yml --ask-become-pass
```
--ask-become-pass is a Security Level to ask the Client's User Password Again

- Running the Script without inventory.ini will take the values from Ansible Host File

```bash
sudo ansible-playbook -v install.yml --ask-become-pass
```
