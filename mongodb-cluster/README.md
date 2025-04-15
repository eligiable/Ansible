# MongoDB Replica Set Deployment with Ansible and Docker

This project automates the deployment of a MongoDB replica set across three nodes using Docker containers, with proper security configurations and volume mappings.

## Directory Structure

```
mongodb-cluster/
├── inventories/
│   ├── production/
│   │   ├── hosts.ini          # Inventory file defining the 3 MongoDB nodes
│   │   └── group_vars/
│   │       └── all.yml        # Common variables for the deployment
├── roles/
│   └── mongodb-replica/
│       ├── tasks/
│       │   ├── main.yml       # Orchestrates the deployment workflow
│       │   ├── docker.yml     # Docker installation and setup tasks
│       │   ├── mongodb.yml    # MongoDB-specific configuration tasks
│       │   └── replica.yml    # Replica set initialization and configuration
│       ├── templates/
│       │   ├── mongod.conf.j2 # MongoDB configuration template
│       │   └── hosts.j2       # /etc/hosts template for node resolution
│       └── vars/
│           └── main.yml       # Role-specific variables
├── playbook.yml               # Main playbook that drives the deployment
└── README.md                  # This documentation file
```

## Deployment Features

- **High Availability**: 3-node MongoDB replica set deployment
- **Security**: Keyfile authentication, admin user creation
- **Persistence**: Data volumes mapped to default MongoDB directories
- **Host Resolution**: Proper /etc/hosts configuration for node communication
- **Containerized**: Docker-based deployment for easy management

## Requirements

- Ansible 2.9+
- Docker-capable hosts (Ubuntu 20.04/22.04 recommended)
- SSH access to all nodes from control machine
- Python 3.x on all nodes

## Usage

1. Edit the inventory file with your node details
2. Adjust variables in `group_vars/all.yml` as needed
3. Run the playbook:
   ```bash
   ansible-playbook -i inventories/production/hosts.ini playbook.yml
   ```

The deployment will sequentially configure each node and initialize the replica set with proper security settings.