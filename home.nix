{ config, pkgs, ... }:


# We assume that the dotfiles dir already exists
# Otherwise how did you get this config file?
let
  dots = "/home/david/.files";
  extra = "${dots}/extra";
  browser = "qutebrowser";
  waylandUrl = "https://github.com/colemickens/nixpkgs-wayland/archive/master.tar.gz";
  waylandOverlay = (import (builtins.fetchTarball waylandUrl));
  colors = import ./cfg/colors;

in

rec {
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (import ./overlays/dcao.nix)
      waylandOverlay
    ];
  };

  accounts.email = {
    accounts = {
      cao = {
        primary = true;
        address = "david@cao.st";
        userName = "david@cao.st";
        realName = "David Cao";
        passwordCommand = "pass 'Root/Gandi Mail' | head -1";

        gpg = {
          key = "8FCD18FB168F99AFDEC4B054BAF82063B3C00397";
        };

        imap = {
          host = "mail.gandi.net";
          port = 993;
          tls = {
            enable = true;
          };
        };

        smtp = {
          host = "mail.gandi.net";
          port = 465;
          tls = {
            enable = true;
          };
        };

        notmuch.enable = true;
        mbsync = {
          enable = true;
          patterns = [ "INBOX" ];
        };
        astroid = {
          enable = true;
          sendMailCommand = "msmtp --read-envelope-from --read-recipients";
        };
        msmtp.enable = true;
      };

      duhpster = {
        address = "duhpster@gmail.com";
        userName = "duhpster@gmail.com";
        realName = "David Cao";
        passwordCommand = "pass 'Root/duhpster-msmtp' | head -1";

        gpg = {
          key = "8FCD18FB168F99AFDEC4B054BAF82063B3C00397";
        };

        flavor = "gmail.com";

        notmuch.enable = true;
        mbsync = {
          enable = true;
          patterns = [ "INBOX" ];
        };
        astroid = {
          enable = true;
          sendMailCommand = "msmtp --read-envelope-from --read-recipients";
        };
        msmtp.enable = true;
      };
    };
  };

  xdg.configFile = {
    "user-dirs.dirs".source = "${extra}/x/.config/user-dirs.dirs";
    "sway/config".text = (import ./cfg/sway.nix) {
      world-wall = pkgs.world-wall;
    };
    "swaylock/config".text = (import ./cfg/swaylock.nix) {
      world-wall = pkgs.world-wall;
    };
    "swaynag/config".text = (import ./cfg/swaynag.nix) {};
    "waybar/config".text = ((import ./cfg/waybar.nix) {}).config;
    "waybar/styles.css".text = ((import ./cfg/waybar.nix) {}).styles;
  };

  xdg.dataFile = {
    "fonts".source = "${config.home.homeDirectory}/default/fonts";
  };

  home = {
    packages = with pkgs; [
      qutebrowser rofi-pass ripgrep ncmpcpp
      pavucontrol pass xdg-user-dirs
      sxiv cmst libreoffice discord libnotify
      ranger qbittorrent aspell darktable mpv
      blueman spotify nix-prefetch-github
      olive-editor youtube-dl steam mako jq
      imgur-sh grim slurp wl-clipboard fzf
      hugo pandoc ffmpeg fava ipe anki
      redshift-wayland torbrowser scribus
      neofetch imagemagick

      (st.override {
        conf = (import ./cfg/st/config.nix) {};
        patches = [
          ./cfg/st/st-boxdraw_v2-0.8.2.diff
        ];
      })

      # acme
      fortune cowsay lolcat cmatrix
    ];

    # for now, none of the rice has been transferred from the legacy stow
    # system to the new fancy home-manager system. in the interim, we emulate
    # what stow would've done here:
    file = {
      ".ncmpcpp/config".source = "${extra}/ncmpcpp/config";
      "bin/sway_rename.sh".source = "${extra}/sway/sway_rename.sh";

      emacs = { source = "${extra}/emacs"; target = "."; recursive = true; };
      qutebrowser = { source = "${extra}/qutebrowser"; target = "."; recursive = true; };
      ranger = { source = "${extra}/ranger"; target = "."; recursive = true; };
      rofi = { source = "${extra}/rofi"; target = "."; recursive = true; };
    };

    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "${browser}";
      TERM = "xterm-256color";
      PASSWORD_STORE_DIR = "$HOME/default/pass/";
      FZF_DEFAULT_OPTS = "--height 50% --reverse --ansi";
    };
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    fish = {
      enable = true;
      promptInit = ''
        function fish_prompt
          set_color $fish_color_cwd
          printf '%s ' (prompt_pwd)
          set_color normal
          printf 'λ '
        end

        function fish_greeting
          printf 'o/ %s@%s [%s]' (whoami) (hostname) (date "+%F %T")
          echo ""
        end
        funcsave fish_greeting
      '';
      shellAliases = {
        nv = "nvim";
        ew = "emacs -nw";
        pa = "pikaur";
        rl = "source ~/.config/fish/config.fish";
        r = "~/.files/.rice/r";
        musdl = "youtube-dl -i --extract-audio --audio-format mp3 --audio-quality 0";
        startx = "startx ~/.xinitrc";
      };
    };

    git = {
      enable = true;
      userName = "David Cao";
      userEmail = "david@cao.st";
      signing = {
        key = "8FCD18FB168F99AFDEC4B054BAF82063B3C00397";
        signByDefault = true;
      };
    };

    # Mail config
    mbsync = {
      enable = true;
    };

    notmuch = {
      enable = true;
      hooks = {
        preNew = "mbsync --all";
      };
    };

    msmtp = {
      enable = true;
    };

    astroid = {
      enable = true;
      externalEditor = "st -e nvim -c 'set ft=mail' '+set tw=72' %1";
      # The notmuch hook already fetches from mbsync
      pollScript = "NOTMUCH_CONFIG=~/.config/notmuch/notmuchrc notmuch new";
      extraConfig = {
        editor.attachment_directory = "~/dl";
      };
    };

    direnv = {
      enable = true;
      enableFishIntegration = true;
    };
  
    rofi = {
      enable = true;
    };

    beets = {
      enable = true;
      settings = {
        directory = "~/default/mus";
    library = "~/beets.db";
    embedart.auto = "no";
    play.command = "mpv";
        plugins = [ "fromfilename" ];
      };
    };

    zathura = {
      enable = true;
      options = {
        default-bg = "#282828";
        default-fg = "#3c3836";
        statusbar-fg = "#bdae93";
        statusbar-bg = "#504945";
        inputbar-bg = "#282828";
        inputbar-fg = "#fbf1c7";
        notification-bg = "#282828";
        notification-fg = "#fbf1c7";
        notification-error-bg = "#282828";
        notification-error-fg = "#fb4934";
        notification-warning-bg = "#282828";
        notification-warning-fg = "#fb4934";
        highlight-color = "#fabd2f";
        highlight-active-color = "#83a598";
        completion-bg = "#3c3836";
        completion-fg = "#83a598";
        completion-highlight-fg = "#fbf1c7";
        completion-highlight-bg = "#83a598";
        recolor-lightcolor = "#282828";
        recolor-darkcolor = "#ebdbb2";
        recolor = "true";
        recolor-keephue = "false";
      };
    };

    alacritty = {
      enable = true;
      settings = {
        window.padding = {
          x = 16;
          y = 16;
        };

        tabspaces = 4;
        # This is for X11; in sway, the font size has to be amped up
        # font.size = 9.0;
        font.size = 14.0;

        colors = {
          primary = {
            background = "0x${colors.base00}";
            foreground = "0x${colors.base05}";
          };

          cursor = {
            text = "0x${colors.base00}";
            cursor = "0x${colors.base05}";
          };

          # Normal colors
          normal = {
            black = "0x${colors.base00}";
            red = "0x${colors.base08}";
            green = "0x${colors.base0B}";
            yellow = "0x${colors.base0A}";
            blue = "0x${colors.base0D}";
            magenta = "0x${colors.base0E}";
            cyan = "0x${colors.base0C}";
            white = "0x${colors.base05}";
          };

          # Bright colors
          bright = {
            black = "0x${colors.base00}";
            red = "0x${colors.base08}";
            green = "0x${colors.base0B}";
            yellow = "0x${colors.base0A}";
            blue = "0x${colors.base0D}";
            magenta = "0x${colors.base0E}";
            cyan = "0x${colors.base0C}";
            white = "0x${colors.base05}";
          };

          indexed_colors = [
            { index = 16; color = "0x${colors.base09}"; }
            { index = 17; color = "0x${colors.base0F}"; }
            { index = 18; color = "0x${colors.base01}"; }
            { index = 19; color = "0x${colors.base02}"; }
            { index = 20; color = "0x${colors.base04}"; }
            { index = 21; color = "0x${colors.base06}"; }
          ];
        };
      };
    };

    tmux = {
      enable = true;
      escapeTime = 0;
      historyLimit = 10000;
      keyMode = "vi";
      plugins = with pkgs.tmuxPlugins; [
        resurrect
      ];
      sensibleOnTop = true;
      shortcut = "b";
      terminal = "screen-256color";
      extraConfig = ''
        set -g mouse on
        setw -g monitor-activity off
        set -g visual-activity off
        set-option -g repeat-time 250
        set-option -g message-style "bg=#${colors.base00}, fg=#${colors.base06}"
        bind R source-file ~/.tmux.conf \; display-message ":: Config reloaded"

        # status line fmt
        set -g status-left ""
        set -g status-left-length "30"
        set -g status-style "bg=#${colors.base00}"
        set -g status-right "#[fg=#${colors.base03}]#(date +\"%b %-d\")#[fg=#${colors.base04}] #(date +\"%H:%M\") #[fg=#${colors.base05}]#S"
        set -g status-justify "left"
        
        # Center Formatting
        set -g window-status-current-format "#[fg=#${colors.base0B}]#I #[fg=#${colors.base0D}]#W "
        set -g window-status-format "#[fg=#${colors.base02}]#I #[fg=#${colors.base03}]#W "
        
        # Renaming window conveniences
        bind-key , command-prompt -p ":: Rename window #I | #W ~>" 'rename-window %%' \; set-option allow-rename off
        bind-key < command-prompt -p ":: Rename session #S ~>" 'rename-session %%'
        bind-key > set-option allow-rename on \; display-message ":: Enabled auto-rename for window [#I | #W]."
        
        # y and p as in vim
        bind Escape copy-mode
        unbind p
        bind p paste-buffer
        bind -T copy-mode-vi 'v' send -X begin-selection
        bind -T copy-mode-vi 'y' send -X copy-selection
        bind -T copy-mode-vi 'Space' send -X halfpage-down
        bind -T copy-mode-vi 'Bspace' send -X halfpage-up
         
        # extra commands for interacting with the ICCCM clipboard
        bind C-c run "tmux save-buffer - | xclip -i -sel clipboard"
        bind C-v run "tmux set-buffer \"$(xclip -o -sel clipboard)\"; tmux paste-buffer"
         
        # easy-to-remember split pane commands
        bind \ split-window -h
        bind - split-window -v
        unbind '"'
        unbind %
         
        # moving between panes with vim movement keys
        bind -r h select-pane -L
        bind -r j select-pane -D
        bind -r k select-pane -U
        bind -r l select-pane -R
         
        # moving between windows with vim movement keys
        bind -r C-h select-window -t :-
        bind -r C-l select-window -t :+
         
        # resize panes with vim movement keys
        bind -r H resize-pane -L 1
        bind -r J resize-pane -D 1
        bind -r K resize-pane -U 1
        bind -r L resize-pane -R 1
        
        # pane colors
        set -g pane-border-style "fg=#${colors.base01}"
        set -g pane-active-border-style "fg=#${colors.base0D}"
      '';
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      configure = {
        customRC = ''
          set background=dark
          set encoding=utf-8
          set tabstop=4       
          set shiftwidth=4    
          set expandtab       
          set smarttab        
          set showcmd         
          set number          
          set showmatch       
          set incsearch       
          set ignorecase      
          set smartcase       
          set backspace=2     
          set autoindent      
          set textwidth=79    
          set formatoptions=c,q,r
          set ruler
          set background=dark
          set mouse=a
          set noshowmode
          set history=200
          nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
        '';

        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [ ale fugitive surround vim-nix lightline-vim vimtex ];
          opt = [];
        };
      };
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };

    syncthing.enable = true;

    mpd = {
      enable = true;
      musicDirectory = "${config.home.homeDirectory}/default/mus";
    };

  };

}
