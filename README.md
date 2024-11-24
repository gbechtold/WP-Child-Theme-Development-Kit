# 🎨 WordPress Child Theme Development Kit

A streamlined toolkit for WordPress child theme development, optimized for use with Bricks Builder.

## ⚡ Quick Install

```bash
curl -s https://raw.githubusercontent.com/your-username/wp-child-dev/main/install.sh | bash
```

## 🌟 Features

- Automated FTP deployment with smart file exclusion
- Backup management with rotation
- Custom elements support for Bricks Builder
- Development workflow optimization
- Environment-based configuration
- Intelligent .gitignore parsing
- Clean project structure
- Secure credential management

## 📋 Prerequisites

- WordPress 6.0+
- Bricks Builder 1.8+
- PHP 7.4+
- Local development environment
- FTP access to your production server
- Required tools:
  - `rsync`
  - `lftp`
  - `curl` or `wget`

## 🗂️ Project Structure

```
your-child-theme/
├── .env                 # Configuration (created from setup)
├── .gitignore          # Version control exclusions
├── assets/             # Theme assets (images, fonts, etc.)
├── elements/           # Custom Bricks elements
├── template-parts/     # Reusable template parts
├── deploy.sh           # Deployment script
├── functions.php       # Theme functions
├── style.css          # Theme information and styles
└── README.md          # Documentation
```

## 🛠️ Setup & Usage

1. **Initial Setup**
   ```bash
   ./deploy.sh --setup
   ```
   This will:
   - Create necessary directories
   - Generate configuration files
   - Set up deployment settings
   - Configure backup options

2. **Configuration**
   - During setup, you'll be prompted for:
     - FTP credentials
     - Theme details
     - Deployment paths
     - Backup preferences

3. **Development**
   - Add custom elements in `/elements/`
   - Add template parts in `/template-parts/`
   - Add assets in `/assets/`
   - Modify `style.css` for theme styles
   - Update `functions.php` for custom functionality

4. **Deployment**
   ```bash
   ./deploy.sh --deploy
   ```
   This will:
   - Create a backup (if enabled)
   - Parse .gitignore for exclusions
   - Filter out development files
   - Deploy to FTP server
   - Maintain clean production environment

## 📚 Custom Elements

Add custom Bricks elements in the `elements/` directory:

```php
class Element_Custom_Title extends \Bricks\Element {
    public $category = 'custom';
    public $name = 'custom-title';
    public $icon = 'fas fa-heading';
    
    public function get_label() {
        return esc_html__('Custom Title', 'bricks');
    }
    
    // Add your element logic here
}
```

## 🔒 Security

- FTP credentials are stored locally in `.env`
- Sensitive files are automatically excluded from deployment
- Backups are stored outside the public directory
- Development files are never uploaded to production

## 📝 License

Distributed under the MIT License. See `LICENSE` for more information.

## 🆘 Support

For issues and feature requests, please [open an issue](https://github.com/your-username/wp-child-dev/issues) on GitHub.
