# Fish Shell & Neovim Cheatsheet

## Fish Shell Commands & Features

### Basic Navigation

```fish
cd <directory>              # Change directory
cd -                        # Go to previous directory
pwd                         # Print working directory
ls                          # List files
ls -la                      # List all files with details
```

### File Operations

```fish
cp <source> <dest>          # Copy file
mv <source> <dest>          # Move/rename file
rm <file>                   # Remove file
rm -rf <directory>          # Remove directory recursively
mkdir <directory>           # Create directory
touch <file>                # Create empty file
```

### Fish-Specific Features

```fish
# Auto-suggestions (ghost text) - press Tab or → to accept
# Syntax highlighting - commands are colored
# Command completion - press Tab for options

# History
history                     # Show command history
history | grep <term>       # Search history
history --clear             # Clear history

# Variables
set VAR_NAME value          # Set variable
set -e VAR_NAME            # Erase variable
set -x VAR_NAME value      # Export variable (environment)
echo $VAR_NAME             # Use variable

# Functions
function my_function
    echo "Hello"
end

# Abbreviations (expand when you type)
abbr -a gst git status
abbr -a gc git commit
abbr -a gp git push
```

### Fish Configuration

```fish
# Config file location
~/.config/fish/config.fish

# Reload config
source ~/.config/fish/config.fish

# Install plugins with Fisher
fisher install <plugin>
fisher list                 # List installed plugins
fisher remove <plugin>     # Remove plugin
```

### Common Fish Functions

```fish
# File search
find . -name "*.js"         # Find JavaScript files
fd <pattern>               # Modern find alternative (if installed)

# Text processing
grep <pattern> <file>       # Search in file
rg <pattern>               # Ripgrep (faster grep, if installed)
cat <file>                 # Display file contents
less <file>                # Page through file
head -n 10 <file>          # First 10 lines
tail -n 10 <file>          # Last 10 lines
```

---

## Neovim Commands & Shortcuts

### Basic Navigation

```vim
h, j, k, l                  # Left, Down, Up, Right
w                           # Jump to next word
b                           # Jump to previous word
0                           # Beginning of line
$                           # End of line
gg                          # Go to first line
G                           # Go to last line
<number>G                   # Go to line number
Ctrl+u                      # Page up
Ctrl+d                      # Page down
```

### Editing

```vim
i                           # Insert mode (before cursor)
a                           # Insert mode (after cursor)
o                           # New line below and insert
O                           # New line above and insert
ESC                         # Exit insert mode

x                           # Delete character
dd                          # Delete line
yy                          # Copy line
p                           # Paste after cursor
P                           # Paste before cursor
u                           # Undo
Ctrl+r                      # Redo
```

### File Operations

```vim
:w                          # Save file
:q                          # Quit
:wq                         # Save and quit
:q!                         # Quit without saving
:e <filename>               # Open file
:sp <filename>              # Split horizontally and open file
:vs <filename>              # Split vertically and open file
```

### Search & Replace

```vim
/<pattern>                  # Search forward
?<pattern>                  # Search backward
n                           # Next search result
N                           # Previous search result
:%s/old/new/g              # Replace all occurrences
:%s/old/new/gc             # Replace with confirmation
```

### Visual Mode

```vim
v                           # Visual mode (character selection)
V                           # Visual line mode
Ctrl+v                      # Visual block mode
```

### Window Management

```vim
Ctrl+w h/j/k/l             # Navigate between splits
Ctrl+w s                   # Split horizontally
Ctrl+w v                   # Split vertically
Ctrl+w q                   # Close current window
Ctrl+w =                   # Equalize window sizes
```

### Plugin-Specific Commands (Based on Your Config)

#### Telescope (File Finder)

```vim
<leader>ff                  # Find files
<leader>fg                  # Live grep
<leader>fb                  # Buffers
<leader>fh                  # Help tags
```

#### LSP (Language Server)

```vim
gd                          # Go to definition
gr                          # Go to references
K                           # Hover documentation
<leader>rn                  # Rename
<leader>ca                  # Code action
```

#### TypeScript Tools

```vim
<leader>oi                  # Organize imports
<leader>ru                  # Remove unused imports
<leader>fa                  # Fix all issues
```

#### GitHub Copilot

```vim
:Copilot setup              # Initial setup
:Copilot enable             # Enable Copilot
:Copilot disable            # Disable Copilot
Tab                         # Accept suggestion
Ctrl+]                      # Next suggestion
Ctrl+[                      # Previous suggestion
```

#### Mason (LSP Package Manager)

```vim
:Mason                      # Open Mason UI
:MasonInstall <server>      # Install LSP server
:MasonUninstall <server>    # Uninstall LSP server
```

#### Lazy (Plugin Manager)

```vim
:Lazy                       # Open Lazy UI
:Lazy install               # Install plugins
:Lazy update                # Update plugins
:Lazy clean                 # Remove unused plugins
:Lazy sync                  # Install/update/clean
```

### Custom Configuration Locations

```
Neovim config: ~/.config/nvim/
- init.lua                  # Main config file
- lua/core/                 # Core configurations
  - plugins.lua             # Plugin definitions
  - options.lua             # Neovim options
  - keymaps.lua             # Key mappings
- lua/plugins/configs/      # Plugin configurations
  - lsp.lua                 # LSP setup
  - telescope.lua           # Telescope setup
  - treesitter.lua          # Treesitter setup

Fish config: ~/.config/fish/
- config.fish               # Main config file
- functions/                # Custom functions
- completions/              # Auto-completions
- conf.d/                   # Configuration snippets
```

### Useful Neovim Commands

```vim
:checkhealth                # Check Neovim health
:help <topic>               # Get help on topic
:Tutor                      # Interactive tutorial
:messages                   # Show messages
:lua print("hello")         # Execute Lua code
```

### Fish Tips & Tricks

```fish
# Command substitution
echo (date)                 # Execute command and use output

# Pipes and redirection
command | grep pattern      # Pipe output to grep
command > file              # Redirect output to file
command >> file             # Append output to file

# Job control
command &                   # Run in background
jobs                        # List background jobs
fg %1                       # Bring job 1 to foreground
bg %1                       # Send job 1 to background

# Quick directory jumping (if installed)
z <partial_name>            # Jump to frequently used directory
```

### Neovim Tips & Tricks

```vim
# Macros
qa                          # Start recording macro 'a'
<commands>                  # Execute commands
q                           # Stop recording
@a                          # Play macro 'a'
@@                          # Repeat last macro

# Marks
ma                          # Set mark 'a'
'a                          # Jump to mark 'a'
:marks                      # List all marks

# Registers
"ay                         # Yank to register 'a'
"ap                         # Paste from register 'a'
:registers                  # Show all registers
```
