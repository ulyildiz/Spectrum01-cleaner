#!/bin/bash

# Display Spectrum01 header
clear
echo -e "\033[1;36m"
echo "███████╗██████╗ ███████╗ ██████╗████████╗██████╗ ██╗   ██╗███╗   ███╗ ██████╗  ██╗"
echo "██╔════╝██╔══██╗██╔════╝██╔════╝╚══██╔══╝██╔══██╗██║   ██║████╗ ████║██╔═████╗███║"
echo "███████╗██████╔╝█████╗  ██║        ██║   ██████╔╝██║   ██║██╔████╔██║██║██╔██║╚██║"
echo "╚════██║██╔═══╝ ██╔══╝  ██║        ██║   ██╔══██╗██║   ██║██║╚██╔╝██║████╔╝██║ ██║"
echo "███████║██║     ███████╗╚██████╗   ██║   ██║  ██║╚██████╔╝██║ ╚═╝ ██║╚██████╔╝ ██║"
echo "╚══════╝╚═╝     ╚══════╝ ╚═════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝ ╚═════╝  ╚═╝"
echo -e "\033[0m"
echo -e "\033[1;32m                          🧹 SYSTEM CLEANER UTILITY 🧹\033[0m"
echo -e "\033[1;33m                        Home Directory Cleanup Script\033[0m"
echo ""

# Home Directory Cleaning Script for Linux
# Removes temporary files, cache, and logs from user's home directory
# No sudo privileges required - only cleans user-accessible files

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to get directory size in human readable format
get_size() {
    if [ -d "$1" ] || [ -f "$1" ]; then
        du -sh "$1" 2>/dev/null | cut -f1
    else
        echo "0B"
    fi
}

# Function to safely remove files/directories
safe_remove() {
    local path="$1"
    local description="$2"
    
    if [ -e "$path" ]; then
        local size=$(get_size "$path")
        print_info "Cleaning $description ($size)..."
        rm -rf "$path" 2>/dev/null && print_success "Removed $description" || print_warning "Could not remove $description"
    fi
}

# Function to clean directory contents but keep the directory
clean_directory_contents() {
    local path="$1"
    local description="$2"
    
    if [ -d "$path" ]; then
        local size=$(get_size "$path")
        print_info "Cleaning $description contents ($size)..."
        find "$path" -mindepth 1 -delete 2>/dev/null && print_success "Cleaned $description" || print_warning "Could not clean $description"
    fi
}

# Function for user to add custom paths to remove
custom_path_cleanup() {
    print_info "=== Custom Path Cleanup ==="
    echo -e "${YELLOW}You can specify custom files or directories to remove.${NC}"
    echo -e "${YELLOW}Enter paths one by one (press Enter after each). Type 'done' when finished.${NC}"
    echo -e "${RED}⚠️  WARNING: Be careful with paths! Files will be permanently deleted.${NC}"
    echo ""
    
    local custom_paths=()
    local path_input
    
    while true; do
        read -p "Enter path to remove (or 'done' to finish): " path_input
        
        if [ "$path_input" = "done" ] || [ "$path_input" = "DONE" ]; then
            break
        fi
        
        # Skip empty input
        if [ -z "$path_input" ]; then
            continue
        fi
        
        # Expand tilde to home directory
        path_input="${path_input/#\~/$HOME}"
        
        # Security check - don't allow certain dangerous paths
        case "$path_input" in
            "/" | "/bin" | "/sbin" | "/usr" | "/etc" | "/var" | "/boot" | "/sys" | "/proc" | "/dev")
                print_error "Cannot remove system directory: $path_input"
                continue
                ;;
            "$HOME")
                print_error "Cannot remove entire home directory: $path_input"
                continue
                ;;
        esac
        
        # Check if path exists
        if [ -e "$path_input" ]; then
            local size=$(get_size "$path_input")
            echo -e "${BLUE}Found: $path_input ($size)${NC}"
            custom_paths+=("$path_input")
        else
            print_warning "Path does not exist: $path_input"
        fi
    done
    
    # Show summary and confirm
    if [ ${#custom_paths[@]} -eq 0 ]; then
        print_info "No custom paths specified."
        return
    fi
    
    echo ""
    print_info "Custom paths to remove:"
    for path in "${custom_paths[@]}"; do
        local size=$(get_size "$path")
        if [ -d "$path" ]; then
            echo "  📁 $path ($size) [DIRECTORY]"
        else
            echo "  📄 $path ($size) [FILE]"
        fi
    done
    
    echo ""
    read -p "Are you sure you want to process these paths? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Processing custom paths..."
        for path in "${custom_paths[@]}"; do
            if [ -d "$path" ]; then
                echo ""
                print_info "Processing directory: $path"
                echo "Options:"
                echo "  1) Delete entire directory"
                echo "  2) Clean contents only (keep directory)"
                read -p "Choose option (1/2): " -n 1 -r
                echo
                case $REPLY in
                    1)
                        safe_remove "$path" "directory: $(basename "$path")"
                        ;;
                    2)
                        clean_directory_contents "$path" "contents of: $(basename "$path")"
                        ;;
                    *)
                        print_warning "Invalid choice. Skipping $path"
                        ;;
                esac
            else
                # It's a file, just remove it
                safe_remove "$path" "file: $(basename "$path")"
            fi
        done
        print_success "Custom path cleanup completed!"
    else
        print_info "Custom path cleanup cancelled."
    fi
}

