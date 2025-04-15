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

## File Descriptions

### Root Level Files

1. **playbook.yml**  
   The main Ansible playbook that orchestrates the MongoDB replica set deployment across all nodes.

2. **README.md**  
   This documentation file explaining the project structure and deployment process.

### Inventory Files

1. **inventories/production/hosts.ini**  
   Defines the three MongoDB nodes in the replica set with their connection details.

2. **inventories/production/group_vars/all.yml**  
   Contains all the configurable variables for the deployment including:
   - MongoDB version and credentials
   - Replica set name
   - Directory paths
   - Docker Compose version

### Role Files

#### Tasks

1. **roles/mongodb-replica/tasks/main.yml**  
   Main tasks file that includes all other task files in the correct order.

2. **roles/mongodb-replica/tasks/docker.yml**  
   Handles Docker installation, Docker Compose setup, and service configuration.

3. **roles/mongodb-replica/tasks/mongodb.yml**  
   Manages MongoDB-specific tasks including:
   - Directory creation
   - Keyfile generation for authentication
   - Docker container deployment
   - Configuration file setup

4. **roles/mongodb-replica/tasks/replica.yml**  
   Handles replica set initialization and configuration:
   - Initializing the replica set on the primary node
   - Adding secondary nodes
   - Verifying replica set status

#### Templates

1. **roles/mongodb-replica/templates/mongod.conf.j2**  
   Jinja2 template for MongoDB configuration file with:
   - Storage settings
   - Logging configuration
   - Network bindings
   - Security and replication settings

2. **roles/mongodb-replica/templates/hosts.j2**  
   Jinja2 template for /etc/hosts file that ensures proper hostname resolution between replica set members.

#### Variables

1. **roles/mongodb-replica/vars/main.yml**  
   Contains role-specific variables (currently empty as we're using group_vars).

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