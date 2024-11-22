#!/bin/bash

# Remote server details
REMOTE_HOST="192.168.1.99"
REMOTE_PATHS=("/var/lib/pve-cluster/" "/etc/")

# Local storage path
LOCAL_BASE_PATH="/mnt/ugreen/pve"

# Create a timestamp for the folder name
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOCAL_DEST_PATH="${LOCAL_BASE_PATH}/backup_${TIMESTAMP}"

# Create the destination directory
mkdir -p "$LOCAL_DEST_PATH"

# Function to run rsync
run_rsync() {
    rsync -avzR -e ssh "${REMOTE_HOST}:$1" "$LOCAL_DEST_PATH"
    return $?
}

# Run rsync for each path
for path in "${REMOTE_PATHS[@]}"; do
    echo "Backing up $path"
    run_rsync "$path"
    if [ $? -ne 0 ]; then
        echo "Backup failed for $path. Please check your settings and try again."
        exit 1
    fi
done

# Create tar.gz archive
ARCHIVE_NAME="${LOCAL_BASE_PATH}/backup_${TIMESTAMP}.tar.gz"
echo "Creating compressed archive: $ARCHIVE_NAME"
tar -czf "$ARCHIVE_NAME" -C "$LOCAL_BASE_PATH" "backup_${TIMESTAMP}"

if [ $? -eq 0 ]; then
    echo "Archive created successfully."
    # Remove the original backup directory
    rm -rf "$LOCAL_DEST_PATH"
    echo "Original backup directory removed."
else
    echo "Failed to create archive. The uncompressed backup is still available at $LOCAL_DEST_PATH"
    exit 1
fi

# If we get here, all operations were successful
echo "Backup completed successfully. Archive stored at: $ARCHIVE_NAME"

# Remove backups older than 30 days
find "$LOCAL_BASE_PATH" -maxdepth 1 \( -type d -name "backup_*" -o -type f -name "backup_*.tar.gz" \) -mtime +30 -exec rm -rf {} +
