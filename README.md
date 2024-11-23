# 🎨 WP Theme Dev

A streamlined toolkit for WordPress theme development, optimized for Bricks Builder with automated setup, deployment, and project management features.

## ⚡ Quick Start

```bash
curl -s https://raw.githubusercontent.com/gbechtold/WP-Theme-Dev/main/deploy.sh > deploy.sh && chmod +x deploy.sh && ./deploy.sh
```

## 🌟 Features

- 🚀 One-script solution for setup and deployment
- 📦 Automated FTP deployment with backup rotation
- 🌳 Optional TreeTamer integration for project structure management
- 🔒 Secure environment handling
- 📁 WordPress-optimized .gitignore
- 🛠️ Custom Bricks elements support
- 🔄 Development workflow optimization
- 🎯 Clean project structure

## 📋 Prerequisites

- WordPress 6.0+
- Bricks Builder 1.8+
- PHP 7.4+
- FTP access to your production server
- Git (optional, for version control)
- Local development environment (e.g., Local by Flywheel)

## 🚀 Usage

The `deploy.sh` script handles both setup and deployment:

```bash
# Auto-detect and run what's needed
./deploy.sh

# Run setup only
./deploy.sh --setup

# Run deployment only
./deploy.sh --deploy
```

### Initial Setup

The setup process will guide you through:
1. TreeTamer installation (optional)
2. WordPress-optimized .gitignore creation
3. Environment configuration (.env)
4. Basic theme structure setup
5. Theme file generation (style.css, functions.php)

### Deployment

The deployment process includes:
1. Environment validation
2. Automatic backup creation (configurable)
3. FTP deployment with cleanup
4. Backup rotation management

## 📁 Project Structure

```
your-theme/
├── .gitignore         # Git ignore rules
├── .env               # Configuration (created during setup)
├── assets/           # Theme assets
│   ├── css/         # Stylesheets
│   ├── js/          # JavaScript files
│   └── images/      # Image assets
├── elements/         # Custom Bricks elements
├── template-parts/   # Reusable template parts
├── deploy.sh         # Setup & deployment script
├── functions.php     # Theme functions
├── style.css        # Theme information
└── README.md        # Documentation
```

## ⚙️ Configuration

The `.env` file (created during setup) contains:

```bash
# FTP Configuration
FTP_HOST=your-domain.com
FTP_USER=your-username
FTP_PASS=your-password
FTP_PORT=21

# Theme Configuration
THEME_NAME=your-theme
REMOTE_PATH=/public_html/wp-content/themes/your-theme

# Backup Configuration
ENABLE_BACKUPS=true
BACKUP_DIR=../backups
KEEP_BACKUPS=5

# Debug Mode
DEBUG=false
```

## 🔄 Development Workflow

1. **Initial Setup**
   ```bash
   # Navigate to your theme directory
   cd wp-content/themes/your-theme

   # Download and run deploy.sh
   curl -s https://raw.githubusercontent.com/gbechtold/WP-Theme-Dev/main/deploy.sh > deploy.sh && chmod +x deploy.sh && ./deploy.sh
   ```

2. **Local Development**
   - Make changes to your theme files
   - Test changes locally in your WordPress environment
   - Use TreeTamer (if installed) to analyze project structure

3. **Deployment**
   ```bash
   # Deploy changes to production
   ./deploy.sh --deploy
   ```

## 🛠️ Custom Elements

Add custom Bricks elements in the `elements/` directory:

```php
class Element_Custom_Title extends \Bricks\Element {
    public $category = 'custom';
    public $name = 'custom-title';
    public $icon = 'fas fa-heading';
    // ... element code
}
```

## 🔄 GitHub Actions Integration

This repository includes automated workflows for:
- Code quality checks
- Deployment testing
- Release automation
- Documentation updates

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add: Amazing Feature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 🚀 Release Process

Create a new release:
```bash
git tag -a v1.x.x -m "Release description"
git push origin v1.x.x
```

## 📝 License

Distributed under the MIT License. See `LICENSE` for more information.

## 🆘 Support

For issues and feature requests:
- Open an [issue](https://github.com/gbechtold/WP-Theme-Dev/issues)
- Check the [discussions](https://github.com/gbechtold/WP-Theme-Dev/discussions)

## ⚡ Related Projects

- [TreeTamer](https://github.com/gbechtold/TreeTamer) - Project structure management tool

## 📝 Version History

- 1.0.0
  - Initial release
  - Unified deploy script
  - Automated setup and deployment
  - TreeTamer integration
  - Backup management