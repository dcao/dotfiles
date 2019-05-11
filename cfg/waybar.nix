{ colors ? import ./colors, ... }:

{
  config = builtins.toJSON {
    layer = "top";
    modules-left = [ "sway/workspaces" "sway/mode" "backlight" "pulseaudio" "mpd" ];
    modules-center = [ "clock" ];
    modules-right = [ "tray" "memory" "cpu" "network" "battery" ];
    backlight = {
      device = "intel_backlight";
    };
    network = {
      "format-wifi" = "{essid}";
    };
    clock = {
      interval = 1;
      format = "{:%Y-%m-%d %H:%M:%S}";
    };
    pulseaudio = {
      on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
    };
  };

  styles = ''
    * {
        border: none;
        border-radius: 0;
        font-family: monospace;
        font-size: 14px;
        min-height: 0;
    }

    window {
        background: transparent;
    }
    
    window > box {
        margin: 16px 16px 0px 16px;
        color: #ffffff;
    }
    
    /*
    window#waybar.hidded {
        opacity: 0.2;
    }
    */

    #workspaces {
        margin-right: 10px;
    }
    
    /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
    #workspaces button {
        padding: 0 5px;
        background: transparent;
        color: #${colors.base05};
        /* border-bottom: 3px solid transparent; */
    }

    #workspaces button:hover {
        box-shadow: inherit;
        background: #${colors.base02};
    }
    
    #workspaces button.focused {
        background: #${colors.base04};
        color: #${colors.base00};
        /* border-bottom: 3px solid #ffffff; */
    }
    
    #workspaces button.urgent {
        background-color: #${colors.base08};
        color: #${colors.base00};
    }
    
    #mode {
        background: #${colors.base04};
        color: #${colors.base00};
    }
    
    #clock, #cpu, #memory, #temperature, #backlight, #network, #pulseaudio, #custom-media, #tray, #mode, #idle_inhibitor, #mpd {
        padding: 0 10px;
        margin: 0 5px;
    }
    
    #clock {
        background-color: #${colors.base00};
        color: #${colors.base05};
    }
    
    #battery {
        background-color: #${colors.base0B};
        color: #${colors.base00};
        padding: 0 10px;
        margin-left: 5px;
    }
    
    #battery.charging {
        background-color: #${colors.base06};
        color: #${colors.base02};
    }
    
    @keyframes blink {
        to {
            background-color: #ffffff;
            color: #000000;
        }
    }
    
    #battery.critical:not(.charging) {
        background: #${colors.base08};
        color: #${colors.base00};
    }
    
    label:focus {
        background-color: #000000;
    }
    
    #cpu {
        background-color: #${colors.base0E};
        color: #${colors.base00};
    }
    
    #memory {
        background: #${colors.base0E};
        color: #${colors.base00};
    }
    
    #backlight {
        background: #${colors.base0A};
        color: #${colors.base00};
    }
    
    #network {
        background: #${colors.base0D};
        color: #${colors.base00};
    }
    
    #network.disconnected {
        background: #${colors.base08};
        color: #${colors.base00};
    }
    
    #pulseaudio {
        background: #${colors.base0C};
        color: #${colors.base00};
    }
    
    #pulseaudio.muted {
        background: #${colors.base02};
        color: #${colors.base04};
    }

    #mpd {
        background: #${colors.base0C};
        color: #${colors.base00};
    }
    
    #mpd.disconnected {
        background: #${colors.base08};
        color: #${colors.base00};
    }
    
    #mpd.stopped {
        background: #${colors.base02};
        color: #${colors.base04};
    }
    
    #mpd.paused {
        background: #${colors.base02};
        color: #${colors.base04};
    }
    
    #custom-media {
        background: #66cc99;
        color: #2a5c45;
    }
    
    .custom-spotify {
        background: #66cc99;
    }
    
    .custom-vlc {
        background: #ffa000;
    }
    
    #temperature {
        background: #f0932b;
    }
    
    #temperature.critical {
        background: #eb4d4b;
    }
    
    #tray {
        background-color: #${colors.base02};
    }
    
    #idle_inhibitor {
        background-color: #2d3436;
    }
    
    #idle_inhibitor.activated {
        background-color: #ecf0f1;
        color: #2d3436;
    }
    
  '';
}
