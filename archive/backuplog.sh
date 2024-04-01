#!/bin/bash

# Global variable to remember the last backed-up file or directory
LAST_BACKED_UP=""

backuplog() {
    # Default values
    local file_to_backup="$LAST_BACKED_UP"
    local comment=""
    local custom_filename=""
    local custom_destination="/tmp/backups/backuplog"
    local log_file=""
    local backup_version=0

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -b)
                file_to_backup="$2"
                shift 2
                ;;
            -c)
                comment="$2"
                shift 2
                ;;
            -n)
                custom_filename="$2"
                shift 2
                ;;
            -d)
                custom_destination="$2"
                shift 2
                ;;
            *)
                echo "Unknown option: $1"
                return 1
                ;;
        esac
    done

    # If no file is specified and no last backup exists, use the parent directory
    if [ -z "$file_to_backup" ]; then
        if [ -z "$LAST_BACKED_UP" ]; then
            file_to_backup=$(dirname "$(pwd)")
        else
            file_to_backup="$LAST_BACKED_UP"
        fi
    fi

    # Validate file or directory to backup
    if [ ! -e "$file_to_backup" ]; then
        echo "Error: The specified file or directory does not exist."
        return 1
    fi

    # Update the global variable
    LAST_BACKED_UP="$file_to_backup"

    # Create backup directory if it doesn't exist
    if ! mkdir -p "$custom_destination/$(basename "$file_to_backup")"; then
        echo "Error: Failed to create the backup directory."
        return 1
    fi

    # Determine the backup version
    if [ -f "$custom_destination/$(basename "$file_to_backup")/$(basename "$file_to_backup").log" ]; then
        last_entry=$(tail -n 1 "$custom_destination/$(basename "$file_to_backup")/$(basename "$file_to_backup").log")
        last_version=$(echo "$last_entry" | cut -d '|' -f 1)
        if [[ "$last_version" =~ ^[0-9]+$ ]]; then
            backup_version=$((last_version + 1))
        else
            backup_version=1
        fi
    else
        backup_version=1
    fi

    # Define the archive name
    local archive_name=""
    if [ -n "$custom_filename" ]; then
        archive_name="$custom_filename"
    else
        archive_name="$(basename "$file_to_backup")_$backup_version"
    fi

    # Create the archive
    if ! tar -czf "$custom_destination/$(basename "$file_to_backup")/$archive_name.tar.gz" "$file_to_backup"; then
        echo "Error: Failed to create the archive."
        return 1
    fi

    # Log file path
    log_file="$custom_destination/$(basename "$file_to_backup")/$(basename "$file_to_backup").log"

    # Update log
    if ! echo "$backup_version|$(basename "$file_to_backup")|$backup_version|$(date)|$comment" >> "$log_file"; then
        echo "Error: Failed to update the log file."
        return 1
    fi

    echo "Backup and logging successful."
}

# Export the function for use in the current shell
export -f backuplog
