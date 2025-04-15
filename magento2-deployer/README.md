# Magento 2 3-Tier Ansible Deployment

## 📂 Complete Directory Structure

```
.
├── ansible.cfg                     # Main Ansible configuration
├── docs/                           # Documentation
│   ├── architecture.md             # Infrastructure diagrams and specs
│   └── post-install.md             # Post-deployment procedures
├── group_vars/                     # Group-specific variables
│   ├── all.yml                     # Common variables (timezone, packages)
│   ├── app.yml                     # App server config (Magento, PHP, Nginx)
│   ├── db.yml                      # Database config (MySQL credentials, tuning)
│   └── redis.yml                   # Redis config (memory, security)
├── host_vars/                      # Host-specific overrides
│   ├── app1.example.com.yml        # Primary app server customizations
│   ├── app2.example.com.yml        # Secondary app server customizations
│   ├── db.example.com.yml          # Database server specific settings
│   └── redis.example.com.yml       # Redis server adjustments
├── inventory.ini                   # Server inventory with groups
├── requirements.yml                # External role dependencies
├── roles/
│   ├── common/                     # Base server setup
│   │   ├── handlers/main.yml       # Service handlers (SSH, fail2ban)
│   │   ├── tasks/main.yml          # Common tasks (users, security)
│   │   └── templates/
│   │       ├── jail.local.j2       # Fail2ban configuration
│   │       └── sshd_config.j2      # Hardened SSH configuration
│   ├── magento/                    # Magento installation
│   │   ├── handlers/main.yml       # Magento handlers (cache, reindex)
│   │   ├── tasks/main.yml          # Magento deployment tasks
│   │   └── templates/
│   │       └── magento_cron.service.j2  # Systemd service unit
│   ├── mysql/                      # MySQL database
│   │   ├── handlers/main.yml       # DB handlers (restart, privileges)
│   │   ├── tasks/main.yml          # MySQL installation tasks
│   │   └── templates/
│   │       ├── mysql-performance.cnf.j2 # Performance tuning
│   │       └── mysqld.cnf.j2       # Main MySQL configuration
│   ├── nginx/                      # Web server
│   │   ├── handlers/main.yml       # Nginx handlers (test, reload)
│   │   ├── tasks/main.yml          # Nginx installation tasks
│   │   └── templates/
│   │       ├── magento2.conf.j2    # Magento Nginx vhost
│   │       └── nginx.conf.j2       # Main Nginx configuration
│   ├── php/                        # PHP configuration
│   │   ├── tasks/main.yml          # PHP-FPM installation
│   │   └── templates/
│   │       ├── php-cli.ini.j2      # CLI-specific PHP settings
│   │       ├── php.ini.j2          # PHP-FPM configuration
│   │       └── www.conf.j2         # PHP-FPM pool settings
│   └── redis/                      # Redis cache
│       ├── handlers/main.yml       # Redis handlers (restart, flush)
│       ├── tasks/main.yml          # Redis installation tasks
│       └── templates/
│           └── redis.conf.j2       # Redis configuration
└── site.yml                        # Main playbook
```

## 🏗️ Deployment Components

### Core Configuration
- `ansible.cfg`: Sets SSH timeouts (30s), forks (10), and privilege escalation
- `inventory.ini`: Defines server groups (app/db/redis) with connection details
- `site.yml`: Orchestrates role execution across tiers

### Variable Hierarchy
- **Group Variables**: Apply to all servers in a group (app/db/redis)
- **Host Variables**: Override specific server configurations
- **Secret Management**: All passwords use `!vault` encrypted variables

### Key Role Functions

| Role       | Key Features                                                                 |
|------------|-----------------------------------------------------------------------------|
| common     | SSH hardening, fail2ban, firewall, system users                             |
| nginx      | HTTP/2 support, Magento-optimized vhost, security headers                   |
| php        | PHP 8.2 FPM, OPcache tuning, disabled dangerous functions                   |
| mysql      | InnoDB optimization, secured remote access, buffer pool sizing              |
| redis      | Authenticated connections, LRU eviction policy, memory limits               |
| magento    | Production-mode deployment, secure cron service, Redis session integration  |

## 🚀 Deployment Commands

1. Install dependencies:
   ```bash
   ansible-galaxy install -r requirements.yml
   ```

2. Run deployment:
   ```bash
   ansible-playbook -i inventory.ini site.yml
   ```

3. Post-install (see `docs/post-install.md`):
   ```bash
   # SSL setup
   ansible app -m command -a "certbot --nginx -d {{ magento_base_url }} --redirect"
   
   # Load balancer config
   ansible lb -m template -a "src=templates/haproxy.cfg.j2 dest=/etc/haproxy/haproxy.cfg"
   ```

## 🔒 Security Features
- **Network**: Service isolation (app ↔ db ↔ redis)
- **Access Control**: SSH key auth only, restricted sudo
- **Application**: Admin path obscurity, production mode
- **Monitoring**: Fail2ban jails for SSH/Nginx

## 🛠️ Maintenance
```bash
# Flush cache
ansible app -m command -a "php /var/www/magento/current/bin/magento cache:flush"

# Reindex
ansible app -m command -a "php /var/www/magento/current/bin/magento indexer:reindex"
```