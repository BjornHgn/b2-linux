#!/bin/bash

SOURCE="/etc/ssh/ /var/log/"

DEST="/var/backup"

MAX_BACKUPS=5

function cleanup {
        find "$DEST" -name "backup_*.tar.gz" -type f -print0 | sort -z -r | tail -z -n +$MAX_BACKUPS | xargs -0 rm
}

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$DEST/backup_$TIMESTAMP.tar.gz"

if [ ! -d "$DEST" ]; then
    mkdir -p "$DEST"
fi

rsync -avz "$SOURCE" "$BACKUP_FILE"

cleanup

echo "Sauvegarde effectuée avec succès dans $BACKUP_FILE"