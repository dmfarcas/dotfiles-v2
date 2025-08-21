#!/usr/bin/env fish

# Fish Configuration Backup/Restore Script
# Usage: 
#   ./sync-fish-config.fish backup    - Create a backup archive
#   ./sync-fish-config.fish restore   - Restore from backup archive

set script_dir (dirname (realpath (status --current-filename)))
set backup_name "fish-config-backup-(date +%Y%m%d-%H%M%S).tar.gz"
set config_dir ~/.config/fish

function backup_config
    echo "📦 Creating fish configuration backup..."
    
    # Create temporary directory for backup
    set temp_dir (mktemp -d)
    set backup_dir "$temp_dir/fish-config"
    
    # Copy fish configuration
    cp -r $config_dir $backup_dir
    
    # Copy the setup script
    cp $script_dir/setup-fish-portable.fish $backup_dir/
    
    # Create a restore script
    echo '#!/usr/bin/env fish
# Auto-generated restore script
echo "🔄 Restoring fish configuration..."

# Backup existing config if it exists
if test -d ~/.config/fish
    echo "💾 Backing up existing fish config..."
    mv ~/.config/fish ~/.config/fish.backup-(date +%Y%m%d-%H%M%S)
end

# Copy configuration
cp -r ./fish ~/.config/
chmod +x ~/.config/fish/config.fish

# Run portable setup
echo "🚀 Running portable setup..."
./setup-fish-portable.fish

echo "✅ Fish configuration restored successfully!"
echo "💡 Restart your terminal or run '\''source ~/.config/fish/config.fish'\''"' > $backup_dir/restore.fish
    
    chmod +x $backup_dir/restore.fish
    
    # Create archive
    cd $temp_dir
    tar -czf $backup_name fish-config/
    mv $backup_name $script_dir/
    
    # Cleanup
    rm -rf $temp_dir
    
    echo "✅ Backup created: $backup_name"
    echo "📂 Location: $script_dir/$backup_name"
    echo ""
    echo "To restore on another Mac:"
    echo "1. Copy $backup_name to the new Mac"
    echo "2. Extract: tar -xzf $backup_name"
    echo "3. Run: cd fish-config && ./restore.fish"
end

function restore_config
    echo "🔄 Looking for backup archives..."
    
    set archives (ls *.tar.gz 2>/dev/null | grep "fish-config-backup")
    
    if test (count $archives) -eq 0
        echo "❌ No backup archives found in current directory"
        echo "💡 Make sure you're in the directory containing your fish-config-backup-*.tar.gz file"
        return 1
    end
    
    # If multiple archives, let user choose
    if test (count $archives) -gt 1
        echo "Multiple backup archives found:"
        for i in (seq (count $archives))
            echo "$i. $archives[$i]"
        end
        echo -n "Choose archive number: "
        read choice
        set selected_archive $archives[$choice]
    else
        set selected_archive $archives[1]
    end
    
    echo "📦 Extracting $selected_archive..."
    tar -xzf $selected_archive
    
    if test -d fish-config
        cd fish-config
        ./restore.fish
    else
        echo "❌ Invalid backup archive"
        return 1
    end
end

function show_help
    echo "Fish Configuration Backup/Restore Tool"
    echo ""
    echo "Usage:"
    echo "  ./sync-fish-config.fish backup     - Create a portable backup"
    echo "  ./sync-fish-config.fish restore    - Restore from backup"
    echo "  ./sync-fish-config.fish help       - Show this help"
    echo ""
    echo "The backup includes:"
    echo "  • Fish configuration files"
    echo "  • Custom functions and aliases"
    echo "  • Plugin configurations"
    echo "  • Portable setup script"
end

# Main script logic
switch $argv[1]
    case backup
        backup_config
    case restore
        restore_config
    case help
        show_help
    case '*'
        echo "❌ Invalid option: $argv[1]"
        echo ""
        show_help
        exit 1
end
