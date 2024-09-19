#!/bin/bash

# Define paths
SCRIPT_PATH="/usr/local/bin/olopara_script.sh"
CRON_JOB="*/5 * * * * $SCRIPT_PATH"

# Create the backup script file
echo "#!/bin/bash" > $SCRIPT_PATH
echo "" >> $SCRIPT_PATH
echo "# Copy files from source to destination" >> $SCRIPT_PATH
echo "cp -R /var/lib/pterodactyl/volumes /var/olopara" >> $SCRIPT_PATH

# Make the backup script executable
chmod +x $SCRIPT_PATH

# Check if the cron job already exists
CRON_EXIST=$(crontab -l | grep -F "$SCRIPT_PATH")

if [ -z "$CRON_EXIST" ]; then
    # Add the cron job
    (crontab -l; echo "$CRON_JOB") | crontab -
    echo "Cron job added: $CRON_JOB"
else
    echo "Cron job already exists: $CRON_JOB"
fi
