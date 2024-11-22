# proxmox

This is where the PBS backup script will be located.

The script "backup_pve.sh" will backup the proxmox-DB located in "/var/lib/pve-cluster/" and the files for config for the host in "/etc/". It is intended to be run from the PBS-host, with passwordless login to the proxmox host.
Once files are fetched to the PBS-host, they will be gzipped and packed into a TAR-ball, and the source files fetched will be removed. Once done, it will check to see if there are any backups older than 30 days, and remove them, but only if new backup was succesful.

The script is triggered on the PBS-host via a root cron:
Run Backup Script Daily at Specific Time (2:00 AM):
0 2 * * * /mnt/ugreen/backup_pve.sh
