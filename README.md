# WP-Theme-Dev

A professional WordPress theme development toolkit focused on efficiency and clean deployment, optimized for Bricks Builder child themes.

## 🚀 Features

- Automated FTP deployment with smart file filtering
- Intelligent `.gitignore` handling for clean deployments
- Backup management with rotation
- Custom elements support for Bricks Builder
- Environment-based configuration
- Development workflow optimization
- Clean project structure
- Secure credential management

## 📋 Requirements

- WordPress 6.0+
- Bricks Builder 1.8+
- PHP 7.4+
- Required tools:
  - `rsync`
  - `lftp`
  - `curl` or `wget`

## 🛠️ Installation

1. Navigate to your WordPress themes directory:
   ```bash
   cd wp-content/themes/
   ```

2. Create your child theme directory:
   ```bash
   mkdir your-child-theme && cd your-child-theme
   ```

3. Download and run the setup script:
   ```bash
   curl -O https://raw.githubusercontent.com/gbechtold/WP-Theme-Dev/main/deploy.sh && chmod +x deploy.sh
   ```

4. Run initial setup:
   ```bash
   ./deploy.sh --setup
   ```

## 📁 Project Structure

```
your-child-theme/
├── .env                 # Configuration (auto-generated)
├── .gitignore          # Version control exclusions
├── assets/             # Theme assets (images, fonts, etc.)
├── elements/           # Custom Bricks elements
├── template-parts/     # Reusable template parts
├── deploy.sh           # Deployment script
├── functions.php       # Theme functions
├── style.css          # Theme information and styles
└── README.md          # Documentation
```

## 🔧 Configuration

During setup, you'll be prompted for:
- FTP host, username, and password
- Theme name and details
- Remote deployment path
- Backup preferences

These settings are stored in `.env`:
```bash
# FTP Configuration
FTP_HOST=your-domain.com
FTP_USER=your-username
FTP_PASS=your-password
FTP_PORT=21

# Theme Configuration
THEME_NAME=your-theme-name
REMOTE_PATH=/public_html/wp-content/themes/your-theme

# Backup Configuration
ENABLE_BACKUPS=true
BACKUP_DIR=../backups
KEEP_BACKUPS=5
```

## 📤 Deployment

Deploy your theme:
```bash
./deploy.sh --deploy
```

The deployment script:
1. Creates a backup (if enabled)
2. Parses your `.gitignore` for exclusions
3. Filters out development files
4. Uploads clean files to your FTP server

### Excluded Files
The following files are automatically excluded from deployment:
- All patterns from `.gitignore`
- Development files (`.git`, `node_modules`, etc.)
- Configuration files (`.env`, `deploy.sh`)
- Documentation files (`readme.md`)
- System files (`.DS_Store`)

## 🧩 Custom Elements

Add custom Bricks elements in the `elements/` directory:

```php
class Element_Custom_Title extends \Bricks\Element {
    public $category = 'custom';
    public $name = 'custom-title';
    public $icon = 'fas fa-heading';
    
    public function get_label() {
        return esc_html__('Custom Title', 'bricks');
    }
}
```

## 🔒 Security

- FTP credentials are stored locally in `.env`
- Sensitive files are automatically excluded from deployment
- Backups are stored outside the public directory
- Development files never reach production
- Clean separation of development and production environments

## 🛟 Support

For issues and feature requests:
1. Check the [issues page](https://github.com/gbechtold/WP-Theme-Dev/issues)
2. Open a new issue if needed
3. Provide detailed information about your problem

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add: Amazing Feature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

Distributed under the MIT License. See `LICENSE` for more information.
