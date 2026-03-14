#!/bin/bash
cat << 'EOF'
 ╭─────────────────────────────────────────────────────╮
 │              TMUX QUICK REFERENCE                   │
 │         Prefix = Ctrl+A  (press then release)       │
 ╰─────────────────────────────────────────────────────╯

 WINDOWS (tabs)
   Prefix  c        New window
   Prefix  ,        Rename window
   Prefix  &        Kill window
   Prefix  n        Next window
   Prefix  p        Previous window
   Prefix  1-9      Jump to window by number
   Prefix  Tab      Last active window

 PANES (splits)
   Prefix  |        Split vertically (side by side)
   Prefix  -        Split horizontally (top/bottom)
   Prefix  x        Kill pane
   Prefix  z        Zoom pane (fullscreen toggle)
   Prefix  h/j/k/l  Move between panes (vi-style)
   Prefix  H/J/K/L  Resize pane
   Prefix  {        Swap pane left
   Prefix  }        Swap pane right

 SESSIONS
   Prefix  s        List/switch sessions
   Prefix  $        Rename session
   Prefix  d        Detach (leave tmux running)
   tmux ls          List sessions (from shell)
   tmux a           Reattach to session

 COPY MODE  (scrollback / search)
   Prefix  [        Enter copy mode
   q                Exit copy mode
   v                Start selection
   y                Copy selection
   Prefix  ]        Paste
   /                Search forward
   ?                Search backward
   n / N            Next / previous match

 OTHER
   Prefix  ?        Show this help
   Prefix  r        Reload config
   Prefix  :        tmux command prompt
   Right-click      Context menu (phone/tablet)

EOF
