# proxmox

The script "backup_pve.sh" will backup the proxmox-DB located in "/var/lib/pve-cluster/" and the files for config for the host in "/etc/". It is intended to be run from the PBS-host, with passwordless login to the proxmox host.
Once files are fetched to the PBS-host, they will be packed into a TAR-ball and gzipped, and the source files fetched will be removed. Once done, it will check to see if there are any backups older than 30 days, and remove them, but only if new backup was succesful.

The variables that needs to be updated:<br />
The IP needs to be changed to reflect the proxmox-host:<br />
```# Remote server details```<br />
```REMOTE_HOST="192.168.1.99"```<br />

The BASE_PATH needs to be changed to reflect the pbs host Datastorage-path:<br />
```# Local storage path```<br />
```LOCAL_BASE_PATH="/mnt/ugreen/pve"```<br />

The script is triggered on the PBS-host via a root cron:<br />
```# Run Backup Script Daily at Specific Time (2:00 AM):```<br />
```0 2 * * * /mnt/ugreen/backup_pve.sh```
