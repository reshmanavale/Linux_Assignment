# System Monitoring and Backup Configuration

## Table of Contents
1. [Introduction](#introduction)
2. [Task 1: System Monitoring Setup](#task-1-system-monitoring-setup)
    - [Step 1: Install Monitoring Tools](#step-1-install-monitoring-tools)
    - [Step 2: Disk Usage Monitoring](#step-2-disk-usage-monitoring)
    - [Step 3: Resource-Intensive Processes](#step-3-resource-intensive-processes)
    - [Step 4: Automate System Metrics Logging](#step-4-automate-system-metrics-logging)
3. [Task 2: User Management and Access Control](#task-2-user-management-and-access-control)
    - [Step 1: Create User Accounts](#step-1-create-user-accounts)
    - [Step 2: Create Isolated Directories](#step-2-create-isolated-directories)
    - [Step 3: Implement Password Policies](#step-3-implement-password-policies)
4. [Task 3: Backup Configuration for Web Servers](#task-3-backup-configuration-for-web-servers)
    - [Step 1: Create Backup Scripts](#step-1-create-backup-scripts)
    - [Step 2: Schedule Backups with Cron](#step-2-schedule-backups-with-cron)
    - [Step 3: Verify Backup Integrity](#step-3-verify-backup-integrity)
5. [Challenges Faced](#challenges-faced)
6. [Conclusion](#conclusion)
7. [Submission](#submission)

---

## Introduction

This document outlines the implementation steps for system monitoring, user management, and backup configuration in a Linux-based environment. It covers the tasks performed, including installation, configuration, and automation for efficient system management.

---

# Task 1: System Monitoring Setup

## Step 1: Install Monitoring Tools

### For Ubuntu/Debian-based Systems:
```bash
sudo apt update && sudo apt install -y htop nmon
```

### For Red Hat/CentOS-based Systems:
```bash
sudo yum install -y htop nmon
```

### Verify the installations:
```bash
htop --version
nmon
```

---

## Step 2: Set Up Disk Usage Monitoring

### Monitor disk space usage with `df`:
```bash
df -h > /var/log/disk_usage.log
```

### Monitor directory-specific usage with `du`:
```bash
du -sh /var/www/html /usr/share/nginx/html > /var/log/dir_usage.log
```

---

## Step 3: Identify Resource-Intensive Processes

### Use `htop`:
1. Run `htop`:
   ```bash
   htop
   ```
2. Sort by CPU or memory usage by pressing `F6`.

### Log resource-intensive processes using `ps`:
```bash
ps aux --sort=-%cpu,-%mem | head -n 10 > /var/log/resource_intensive.log
```

---

## Step 4: Automate System Metrics Logging

### Create a script `system_metrics.sh`:
```bash
sudo nano /usr/local/bin/system_metrics.sh
```

#### Add the following content to the script:
```bash
#!/bin/bash

echo "Disk Usage:" > /var/log/system_metrics.log
df -h >> /var/log/system_metrics.log

echo "Top Processes:" >> /var/log/system_metrics.log
ps aux --sort=-%cpu,-%mem | head -n 10 >> /var/log/system_metrics.log
```

### Make the script executable:
```bash
sudo chmod +x /usr/local/bin/system_metrics.sh
```

### Schedule the script with `cron`:
1. Open the crontab editor:
   ```bash
   crontab -e
   ```
2. Add the following line to run the script every hour:
   ```bash
   0 * * * * /usr/local/bin/system_metrics.sh

### Example of log file output:
![Screenshot 2024-12-29 024316](https://github.com/user-attachments/assets/1a7c49e9-a290-483a-ad3b-faa220193367)
<img width="722" alt="image" src="https://github.com/user-attachments/assets/03b96dc1-1a2c-45fd-824f-755806818f74" />

### Example of htop output:
<img width="836" alt="image" src="https://github.com/user-attachments/assets/f76a5f7d-895d-4734-a5a9-cf25e415c96f" />
---

# Task 2: User Management and Access Control

## Step 1: Create User Accounts

### Add users:
```bash
sudo useradd -m Sarah
sudo useradd -m Mike
```

### Set secure passwords:
```bash
sudo passwd Sarah
sudo passwd Mike
```

---

## Step 2: Create Isolated Directories

### Create directories:
```bash
sudo mkdir -p /home/Sarah/workspace /home/Mike/workspace
```

### Set ownership and permissions:
```bash
sudo chown Sarah:Sarah /home/Sarah/workspace
sudo chmod 700 /home/Sarah/workspace
sudo chown Mike:Mike /home/Mike/workspace
sudo chmod 700 /home/Mike/workspace
```

---

## Step 3: Implement Password Policies

### Install `libpam-pwquality`:
```bash
sudo apt install libpam-pwquality
```

### Configure `/etc/security/pwquality.conf`:
```bash
sudo nano /etc/security/pwquality.conf
```

#### Add the following content:
```makefile
minlen = 12
dcredit = -1
ucredit = -1
lcredit = -1
ocredit = -1
maxrepeat = 2
```

### Set password expiration:
```bash
sudo chage -M 30 Sarah
sudo chage -M 30 Mike
```
### output
![Screenshot 2024-12-29 025927](https://github.com/user-attachments/assets/b4d259e7-2a5c-4009-bdbf-fb9c65896843)
![Screenshot 2024-12-29 030006](https://github.com/user-attachments/assets/8f898973-3d81-4852-ae03-0ac79b849db3)
<img width="722" alt="image" src="https://github.com/user-attachments/assets/91c3050a-372d-4ee0-83af-146a33f52337" />

---

# Task 3: Backup Configuration for Web Servers

## Step 1: Create Backup Scripts

### For Sarah's Apache Server:
Create a backup script:
```bash
sudo nano /usr/local/bin/apache_backup.sh
```

Add the following content:
```bash
#!/bin/bash
backup_dir="/backups"
date=$(date +"%Y-%m-%d")
mkdir -p $backup_dir
tar -czf $backup_dir/apache_backup_$date.tar.gz /etc/httpd/ /var/www/html/
```

Make the script executable:
```bash
sudo chmod +x /usr/local/bin/apache_backup.sh
```

### For Mike's Nginx Server:
Create a backup script:
```bash
sudo nano /usr/local/bin/nginx_backup.sh
```

Add the following content:
```bash
#!/bin/bash
backup_dir="/backups"
date=$(date +"%Y-%m-%d")
mkdir -p $backup_dir
tar -czf $backup_dir/nginx_backup_$date.tar.gz /etc/nginx/ /usr/share/nginx/html/
```

Make the script executable:
```bash
sudo chmod +x /usr/local/bin/nginx_backup.sh
```

---

## Step 2: Schedule Backups with Cron

### Schedule Sarah's Apache backup:
1. Open the crontab editor:
   ```bash
   crontab -e
   ```
2. Add the following line to schedule the backup every Tuesday at 12:00 AM:
   ```bash
   0 0 * * 2 /usr/local/bin/apache_backup.sh
   ```

### Schedule Mike's Nginx backup:
1. Open the crontab editor:
   ```bash
   crontab -e
   ```
2. Add the following line to schedule the backup every Tuesday at 12:00 AM:
   ```bash
   0 0 * * 2 /usr/local/bin/nginx_backup.sh
   ```

---

## Step 3: Verify Backup Integrity

### Check the contents of the backup files:
```bash
tar -tzf /backups/apache_backup_<date>.tar.gz
tar -tzf /backups/nginx_backup_<date>.tar.gz
```

Replace `<date>` with the actual date of the backup file.

---

## logs
![Screenshot 2024-12-29 030724](https://github.com/user-attachments/assets/9b2e6537-5564-4ef1-a498-024673adf41f)
![Screenshot 2024-12-29 030756](https://github.com/user-attachments/assets/c15b042a-2cfe-4a9e-a12c-7e3dc9d34b46)
![Screenshot 2024-12-29 032641](https://github.com/user-attachments/assets/f08fc388-7363-4389-a7dd-364338424691)
<img width="722" alt="image" src="https://github.com/user-attachments/assets/582d1404-dfd7-4429-809f-f9403f5ed17f" />

### Challenges Faced
Permissions: Ensuring that the backup directories had the appropriate permissions to prevent unauthorized access was crucial.
Cron Scheduling: Ensuring the cron jobs ran as expected was challenging, especially when dealing with multiple user-specific tasks.
Password Policy Configuration: Fine-tuning the password policy settings to meet organizational requirements while ensuring user compliance.
### Conclusion
The system monitoring, user management, and backup configuration were successfully implemented according to best practices. Regular monitoring and backup processes will help maintain server health, ensure data security, and prevent data loss. The automation via cron ensures that these tasks are performed without manual intervention, saving time and reducing human error.

### Author 
Reshma Navale




   
