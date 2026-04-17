# iTerm2 Configuration

This directory contains iTerm2 settings exported manually for version control.

## Export Settings (Already Done)

Settings were exported via:
- iTerm2 → **Preferences → General → Preferences**
- Click **"Save Current Settings to Folder"**
- Saved to this directory as `iterm-settings`

Reference: [Sync iTerm2 Configs](https://shyr.io/blog/sync-iterm2-configs)

## Restore Settings on New Machine

1. Open iTerm2
2. Go to **Preferences → General → Preferences**
3. Check **"Load preferences from a custom folder or URL"**
4. Click **"Browse"** and select: `~/Projects/dotfiles-v2/iterm2`
5. Restart iTerm2

iTerm2 will now load settings from this folder.

## Update Settings

When you change settings in iTerm2, they are automatically saved to this folder if you have "Load preferences from a custom folder" enabled.

To commit changes:
```bash
cd ~/Projects/dotfiles-v2
git add iterm2/
git commit -m "Update iTerm2 settings"
git push
```

## Notes

- The `iterm-settings` file is a compressed plist containing all profiles, colors, fonts, and key bindings
- iTerm2 automatically keeps this file in sync when folder sync is enabled
- Binary format is fine for git - changes will be tracked