# Function to show help
show_help() {
    echo -e "${GREEN}SPECTRUM01 System Cleaner Utility${NC}"
    echo -e "${YELLOW}Usage: $0 [OPTION]${NC}"
    echo ""
    echo "Options:"
    echo -e "  ${BLUE}addpath${NC}    Run only the custom path cleanup"
    echo -e "  ${BLUE}setup${NC}      Add spectrum-clean alias to ~/.zshrc"
    echo -e "  ${BLUE}help${NC}       Show this help message"
    echo -e "  ${BLUE}(no args)${NC}  Run full system cleanup"
    echo ""
    echo "Examples:"
    echo "  $0              # Run complete cleanup"
    echo "  $0 addpath      # Only run custom path removal"
    echo "  $0 setup        # Setup global alias"
    echo "  $0 help         # Show this help"
}

# Function to setup alias in .zshrc
setup_alias() {
    local script_path="$(realpath "$0")"
    local zshrc_path="$HOME/.zshrc"
    local alias_name=""
    
    print_info "=== Setting up SPECTRUM01 alias ==="
    echo -e "${YELLOW}This will add an alias to your ~/.zshrc file${NC}"
    echo ""
    
    # Ask for alias name
    echo -e "${BLUE}Choose alias name:${NC}"
    echo "1) spectrum-clean (default)"
    echo "2) clean"
    echo "3) sc"
    echo "4) Custom name"
    echo ""
    read -p "Select option (1-4) [1]: " -n 1 -r
    echo ""
    
    case ${REPLY:-1} in
        1)
            alias_name="spectrum-clean"
            ;;
        2)
            alias_name="clean"
            ;;
        3)
            alias_name="sc"
            ;;
        4)
            echo ""
            read -p "Enter custom alias name: " alias_name
            # Validate custom alias name
            if [[ -z "$alias_name" ]] || [[ "$alias_name" =~ [[:space:]] ]] || [[ "$alias_name" =~ [^a-zA-Z0-9_-] ]]; then
                print_error "Invalid alias name. Using default 'spectrum-clean'"
                alias_name="spectrum-clean"
            fi
            ;;
        *)
            alias_name="spectrum-clean"
            ;;
    esac
    
    local alias_line="alias $alias_name='$script_path'"
    
    echo ""
    print_info "Selected alias: ${GREEN}$alias_name${NC}"
    print_info "Points to: ${BLUE}$script_path${NC}"
    echo ""
    
    # Check if .zshrc exists
    if [ ! -f "$zshrc_path" ]; then
        print_warning ".zshrc file not found. Creating new one..."
        touch "$zshrc_path"
    fi
    
    # Check if alias already exists
    if grep -q "alias $alias_name=" "$zshrc_path" 2>/dev/null; then
        print_warning "Alias '$alias_name' already exists in .zshrc"
        echo ""
        read -p "Do you want to update it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Remove existing alias
            sed -i "/alias $alias_name=/d" "$zshrc_path"
            print_success "Removed existing alias"
        else
            print_info "Setup cancelled. Alias unchanged."
            return 0
        fi
    fi
    
    # Final confirmation
    read -p "Add alias '$alias_name' to ~/.zshrc? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Setup cancelled."
        return 0
    fi
    
    # Add the alias
    echo "" >> "$zshrc_path"
    echo "# SPECTRUM01 System Cleaner Alias" >> "$zshrc_path"
    echo "$alias_line" >> "$zshrc_path"
    
    print_success "Alias added to ~/.zshrc!"
    echo ""
    print_info "Usage after restart or running 'source ~/.zshrc':"
    echo -e "  ${GREEN}$alias_name${NC}          # Run full cleanup"
    echo -e "  ${GREEN}$alias_name addpath${NC}  # Run custom path cleanup"
    echo -e "  ${GREEN}$alias_name help${NC}     # Show help"
    echo ""
    
    read -p "Do you want to reload .zshrc now? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ -n "$ZSH_VERSION" ]; then
            source "$zshrc_path"
            print_success "Reloaded .zshrc! You can now use '$alias_name' command."
        else
            print_info "Please run 'source ~/.zshrc' or restart your terminal to use the alias."
        fi
    else
        print_info "Please run 'source ~/.zshrc' or restart your terminal to use the alias."
    fi
}

