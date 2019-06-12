{ colors ? import ./colors, world-wall, ... }:

''
  # Default config for sway
  #
  # Copy this to ~/.config/sway/config and edit it to your liking.
  #
  # Read `man 5 sway` for a complete reference.
  
  ### Variables
  #
  # Logo key. Use Mod1 for Alt.
  set $mod Mod4
  # Home row direction keys, like vim
  set $left h
  set $down j
  set $up k
  set $right l
  # Your preferred terminal emulator
  set $term st
  # Your preferred application launcher
  # Note: it's recommended that you pass the final command to sway
  
  ### Output configuration
  #
  # Default wallpaper
  output * bg "${world-wall}/share/artwork/gnome/world.png" fill 
  output HDMI-A-2 scale 1 pos 1920,0
  #
  # Example configuration:
  #
  #   output HDMI-A-1 resolution 1920x1080 position 1920,0
  #
  # You can get the names of your outputs by running: swaymsg -t get_outputs

  
  ### Idle configuration
  #
  # Example configuration:
  #
  # exec swayidle -w before-sleep 'swaylock -i ${world-wall}/share/artwork/gnome/world.png --font Iosevka'
  
  ### Input configuration
  input * {
    repeat_delay 200
    repeat_rate 40
    xkb_options "eurosign:e"
    pointer_accel 0
    accel_profile flat
  }

  input "2:7:SynPS/2_Synaptics_TouchPad" {
    natural_scroll enable
    accel_profile flat
  }

  input "2:10:TPPS/2_IBM_TrackPoint" {
    accel_profile adaptive
  }
  
  ### Key bindings
  #
  # Basics:
  #
      # start a terminal
      bindsym $mod+Return exec $term
      bindsym $mod+Shift+Return exec rofi_tmux
      bindsym $mod+q exec $term -e ranger
  
      # kill focused window
      bindsym $mod+w kill
  
      # start your launcher
      bindsym $mod+Tab exec rofi -show combi
      bindsym Alt+p exec rofi-pass
  
      # Drag floating windows by holding down $mod and left mouse button.
      # Resize them with right mouse button + $mod.
      # Despite the name, also works for non-floating windows.
      # Change normal to inverse to use left mouse button for resizing and right
      # mouse button for dragging.
      floating_modifier $mod normal
  
      # reload the configuration file
      bindsym $mod+Shift+r reload

      # Media
      bindsym XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +1%
      bindsym XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -1%
      bindsym XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle
      bindsym XF86AudioMicMute exec pactl @DEFAULT_SOURCE@ 1 toggle
      bindsym XF86MonBrightnessUp exec light -A 5
      bindsym XF86MonBrightnessDown exec light -U 5
  
      # exit sway (logs you out of your Wayland session)
      bindsym $mod+Shift+y exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'
  #
  # Moving around:
  #
      # Move your focus around
      bindsym $mod+$left focus left
      bindsym $mod+$down focus down
      bindsym $mod+$up focus up
      bindsym $mod+$right focus right
      # or use $mod+[up|down|left|right]
      bindsym $mod+Left focus left
      bindsym $mod+Down focus down
      bindsym $mod+Up focus up
      bindsym $mod+Right focus right
  
      # _move_ the focused window with the same, but add Shift
      bindsym $mod+Shift+$left move left
      bindsym $mod+Shift+$down move down
      bindsym $mod+Shift+$up move up
      bindsym $mod+Shift+$right move right
      # ditto, with arrow keys
      bindsym $mod+Shift+Left move left
      bindsym $mod+Shift+Down move down
      bindsym $mod+Shift+Up move up
      bindsym $mod+Shift+Right move right
  #
  # Workspaces:
  # Workspaces:
  #
      # switch to workspace
      bindsym $mod+1 workspace number 1
      bindsym $mod+2 workspace number 2
      bindsym $mod+3 workspace number 3
      bindsym $mod+4 workspace number 4
      bindsym $mod+5 workspace number 5
      bindsym $mod+6 workspace number 6
      bindsym $mod+7 workspace number 7
      bindsym $mod+8 workspace number 8
      bindsym $mod+9 workspace number 9
      bindsym $mod+0 workspace number 10
      # move focused container to workspace
      bindsym $mod+Shift+1 move container to workspace number 1
      bindsym $mod+Shift+2 move container to workspace number 2
      bindsym $mod+Shift+3 move container to workspace number 3
      bindsym $mod+Shift+4 move container to workspace number 4
      bindsym $mod+Shift+5 move container to workspace number 5
      bindsym $mod+Shift+6 move container to workspace number 6
      bindsym $mod+Shift+7 move container to workspace number 7
      bindsym $mod+Shift+8 move container to workspace number 8
      bindsym $mod+Shift+9 move container to workspace number 9
      bindsym $mod+Shift+0 move container to workspace number 10
      bindsym $mod+Alt+l move container to output right
      bindsym $mod+Alt+h move container to output left
      bindsym $mod+Shift+Alt+l move workspace to output right
      bindsym $mod+Shift+Alt+h move workspace to output left
      # Note: workspaces can have any name you want, not just numbers.
      # We just use 1-10 as the default.
      bindsym $mod+e exec sway_rename.sh
  #
  # Layout stuff:
  #
      default_border pixel 2
      client.focused "#${colors.base0D}" "#${colors.base0D}" "#${colors.base00}" "#${colors.base0C}" "#${colors.base0D}"
      client.focused_inactive "#${colors.base02}" "#${colors.base02}" "#${colors.base04}" "#${colors.base04}" "#${colors.base02}"
      client.unfocused "#${colors.base02}" "#231f20" "#${colors.base04}" "#${colors.base03}" "#${colors.base02}"
      client.urgent "#${colors.base08}" "#${colors.base08}" "#${colors.base00}" "#${colors.base08}" "#${colors.base08}"
      gaps outer 16
      # You can "split" the current object of your focus with
      # $mod+b or $mod+v, for horizontal and vertical splits
      # respectively.
      bindsym $mod+i splith
      bindsym $mod+o splitv
  
      # Switch the current container between different layout styles
      bindsym $mod+space layout toggle all
  
      # Make the current focus fullscreen
      bindsym $mod+f fullscreen
  
      # Toggle the current focus between tiling and floating mode
      bindsym $mod+s floating toggle
      bindsym $mod+Shift+s focus mode_toggle
  
      # move focus to the parent container
      bindsym $mod+a focus parent
      bindsym $mod+Shift+a focus child

      # bindsym Ctrl+Alt+f exec grim -g $(slurp) - | imgur.sh | wl-copy && notify-send "imgur-shot" "screenshot uploaded"
  #
  # Scratchpad:
  #
      # Sway has a "scratchpad", which is a bag of holding for windows.
      # You can send windows there and get them back later.
  
      # Move the currently focused window to the scratchpad
      bindsym $mod+Shift+minus move scratchpad
  
      # Show the next scratchpad window or hide the focused scratchpad window.
      # If there are multiple scratchpad windows, this command cycles through them.
      bindsym $mod+minus scratchpad show
  #
  # Resizing containers:
  #
  mode "resize" {
      # left will shrink the containers width
      # right will grow the containers width
      # up will shrink the containers height
      # down will grow the containers height
      bindsym $left resize shrink width 10px
      bindsym $down resize grow height 10px
      bindsym $up resize shrink height 10px
      bindsym $right resize grow width 10px
  
      # ditto, with arrow keys
      bindsym Left resize shrink width 10px
      bindsym Down resize grow height 10px
      bindsym Up resize shrink height 10px
      bindsym Right resize grow width 10px
      # return to default mode
      bindsym Return mode "default"
      bindsym Escape mode "default"
  }
  bindsym $mod+r mode "resize"

  exec --no-startup-id libinput-gestures-setup start

  exec mako --margin 16 --padding 8 --border-color "#ebdbb2" --text-color "#ebdbb2" --background-color "#282828" --border-size 4
  bindsym Ctrl+space exec makoctl dismiss
  
  #
  # Status Bar:
  #
  # Read `man 5 sway-bar` for more information about this section.
  bar {
      gaps 16 16 0 16
      swaybar_command waybar -c ~/.config/waybar/config -s ~/.config/waybar/styles.css
  }
''
