# Kafka & Zookeeper Cluster Deployment

## Complete Directory Structure with File Descriptions

```
kafka-ansible/
├── inventories/                       # Inventory configurations
│   └── production/                    # Production environment
│       ├── hosts                      # Defines Zookeeper and Kafka node groupings
│       └── group_vars/                # Group-specific variables
│           ├── all.yml                # Common vars (cluster name, security flags)
│           ├── zookeepers.yml         # ZK-specific config (ports, ensemble settings)
│           └── kafka_brokers.yml      # Broker config (listeners, replication factors)
│
├── roles/
│   ├── common/                        # Base system setup
│   │   ├── tasks/main.yml             # Installs Java, creates directories
│   │   └── handlers/main.yml          # Handles systemd reloads
│   │
│   ├── zookeeper/                     # Zookeeper deployment
│   │   ├── tasks/main.yml             # Downloads, installs and configures ZK
│   │   ├── templates/
│   │   │   ├── zoo.cfg.j2             # Main ZK config (tickTime, dataDir, server list)
│   │   │   └── zookeeper.service.j2   # Systemd unit file
│   │   └── handlers/main.yml          # Service restart handlers
│   │
│   ├── kafka/                         # Kafka deployment
│   │   ├── tasks/main.yml             # Installs Kafka, configures brokers
│   │   ├── templates/
│   │   │   ├── server.properties.j2   # Broker config (listeners, log dirs, ZK conn)
│   │   │   ├── kafka.service.j2       # Systemd unit with proper dependencies
│   │   │   └── admin.properties.j2    # Admin client config (security settings)
│   │   └── handlers/main.yml          # Graceful restart handlers
│   │
│   └── security/                      # Security configuration
│       ├── tasks/
│       │   ├── main.yml               # Base security (firewall, directories)
│       │   ├── zookeeper_keystore.yml # ZK TLS cert generation
│       │   └── kafka_keystore.yml     # Kafka TLS cert generation
│       └── templates/
│           ├── kafka_server_jaas.conf.j2 # SASL authentication config
│           └── zookeeper_jaas.conf.j2    # ZK digest authentication
│
├── playbooks/                         # Top-level playbooks
│   ├── site.yml                       # Main deployment (calls all roles)
│   ├── security.yml                   # Certificate generation playbook
│   └── validate.yml                   # Cluster health validation
```

## Key Configuration Highlights

### Security Templates
- **`kafka_server_jaas.conf.j2`**: Configures SASL/PLAIN authentication with:
  ```ini
  user_admin="admin-secret"  # Pre-configured admin user
  user_alice="alice-secret"  # Example additional user
  ```

### Kafka Configuration
- **`server.properties.j2`** includes:
  ```ini
  advertised.listeners=PLAINTEXT://{{ ansible_hostname }}:9092,SSL://{{ ansible_hostname }}:9093
  ssl.keystore.password={{ kafka_tls_keystore_password }}  # Vault-encrypted in prod
  ```

### Zookeeper Systemd Service
- **`zookeeper.service.j2`** ensures:
  ```ini
  Restart=on-failure          # Automatic recovery
  LimitNOFILE=65536           # Increased file handles
  After=network.target        # Proper startup ordering
  ```

## Deployment Workflow

1. **Initialize Security**:
   ```bash
   ansible-playbook -i inventories/production playbooks/security.yml
   ```

2. **Deploy Cluster**:
   ```bash
   ansible-playbook -i inventories/production playbooks/site.yml
   ```

3. **Validate**:
   ```bash
   ansible-playbook -i inventories/production playbooks/validate.yml
   ```

## Verification Checks
The validation playbook confirms:
- ✅ Zookeeper ensemble health (`stat` command)
- ✅ Kafka broker connectivity (`kafka-broker-api-versions`)
- 🔒 TLS handshake success
- ✉️ End-to-end message production/consumption

```bash
# Sample validation output:
TASK [verify message consumption] ********************************
ok: [kafka1] => {
    "msg": "Successfully consumed 10 test messages"
}
```

## Maintenance Guide

### Certificate Rotation
1. Update `security.yml` with new passwords
2. Run with tag:
   ```bash
   ansible-playbook -i inventories/production playbooks/security.yml --tags certs
   ```

### Rolling Restart
```bash
ansible-playbook -i inventories/production playbooks/site.yml \
  --limit kafka_brokers:zookeepers \
  --tags restart
```