# Main cleanup function
main_cleanup() {
    # Get initial home directory usage
    initial_usage=$(du -sh "$HOME" 2>/dev/null | cut -f1)

    print_info "🧹 Starting home directory cleanup..."
    echo "📊 Initial home directory usage: $initial_usage"
    echo

    # 1. User temporary files and cache
    print_info "=== Cleaning User Temporary Files ==="
    safe_remove "$HOME/.cache/thumbnails" "thumbnail cache"
    safe_remove "$HOME/.recently-used" "recently used files"
    safe_remove "$HOME/.local/share/recently-used.xbel" "recently used files (xbel)"
    safe_remove "$HOME/.local/share/Trash/files/*" "trash files"
    safe_remove "$HOME/.local/share/Trash/info/*" "trash info"
    safe_remove "$HOME/tmp" "user temp directory"
    safe_remove "$HOME/.tmp" "hidden temp directory"
    clean_directory_contents "$HOME/.cache" "user cache directory"

    # 2. Browser caches (preserving profiles and login data)
    print_info "=== Cleaning Browser Caches (Preserving Account Data) ==="

    # Firefox cache (but keep profiles and login data)
    for profile in "$HOME"/.mozilla/firefox/*/; do
        if [ -d "$profile" ]; then
            safe_remove "${profile}cache2" "Firefox cache2"
            safe_remove "${profile}startupCache" "Firefox startup cache"
            safe_remove "${profile}OfflineCache" "Firefox offline cache"
            safe_remove "${profile}shader-cache" "Firefox shader cache"
        fi
    done
    safe_remove "$HOME/.cache/mozilla" "Mozilla cache"

    # Chrome/Chromium cache (but keep profiles and login data)
    safe_remove "$HOME/.cache/google-chrome" "Chrome cache"
    safe_remove "$HOME/.cache/chromium" "Chromium cache"
    safe_remove "$HOME/.config/google-chrome/Default/Cache" "Chrome Default cache"
    safe_remove "$HOME/.config/google-chrome/Default/Code Cache" "Chrome Code cache"
    safe_remove "$HOME/.config/google-chrome/Default/GPUCache" "Chrome GPU cache"
    safe_remove "$HOME/.config/chromium/Default/Cache" "Chromium Default cache"
    safe_remove "$HOME/.config/chromium/Default/Code Cache" "Chromium Code cache"

    # Brave cache (preserving account data and settings)
    safe_remove "$HOME/.cache/BraveSoftware" "Brave cache"
    safe_remove "$HOME/.config/BraveSoftware/Brave-Browser/Default/Cache" "Brave Default cache"
    safe_remove "$HOME/.config/BraveSoftware/Brave-Browser/Default/Code Cache" "Brave Code cache"
    safe_remove "$HOME/.config/BraveSoftware/Brave-Browser/Default/GPUCache" "Brave GPU cache"
    safe_remove "$HOME/.config/BraveSoftware/Brave-Browser/Default/Service Worker/CacheStorage" "Brave Service Worker cache"

    # Edge cache
    safe_remove "$HOME/.config/microsoft-edge/Default/Cache" "Edge Default cache"
    safe_remove "$HOME/.config/microsoft-edge/Default/Code Cache" "Edge Code cache"
    safe_remove "$HOME/.config/microsoft-edge/Default/GPUCache" "Edge GPU cache"

    # Opera cache
    safe_remove "$HOME/.config/opera/Cache" "Opera cache"
    safe_remove "$HOME/.config/opera/Code Cache" "Opera Code cache"

    # 3. Development tool caches
    print_info "=== Cleaning Development Tool Caches ==="
    safe_remove "$HOME/.npm/_cacache" "NPM cache"
    safe_remove "$HOME/.yarn/cache" "Yarn cache"
    safe_remove "$HOME/.cache/pip" "Python pip cache"
    safe_remove "$HOME/.gradle/caches" "Gradle cache"
    safe_remove "$HOME/.m2/repository" "Maven repository cache"
    safe_remove "$HOME/.cache/go-build" "Go build cache"
    safe_remove "$HOME/.cargo/registry/cache" "Rust cargo cache"
    safe_remove "$HOME/.composer/cache" "PHP Composer cache"
    safe_remove "$HOME/go/pkg/mod/cache" "Go modules cache"

    # Clean Spotify cache
    safe_remove "$HOME/.cache/spotify" "Spotify cache"

    # Clean Python cache files
    print_info "Cleaning Python cache files..."
    find "$HOME" -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
    find "$HOME" -name "*.pyc" -delete 2>/dev/null || true

    # 4. IDE and editor caches  
    print_info "=== Cleaning IDE and Editor Caches ==="
    safe_remove "$HOME/.cache/JetBrains" "JetBrains IDE cache"
    safe_remove "$HOME/.vscode/logs" "VS Code logs"
    safe_remove "$HOME/.config/Code/logs" "VS Code logs (alternative path)"
    safe_remove "$HOME/.cache/sublime-text-3" "Sublime Text cache"
    safe_remove "$HOME/.cache/sublime-text" "Sublime Text cache (newer version)"

    # Visual Studio and Visual Studio Code caches
    print_info "=== Cleaning Visual Studio Caches ==="
    safe_remove "$HOME/.vscode/CachedExtensions" "VS Code cached extensions"
    safe_remove "$HOME/.vscode/User/workspaceStorage" "VS Code workspace storage"
    safe_remove "$HOME/.vscode/User/History" "VS Code history"
    safe_remove "$HOME/.config/Code/User/workspaceStorage" "VS Code workspace storage (alternative)"
    safe_remove "$HOME/.config/Code/User/History" "VS Code history (alternative)"
    safe_remove "$HOME/.config/Code/CachedExtensions" "VS Code cached extensions (alternative)"
    safe_remove "$HOME/.cache/vscode-cpptools" "VS Code C++ tools cache"
    safe_remove "$HOME/.cache/ms-vscode.cpptools" "VS Code C++ tools cache (alternative)"

    # Visual Studio (if using on Linux via Wine/MonoDevelop)
    safe_remove "$HOME/.cache/MonoDevelop-*" "MonoDevelop cache"
    safe_remove "$HOME/.config/MonoDevelop/cache" "MonoDevelop config cache"
    safe_remove "$HOME/.local/share/MonoDevelop/TempFiles" "MonoDevelop temp files"

    # .NET and related caches
    safe_remove "$HOME/.nuget/packages" "NuGet packages cache"
    safe_remove "$HOME/.dotnet/NuGetFallbackFolder" "NuGet fallback cache"
    safe_remove "$HOME/.templateengine" "dotnet template engine cache"

    # 5. User log files
    print_info "=== Cleaning User Log Files ==="
    safe_remove "$HOME/.xsession-errors*" "X session errors"
    safe_remove "$HOME/.local/share/xorg/Xorg.*.log*" "Xorg logs"
    clean_directory_contents "$HOME/.local/share/sddm" "SDDM logs"

    # 6. Application caches
    print_info "=== Cleaning Application Caches ==="

    # LibreOffice cache
    for libreoffice_dir in "$HOME"/.libreoffice/*/; do
        if [ -d "$libreoffice_dir" ]; then
            clean_directory_contents "${libreoffice_dir}cache" "LibreOffice cache"
        fi
    done
    safe_remove "$HOME/.config/libreoffice/*/registry/cache" "LibreOffice registry cache"

    # Media player caches
    safe_remove "$HOME/.cache/vlc" "VLC cache"
    clean_directory_contents "$HOME/.local/share/gvfs-metadata" "GVFS metadata"
    safe_remove "$HOME/.cache/rhythmbox" "Rhythmbox cache"
    safe_remove "$HOME/.cache/totem" "Totem cache"

    # Steam cache (if present)
    clean_directory_contents "$HOME/.steam/steam/logs" "Steam logs"
    clean_directory_contents "$HOME/.local/share/Steam/logs" "Steam logs (alternative)"

    # 7. Flatpak caches (user-level only)
    print_info "=== Cleaning User Flatpak Caches ==="
    if command -v flatpak &> /dev/null; then
        print_info "Cleaning user Flatpak cache..."
        clean_directory_contents "$HOME/.var/app/*/cache" "Flatpak app caches"
        clean_directory_contents "$HOME/.var/app/*/config/pulse" "Flatpak pulse configs"
    fi

    # 8. Wine cache (if installed)
    if [ -d "$HOME/.wine" ]; then
        print_info "=== Cleaning Wine Caches ==="
        safe_remove "$HOME/.cache/wine" "Wine cache"
        safe_remove "$HOME/.wine/drive_c/users/$(whoami)/Temp" "Wine temp files"
    fi

    # 9. Docker cleanup (user-level only, if installed)
    if command -v docker &> /dev/null; then
        print_info "=== Cleaning Docker (user-level) ==="
        # Only clean if user can run docker without sudo
        if docker ps &> /dev/null; then
            docker system prune -f 2>/dev/null && print_success "Docker system cleaned" || print_warning "Could not clean Docker system"
        else
            print_warning "Docker requires sudo privileges, skipping Docker cleanup"
        fi
    fi

    # 10. Core dumps and crash reports
    print_info "=== Cleaning Crash Files ==="
    safe_remove "$HOME/core" "core dump"
    safe_remove "$HOME/core.*" "core dump files"
    clean_directory_contents "$HOME/.local/share/apport" "crash reports"

    # 11. Clean old downloads (optional - be careful!)
    print_info "=== Checking Downloads Folder ==="
    if [ -d "$HOME/Downloads" ]; then
        old_files_count=$(find "$HOME/Downloads" -type f -mtime +30 2>/dev/null | wc -l)
        if [ "$old_files_count" -gt 0 ]; then
            print_info "Found $old_files_count files older than 30 days in Downloads"
            read -p "Do you want to remove files older than 30 days from Downloads? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                find "$HOME/Downloads" -type f -mtime +30 -delete 2>/dev/null || print_warning "Could not clean old downloads"
                print_success "Removed files older than 30 days from Downloads"
            fi
        else
            print_info "No files older than 30 days found in Downloads"
        fi
    fi

    # 12. Clean recent files and history (optional)
    print_info "=== Optional: Recent Files History ==="
    read -p "Do you want to clear recent files history? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        safe_remove "$HOME/.local/share/recently-used.xbel" "recently used files (xbel)"
        safe_remove "$HOME/.recently-used" "recently used files"
        safe_remove "$HOME/.local/share/RecentDocuments" "recent documents"
        print_success "Cleared recent files history"
    fi

    # 13. Custom path cleanup (optional)
    echo
    read -p "Do you want to remove custom files or directories? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        custom_path_cleanup
    fi

    # Final cleanup
    echo
    print_info "🧽 Running final cleanup..."
    # Remove empty directories in cache
    find "$HOME/.cache" -type d -empty -delete 2>/dev/null || true
    sync  # Sync filesystems

    # Show cleanup results
    final_usage=$(du -sh "$HOME" 2>/dev/null | cut -f1)
    echo
    print_success "=== 🎉 Cleanup Complete! ==="
    print_info "📊 Initial home directory usage: $initial_usage"
    print_info "📊 Final home directory usage:   $final_usage"
    echo
    print_success "✅ The following were preserved:"
    echo "  🔐 Browser profiles and login data (Brave, Chrome, Firefox)"
    echo "  📄 User documents and personal files"
    echo "  ⚙️  Application settings and configurations"
    echo "  🔑 SSH keys and certificates"
    echo "  📱 Important application data"
    echo
    print_info "💡 Tips for maintaining a clean system:"
    echo "   • Run this script monthly"
    echo "   • Clear browser downloads regularly"  
    echo "   • Clean up project directories periodically"
    echo "   • Use 'ncdu' to find large directories"
    echo "   • Consider using 'bleachbit' for deeper cleaning"
    echo "================================"
}

