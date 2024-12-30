#!/bin/bash
DATE=$(date +%F)
tar -czf /mnt/c/Users/Reshma/Documents/Devops_oct_24/linux_assignment/apache_backup_$DATE.tar.gz /etc/apache2/ /var/www/html/
