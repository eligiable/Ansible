# Magento 2 Post-Installation Guide

## 1. Load Balancer Configuration (Required)

### Nginx LB Example:
```nginx
upstream magento_cluster {
    server app1.example.com:80 weight=5;
    server app2.example.com:80 weight=5;
    keepalive 32;
}

server {
    listen 443 ssl http2;
    server_name store.example.com;
    
    # SSL Configuration
    ssl_certificate /etc/letsencrypt/live/store.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/store.example.com/privkey.pem;
    
    # Security Headers
    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    
    location / {
        proxy_pass http://magento_cluster;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## 2. SSL Certificate Setup
```bash
sudo certbot --nginx \
    -d store.example.com \
    -d www.store.example.com \
    --non-interactive \
    --agree-tos \
    --email admin@example.com
```

## 3. Monitoring Setup

### Required Metrics:
| Service       | Key Metrics                          | Tool          |
|---------------|--------------------------------------|---------------|
| PHP-FPM       | Active processes, slow requests     | Prometheus    |
| MySQL         | Query latency, connections          | Percona PMM   |
| Redis         | Memory usage, evictions             | RedisInsight  |
| Magento       | Cron status, cache hit ratio        | New Relic     |

## 4. Backup Procedures

### Database Backup (Daily)
```bash
#!/bin/bash
BACKUP_DIR="/backups/mysql"
DATE=$(date +%Y%m%d)
mysqldump --single-transaction -u root -p"$DB_PASS" magento | gzip > "$BACKUP_DIR/magento-db-$DATE.sql.gz"
find "$BACKUP_DIR" -type f -mtime +7 -delete
```

### Code/Media Backup (Hourly)
```bash
rsync -az --delete /var/www/magento/current/ /backups/magento/latest/
```

## 5. Security Hardening

### Magento Specific:
```bash
# Remove adminer.php, phpmyadmin if exists
sudo rm -f /var/www/magento/current/adminer.php

# Secure media directory
chmod 644 /var/www/magento/current/pub/media/*
```

### Server Level:
```bash
# Install and configure ModSecurity
sudo apt install libapache2-mod-security2
sudo mv /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
```

## 6. Performance Tuning

### Redis Optimization:
```ini
# In /etc/redis/redis.conf
maxmemory 4GB
maxmemory-policy allkeys-lru
```

### PHP OPcache:
```ini
opcache.enable=1
opcache.memory_consumption=512
opcache.max_accelerated_files=60000
```

## 7. Troubleshooting

### Common Issues:

**1. Redis Connection Errors**
```bash
# Test connectivity
redis-cli -h redis.example.com -a 'your_password' PING
```

**2. Database Deadlocks**
```sql
SHOW ENGINE INNODB STATUS;
```

**3. Static Files 404**
```bash
php bin/magento setup:static-content:deploy -f --jobs $(nproc)
```

## 8. Upgrade Procedure

```bash
# Maintenance mode
php bin/magento maintenance:enable

# Code update
git pull origin 2.4.6
composer install --no-dev

# Apply upgrades
php bin/magento setup:upgrade
php bin/magento setup:di:compile
php bin/magento setup:static-content:deploy -f
php bin/magento maintenance:disable
```

This file should be saved at:
```
your-ansible-project/
└── docs/
    └── post-install.md
```