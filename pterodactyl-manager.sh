#!/bin/bash

# Function to create an admin account
create_admin_account() {
    read -p "Enter admin email: " admin_email
    read -sp "Enter admin password: " admin_password
    echo
    php /var/www/pterodactyl/artisan p:user:make --admin 1 --email "$admin_email" --password "$admin_password"
    echo "Admin account created successfully."
}

# Function to remove cache
remove_cache() {
    php /var/www/pterodactyl/artisan view:clear
    php /var/www/pterodactyl/artisan config:clear
    echo "Pterodactyl cache cleared successfully."
}

# Function to restart Pterodactyl and re-run the setup
restart_pterodactyl() {
    cd /var/www/pterodactyl

    # Install NVM
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

    # Load NVM into the current shell session
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # Install Node.js version 16
    nvm install 16

    # Install Yarn globally
    npm install -g yarn

    # Initialize Yarn in the Pterodactyl directory
    yarn

    # Add the specified packages
    yarn add sanitize-html@2.7.3 @types/sanitize-html@2.6.2

    # Build the production environment
    yarn build:production

    echo "Pterodactyl panel restarted and setup successfully."
}

# Pterodactyl Manager Menu
while true; do
    echo "Pterodactyl Manager"
    echo "1. Pterodactyl Admin Account Creator"
    echo "2. Pterodactyl Cache Remover"
    echo "3. Pterodactyl Restarter"
    echo "4. Exit"
    read -p "Please select an option [1-4]: " option

    case $option in
        1)
            create_admin_account
            ;;
        2)
            remove_cache
            ;;
        3)
            restart_pterodactyl
            ;;
        4)
            echo "Exiting Pterodactyl Manager."
            break
            ;;
        *)
            echo "Invalid option. Please select a valid option [1-4]."
            ;;
    esac
done
