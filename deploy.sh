#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to prompt yes/no questions
ask_yes_no() {
    while true; do
        read -p "$1 (y/n): " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done
}

# Function to download file from URL
download_file() {
    local url=$1
    local destination=$2
    if command -v curl &> /dev/null; then
        curl -s -o "$destination" "$url"
    elif command -v wget &> /dev/null; then
        wget -q -O "$destination" "$url"
    else
        echo -e "${RED}Error: Neither curl nor wget is installed${NC}"
        return 1
    fi
}

# Function to check if setup is needed
check_setup_needed() {
    # Check if essential files exist
    if [ ! -f ".env" ] || [ ! -f "style.css" ] || [ ! -f "functions.php" ]; then
        return 0  # Setup needed
    else
        return 1  # Setup not needed
    fi
}

# Function to perform initial setup
perform_setup() {
    echo -e "${BLUE}WordPress Theme Development Setup${NC}"
    echo "======================================"

    # Check if we're in a WordPress themes directory
    if [[ ! -d "../twentytwentythree" && ! -d "../twentytwentyfour" ]]; then
        if ! ask_yes_no "Warning: This doesn't seem to be a WordPress themes directory. Continue anyway?"; then
            exit 1
        fi
    fi

    # Ask about TreeTamer installation
    if ask_yes_no "Would you like to install TreeTamer for project structure management?"; then
        echo -e "${YELLOW}Installing TreeTamer...${NC}"
        download_file "https://raw.githubusercontent.com/gbechtold/TreeTamer/main/treetamer.sh" "treetamer.sh"
        chmod +x treetamer.sh
        echo -e "${GREEN}TreeTamer installed successfully!${NC}"
    fi

    # Download .gitignore
    if [ ! -f ".gitignore" ] && ask_yes_no "Would you like to download a WordPress-optimized .gitignore?"; then
        echo -e "${YELLOW}Downloading .gitignore...${NC}"
        download_file "https://raw.githubusercontent.com/github/gitignore/master/WordPress.gitignore" ".gitignore"
        echo "
# Theme specific
.env
*.log
/backups/
.DS_Store" >> .gitignore
        echo -e "${GREEN}.gitignore created successfully!${NC}"
    fi

    # Generate .env file
    if [ ! -f ".env" ] && ask_yes_no "Would you like to generate a .env file?"; then
        echo -e "${YELLOW}Generating .env file...${NC}"
        read -p "Enter FTP host (e.g., example.com): " ftp_host
        read -p "Enter FTP username: " ftp_user
        read -sp "Enter FTP password: " ftp_pass
        echo ""
        read -p "Enter theme name: " theme_name
        read -p "Enter remote path (e.g., /public_html/wp-content/themes/your-theme): " remote_path
        
        cat > .env << EOL
# FTP Configuration
FTP_HOST=${ftp_host}
FTP_USER=${ftp_user}
FTP_PASS=${ftp_pass}
FTP_PORT=21

# Theme Configuration
THEME_NAME=${theme_name}
REMOTE_PATH=${remote_path}

# Backup Configuration
ENABLE_BACKUPS=true
BACKUP_DIR=../backups
KEEP_BACKUPS=5

# Debug Mode (true/false)
DEBUG=false
EOL
        echo -e "${GREEN}.env file generated successfully!${NC}"
    fi

    # Create basic directory structure
    echo -e "${YELLOW}Creating directory structure...${NC}"
    mkdir -p {assets,elements,template-parts}

    # Create basic theme files if they don't exist
    if [ ! -f "style.css" ]; then
        read -p "Enter theme name [Bricks Child Theme]: " theme_name
        theme_name=${theme_name:-"Bricks Child Theme"}
        read -p "Enter your name [Your Name]: " author_name
        author_name=${author_name:-"Your Name"}
        read -p "Enter your website [https://yourwebsite.com]: " author_uri
        author_uri=${author_uri:-"https://yourwebsite.com"}
        
        cat > style.css << EOL
/*
Theme Name: ${theme_name}
Theme URI: https://bricksbuilder.io/
Description: A theme built with Bricks Builder
Author: ${author_name}
Author URI: ${author_uri}
Template: bricks
Version: 1.0
License: GNU General Public License v2 or later
License URI: http://www.gnu.org/licenses/gpl-2.0.html
Text Domain: bricks-child
*/
EOL
    fi

    if [ ! -f "functions.php" ]; then
        cat > functions.php << EOL
<?php
/**
 * Theme Functions
 */

// Enqueue parent theme style
add_action('wp_enqueue_scripts', function() {
    if (!bricks_is_builder_main()) {
        wp_enqueue_style(
            'bricks-child', 
            get_stylesheet_uri(), 
            ['bricks-frontend'], 
            filemtime(get_stylesheet_directory() . '/style.css')
        );
    }
});

// Register custom elements directory
add_action('init', function() {
    \$element_files = glob(__DIR__ . '/elements/*.php');
    
    foreach (\$element_files as \$file) {
        \Bricks\Elements::register_element(\$file);
    }
}, 11);
EOL
    fi

    echo -e "${GREEN}Setup completed successfully!${NC}"
}

