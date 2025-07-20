# SPECTRUM01 System Cleaner 🧹

A comprehensive Linux home directory cleaning utility that removes temporary files, caches, and logs while preserving important user data and browser account information.

## Features

### 🎯 **Smart Cleaning**
- **Browser Cache Cleaning** - Removes cache while preserving profiles, bookmarks, and login data
- **Development Tool Cleanup** - Cleans NPM, Yarn, pip, Gradle, Maven, Go, Rust, and Composer caches
- **IDE Cache Removal** - Cleans JetBrains, VS Code, Visual Studio, and Sublime Text caches
- **System Cache Cleanup** - Removes thumbnails, recent files, and application caches
- **Python Optimization** - Removes `__pycache__` directories and `.pyc` files

### 🛡️ **Safety Features**
- **No sudo required** - Only cleans user-accessible files
- **Data preservation** - Protects browser profiles, SSH keys, and application settings
- **Path validation** - Prevents deletion of critical system directories
- **Size reporting** - Shows space usage before cleanup
- **Interactive prompts** - Asks for confirmation on sensitive operations

### 🎨 **Multiple Operation Modes**
- **Full Cleanup** - Complete system cleaning (default)
- **Custom Path Cleanup** - Remove specific files or directories
- **Help Mode** - Display usage information

## Installation

1. **Download the script:**
   ```bash
   wget https://raw.githubusercontent.com/ulyildiz/Spectrum01-cleaner/main/spectrum01-cleaner.sh
   # or
   curl -O https://raw.githubusercontent.com/ulyildiz/Spectrum01-cleaner/main/spectrum01-cleaner.sh
   ```

   **Alternative: Clone the repository:**
   ```bash
   git clone https://github.com/ulyildiz/Spectrum01-cleaner.git
   cd Spectrum01-cleaner
   ```

2. **Make it executable:**
   ```bash
   chmod +x spectrum01-cleaner.sh
   ```

3. **Optional: Setup global alias:**
   ```bash
   ./spectrum01-cleaner.sh setup
   ```

## Alias Setup

The script can add itself as a convenient alias to your shell configuration.

### Quick Setup
```bash
./clean.sh setup
```

### Alias Options
When running setup, you can choose from several alias names:

| Option | Alias Name | Usage Example |
|--------|------------|---------------|
| 1 | `spectrum-clean` | `spectrum-clean addpath` |
| 2 | `clean` | `clean addpath` |
| 3 | `sc` | `sc addpath` |
| 4 | Custom | `myalias addpath` |

### After Setup
Once the alias is configured, you can use it from anywhere:

```bash
# Instead of ./clean.sh
spectrum-clean              # Full cleanup
spectrum-clean addpath      # Custom path cleanup
spectrum-clean help         # Show help

# Or with shorter aliases
clean                       # Full cleanup
sc addpath                  # Custom path cleanup
```

The alias setup will:
- ✅ Add the alias to your `~/.zshrc` file
- ✅ Check for existing aliases and offer to update them
- ✅ Validate custom alias names
- ✅ Offer to reload your shell configuration immediately

## Usage

### Basic Commands

```bash
# Run full system cleanup
./spectrum01-cleaner.sh

# Clean custom paths only
./spectrum01-cleaner.sh addpath

# Setup global alias
./spectrum01-cleaner.sh setup

# Show help information
./spectrum01-cleaner.sh help
```

### Command Options

| Command | Description |
|---------|-------------|
| `./spectrum01-cleaner.sh` | Run complete home directory cleanup |
| `./spectrum01-cleaner.sh addpath` | Interactive custom path removal |
| `./spectrum01-cleaner.sh setup` | Add global alias to ~/.zshrc |
| `./spectrum01-cleaner.sh help` | Display help and usage information |

## What Gets Cleaned

### 🌐 **Browser Caches (Account Data Preserved)**
- **Firefox**: Cache2, startup cache, offline cache, shader cache
- **Chrome/Chromium**: Default cache, code cache, GPU cache
- **Brave**: All caches while preserving sync and account data
- **Edge**: Default cache, code cache, GPU cache
- **Opera**: Cache and code cache

### 💻 **Development Tools**
- **Node.js**: NPM cache (`~/.npm/_cacache`), Yarn cache
- **Python**: pip cache, `__pycache__` directories, `.pyc` files
- **Java**: Gradle cache, Maven repository cache
- **Go**: Build cache, modules cache
- **Rust**: Cargo registry cache
- **PHP**: Composer cache

### 🎯 **IDE & Editors**
- **JetBrains**: IDE caches for IntelliJ, PyCharm, WebStorm, etc.
- **VS Code**: Logs, cached extensions, workspace storage, C++ tools cache
- **Visual Studio**: MonoDevelop cache, .NET template cache, NuGet packages
- **Sublime Text**: Application cache

### 🗂️ **System Files**
- **Temporary files**: `~/tmp`, `~/.tmp`, `~/.cache`
- **Thumbnails**: Image and video thumbnails
- **Trash**: Deleted files and metadata
- **Recent files**: Recently used file history
- **Log files**: X session errors, application logs
- **Core dumps**: Crash files and reports

### 🎮 **Applications**
- **LibreOffice**: Document cache and registry cache
- **Media Players**: VLC, Rhythmbox, Totem caches
- **Steam**: Log files and cache
- **Flatpak**: User app caches
- **Wine**: Cache and temporary files (if installed)

## Interactive Features

### 📁 **Custom Path Cleanup**
When using `./spectrum01-cleaner.sh addpath`, you can:

1. **Add multiple paths** by entering them one by one
2. **Use tilde expansion** (`~/Documents/old_project`)
3. **Choose deletion method** for directories:
   - **Option 1**: Delete entire directory
   - **Option 2**: Clean contents only (preserve directory)
4. **Preview file sizes** before deletion
5. **Confirm each action** before proceeding

### 🔒 **Safety Protections**
The script prevents deletion of:
- System directories (`/`, `/bin`, `/usr`, `/etc`, etc.)
- Entire home directory
- Critical application data
- SSH keys and certificates

## Output Example

```bash
███████╗██████╗ ███████╗ ██████╗████████╗██████╗ ██╗   ██╗███╗   ███╗ ██████╗  ██╗
██╔════╝██╔══██╗██╔════╝██╔════╝╚══██╔══╝██╔══██╗██║   ██║████╗ ████║██╔═████╗███║
███████╗██████╔╝█████╗  ██║        ██║   ██████╔╝██║   ██║██╔████╔██║██║██╔██║╚██║
╚════██║██╔═══╝ ██╔══╝  ██║        ██║   ██╔══██╗██║   ██║██║╚██╔╝██║████╔╝██║ ██║
███████║██║     ███████╗╚██████╗   ██║   ██║  ██║╚██████╔╝██║ ╚═╝ ██║╚██████╔╝ ██║
╚══════╝╚═╝     ╚══════╝ ╚═════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝ ╚═════╝  ╚═╝

                          🧹 SYSTEM CLEANER UTILITY 🧹
                        Home Directory Cleanup Script

[INFO] 🧹 Starting home directory cleanup...
📊 Initial home directory usage: 2.1G

[INFO] === Cleaning Browser Caches (Preserving Account Data) ===
[INFO] Cleaning Firefox cache (45M)...
[SUCCESS] Removed Firefox cache
[INFO] Cleaning Chrome cache (128M)...
[SUCCESS] Removed Chrome cache

...

[SUCCESS] === 🎉 Cleanup Complete! ===
📊 Initial home directory usage: 2.1G
📊 Final home directory usage:   1.6G
```

## Requirements

- **Linux operating system**
- **Bash shell**
- **Standard Unix utilities** (find, du, rm, etc.)
- **No sudo privileges required**

## Compatibility

Tested on:
- ✅ Ubuntu 20.04+
- ✅ Debian 11+
- ✅ Fedora 35+
- ✅ Arch Linux
- ✅ openSUSE

## Best Practices

### 🕐 **Regular Maintenance**
- Run monthly for optimal system performance
- Use `./spectrum01-cleaner.sh addpath` for project-specific cleanups
- Monitor disk usage with `ncdu` or `du -sh ~/*`

### 🔍 **Before Running**
- Close all applications to ensure complete cache cleanup
- Review what will be cleaned if running for the first time
- Consider backing up important development caches if needed

### 📊 **After Running**
- Note space freed for future reference
- Clear browser downloads manually if needed
- Remove old project directories periodically

## Troubleshooting

### Common Issues

**Permission Denied Errors:**
```bash
# Make sure the script is executable
chmod +x clean.sh
```

**Path Not Found:**
```bash
# Use absolute paths or proper tilde expansion
~/Documents/project  # ✅ Good
./Documents/project  # ❌ May not work
```

**Cache Reappears Quickly:**
- This is normal - applications recreate caches during use
- Focus on cleaning old, large cache files
- Run cleanup after major development sessions

## Examples

### Basic Usage
```bash
# First-time setup
./spectrum01-cleaner.sh setup                    # Add alias to shell
source ~/.zshrc                     # Reload shell config

# Daily usage with alias
spectrum-clean                      # Full cleanup
clean                              # Full cleanup (shorter alias)
sc                                 # Ultra-short alias

# Specific tasks
spectrum-clean addpath             # Clean specific directories
./spectrum01-cleaner.sh help                    # Get help (works with or without alias)
```

### Custom Path Cleanup Workflow
```bash
# Start custom path cleanup
sc addpath

# Enter paths one by one:
# ~/old_projects/defunct_app
# ~/Downloads/large_files
# ~/.local/share/old_app_cache
# done

# Choose options for directories:
# 1) Delete entire directory
# 2) Clean contents only
```

### Real-World Usage Examples
```bash
# Weekly maintenance
spectrum-clean                     # Clean everything

# Before important work
clean addpath                      # Remove project-specific clutter

# After development session
sc                                 # Quick cleanup

# Setting up new machine
./spectrum01-cleaner.sh setup                  # Add convenient alias
```

## Contributing

Feel free to submit issues and enhancement requests!

### Adding New Cache Locations
1. Identify the cache directory
2. Add it to the appropriate section in the script
3. Use the `safe_remove` function for files/directories
4. Use `clean_directory_contents` to preserve directory structure

## License

This project is released under the MIT License. See LICENSE file for details.

## Changelog

### v1.1.0
- **Added alias setup functionality** (`./clean.sh setup`)
- **Multiple alias options**: spectrum-clean, clean, sc, or custom names
- **Enhanced custom path cleanup** with directory vs contents options
- **Improved interactive prompts** and user experience
- **Updated documentation** with comprehensive examples

### v1.0.0
- Initial release with comprehensive cleaning features
- Added custom path cleanup functionality
- Implemented safety protections
- Added multiple operation modes

---

**⚡ SPECTRUM01** - Keeping your Linux system clean and efficient!
