#!/bin/bash
echo "Disk Usage:" > /mnt/c/Users/Reshma/Documents/Devops_oct_24/linux_assignment/system_metrics.log
df -h >> /mnt/c/Users/Reshma/Documents/Devops_oct_24/linux_assignment/system_metrics.log
echo "Top Processes:" >> /mnt/c/Users/Reshma/Documents/Devops_oct_24/linux_assignment/system_metrics.log
ps aux --sort=-%cpu,-%mem | head -n 10 >> /mnt/c/Users/Reshma/Documents/Devops_oct_24/linux_assignment/system_metrics.log

