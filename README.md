# Deploy Magento2 INT via Ansible

> Ansible provisioned Ubuntu 16.04.02 LTS.

Full-featured Magento2 Deployment for INT.

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

[In-case the key is not working, follow this ...](https://wiki.qnap.com/wiki/SSH:_How_To_Set_Up_Authorized_Keys)

### 2. Getting the Script
```bash
cd ~/
git clone https://team-it@pm.citrusstv.com:8484/team-it/Magento2viaAnsibleDev.git
```

### 3. Changes to be made in the Script (MUST DO)
- Change all the values in configure.sh and run the file to replace values in Ansible/Roles as per your environment.
`Ansible currently support only tar/zip/bz2 Archive, so kindly make the MySQL Backup in bz2 else you need to unarchive to .sql and then import, By default in this script the SQL dump is commented under: roles/magento/tasks/main.yml [Extract Magento Database]`
- Change Magento Variable's in tmp/installmagento.sh
- Change MySQL root Password in tmp/mysqlscript.sh

### 4. Running the Script
If you don't want to use the inventory.ini file edit the Ansible Host
```bash
nano /etc/ansible/hosts
```
and @ the end of the file, copy and paste everything from inventory.ini and change the parameters

#### Edit the inventory.ini to put the IP or Host where you want to run the script
```bash
cd Magento2viaAnsibleDev
nano inventory.ini
```
- Replace the Name of the Server (optional)
- Replace the IP or Host
- Replace the Assible User
- Replace the Ansible Password

#### Run the Script
```bash
sudo ansible-playbook -i inventory.ini install.yml --user administrator --ask-become-pass
```
--ask-become-pass is a Security Level to ask the Client's User Password Again

- Running the Script without inventory.ini will take the values from Ansible Host File

```bash
sudo ansible-playbook -v install.yml --ask-become-pass
```
-v will display the task result on stdout

- In-case the script got into and error, you can re-run the script from where it's ended

```bash
sudo ansible-playbook -v install.yml --start-at-task="TaskName" --ask-become-pass
```