# Parse command line arguments
case "${1:-}" in
    "addpath")
        # Display header
        clear
        echo -e "\033[1;36m"
        echo "███████╗██████╗ ███████╗ ██████╗████████╗██████╗ ██╗   ██╗███╗   ███╗ ██████╗  ██╗"
        echo "██╔════╝██╔══██╗██╔════╝██╔════╝╚══██╔══╝██╔══██╗██║   ██║████╗ ████║██╔═████╗███║"
        echo "███████╗██████╔╝█████╗  ██║        ██║   ██████╔╝██║   ██║██╔████╔██║██║██╔██║╚██║"
        echo "╚════██║██╔═══╝ ██╔══╝  ██║        ██║   ██╔══██╗██║   ██║██║╚██╔╝██║████╔╝██║ ██║"
        echo "███████║██║     ███████╗╚██████╗   ██║   ██║  ██║╚██████╔╝██║ ╚═╝ ██║╚██████╔╝ ██║"
        echo "╚══════╝╚═╝     ╚══════╝ ╚═════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝ ╚═════╝  ╚═╝"
        echo -e "\033[0m"
        echo -e "\033[1;32m                          🧹 CUSTOM PATH CLEANER 🧹\033[0m"
        echo -e "\033[1;33m                        Remove Custom Files & Directories\033[0m"
        echo ""

        # Run custom path cleanup only
        custom_path_cleanup
        exit 0
        ;;
    "setup")
        # Display header
        clear
        echo -e "\033[1;36m"
        echo "███████╗██████╗ ███████╗ ██████╗████████╗██████╗ ██╗   ██╗███╗   ███╗ ██████╗  ██╗"
        echo "██╔════╝██╔══██╗██╔════╝██╔════╝╚══██╔══╝██╔══██╗██║   ██║████╗ ████║██╔═████╗███║"
        echo "███████╗██████╔╝█████╗  ██║        ██║   ██████╔╝██║   ██║██╔████╔██║██║██╔██║╚██║"
        echo "╚════██║██╔═══╝ ██╔══╝  ██║        ██║   ██╔══██╗██║   ██║██║╚██╔╝██║████╔╝██║ ██║"
        echo "███████║██║     ███████╗╚██████╗   ██║   ██║  ██║╚██████╔╝██║ ╚═╝ ██║╚██████╔╝ ██║"
        echo "╚══════╝╚═╝     ╚══════╝ ╚═════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝ ╚═════╝  ╚═╝"
        echo -e "\033[0m"
        echo -e "\033[1;32m                          ⚙️  ALIAS SETUP UTILITY ⚙️\033[0m"
        echo -e "\033[1;33m                        Add Global Command Alias\033[0m"
        echo ""
        setup_alias
        exit 0
        ;;
    "help"|"-h"|"--help")
        show_help
        exit 0
        ;;
    "")
        # No arguments - run full cleanup
        # Display header and continue to main cleanup
        main_cleanup
        ;;
    *)
        print_error "Unknown option: $1"
        echo ""
        show_help
        exit 1
        ;;
esac