# Function to parse .gitignore and create rsync exclude patterns
create_exclude_patterns() {
    local exclude_file="$TEMP_DIR/exclude-patterns.txt"
    
    # Start with default excludes
    cat > "$exclude_file" << EOL
.git
.gitignore
*/.gitignore
node_modules
.env*
deploy.sh
.DS_Store
*/.DS_Store
treetamer.sh
readme.md
EOL

    # If .gitignore exists, append its contents
    if [ -f ".gitignore" ]; then
        # Process .gitignore and append to exclude file
        # Remove comments and empty lines, and format for rsync
        grep -v '^#' .gitignore | grep -v '^\s*$' >> "$exclude_file"
    fi
    
    echo "$exclude_file"
}

# Function to copy files while respecting exclusions
copy_with_exclusions() {
    local source_dir="$1"
    local target_dir="$2"
    local exclude_file="$3"
    
    # Create temporary directory for filtered content
    mkdir -p "$target_dir"
    
    # Use rsync to copy files while excluding patterns
    rsync -a --exclude-from="$exclude_file" "$source_dir/" "$target_dir/"
}

# Function to deploy via FTP
deploy_ftp() {
    echo -e "${BLUE}Deploying to FTP...${NC}"
    
    # Create temporary directories
    TEMP_DIR=$(mktemp -d)
    FILTERED_DIR="$TEMP_DIR/filtered"
    
    # Create exclude patterns file
    EXCLUDE_FILE=$(create_exclude_patterns)
    
    echo -e "${YELLOW}Creating filtered copy of theme...${NC}"
    copy_with_exclusions "." "$FILTERED_DIR" "$EXCLUDE_FILE"
    
    echo -e "${YELLOW}Uploading files to FTP server...${NC}"
    # Upload files
    lftp -c "
        set ftp:ssl-allow no;
        open -u $FTP_USER,$FTP_PASS $FTP_HOST;
        lcd $FILTERED_DIR;
        cd $REMOTE_PATH;
        mirror --reverse --delete --verbose
    "
    
    # Cleanup
    cd - > /dev/null
    rm -rf "$TEMP_DIR"
    
    echo -e "${GREEN}Deployment completed successfully!${NC}"
}

# Function to validate environment variables
validate_env() {
    # Check for required commands
    local required_commands=("rsync" "lftp")
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            echo -e "${RED}Error: Required command '$cmd' is not installed${NC}"
            echo "Please install it using your package manager"
            exit 1
        fi
    done

    if [ ! -f ".env" ]; then
        echo -e "${RED}Error: .env file not found!${NC}"
        echo "Please run the setup first: ./deploy.sh --setup"
        exit 1
    fi

    source .env

    local required_vars=("FTP_HOST" "FTP_USER" "FTP_PASS" "THEME_NAME" "REMOTE_PATH")
    local missing_vars=()

    for var in "${required_vars[@]}"; do
        if [ -z "${!var}" ]; then
            missing_vars+=("$var")
        fi
    done

    if [ ${#missing_vars[@]} -ne 0 ]; then
        echo -e "${RED}Error: Missing required environment variables:${NC}"
        printf '%s\n' "${missing_vars[@]}"
        exit 1
    fi
}

# Function to create backup
create_backup() {
    if [ "$ENABLE_BACKUPS" = true ]; then
        echo -e "${BLUE}Creating backup...${NC}"
        
        mkdir -p "$BACKUP_DIR"
        TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
        BACKUP_FILE="$BACKUP_DIR/${THEME_NAME}_${TIMESTAMP}.zip"
        
        zip -r "$BACKUP_FILE" . -x "node_modules/*" ".git/*" "$BACKUP_DIR/*"
        
        if [ ! -z "$KEEP_BACKUPS" ]; then
            echo "Cleaning up old backups..."
            ls -t "$BACKUP_DIR"/*.zip | tail -n +$((KEEP_BACKUPS + 1)) | xargs -r rm
        fi
        
        echo -e "${GREEN}Backup created: $BACKUP_FILE${NC}"
    fi
}

# Main execution
case "$1" in
    --setup)
        perform_setup
        ;;
    --deploy)
        validate_env
        create_backup
        deploy_ftp
        ;;
    *)
        if check_setup_needed; then
            echo -e "${YELLOW}Initial setup required. Running setup...${NC}"
            perform_setup
        else
            validate_env
            create_backup
            deploy_ftp
        fi
        ;;
esac

# Show next steps if setup was performed
if [ "$1" = "--setup" ] || check_setup_needed; then
    echo -e "\nNext steps:"
    echo -e "1. Review ${BLUE}.env${NC} settings if you created one"
    echo -e "2. Customize ${BLUE}style.css${NC} and ${BLUE}functions.php${NC}"
    echo -e "3. Add custom elements in the ${BLUE}elements/${NC} directory"
    echo -e "4. Run ${BLUE}./deploy.sh${NC} to deploy your theme\n"
fi
