{ config, pkgs, ... }:


# We assume that the dotfiles dir already exists
# Otherwise how did you get this config file?
let
  updateDoom = ".emacs.d/bin/doom -y re";
  dots = "/home/david/.files";
  extra = "${dots}/extra";
  browser = "qutebrowser";
  colors = import ./cfg/colors;
  nvPlugins = pkgs.callPackage ./cfg/nvim/plugins.nix {};
in

rec {
  # imports = [
  #   ./cfg/caches.nix
  # ];

  # caches.cachix = [
  #   "nix-community"
  # ];
    
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (import ./overlays/dcao.nix)
    ];
  };

  accounts.email = {
    accounts = {
      cao-sh = {
        primary = true;
        address = "david@cao.sh";
        userName = "david@cao.sh";
        realName = "David Cao";
        passwordCommand = "PASSWORD_STORE_DIR=$HOME/default/pass/ pass 'Root/NameCheap Mail' | head -1";

        gpg = {
          key = "8FCD18FB168F99AFDEC4B054BAF82063B3C00397";
        };

        imap = {
          host = "mail.privateemail.com";
          port = 993;
          tls = {
            enable = true;
          };
        };

        smtp = {
          host = "mail.privateemail.com";
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

        neomutt.enable = true;
      };

      # cao-st = {
      #   address = "david@cao.st";
      #   userName = "david@cao.st";
      #   realName = "David Cao";
      #   passwordCommand = "PASSWORD_STORE_DIR=$HOME/default/pass/ pass 'Root/Gandi Mail' | head -1";

      #   gpg = {
      #     key = "8FCD18FB168F99AFDEC4B054BAF82063B3C00397";
      #   };

      #   imap = {
      #     host = "mail.gandi.net";
      #     port = 993;
      #     tls = {
      #       enable = true;
      #     };
      #   };

      #   smtp = {
      #     host = "mail.gandi.net";
      #     port = 465;
      #     tls = {
      #       enable = true;
      #     };
      #   };

      #   notmuch.enable = true;
      #   mbsync = {
      #     enable = true;
      #     patterns = [ "INBOX" ];
      #   };
      #   astroid = {
      #     enable = true;
      #     sendMailCommand = "msmtp --read-envelope-from --read-recipients";
      #   };
      #   msmtp.enable = true;
      # };

      # duhpster = {
      #   address = "duhpster@gmail.com";
      #   userName = "duhpster@gmail.com";
      #   realName = "David Cao";
      #   passwordCommand = "PASSWORD_STORE_DIR=$HOME/default/pass/ pass 'Root/duhpster-msmtp' | head -1";

      #   gpg = {
      #     key = "8FCD18FB168F99AFDEC4B054BAF82063B3C00397";
      #   };

      #   flavor = "gmail.com";

      #   notmuch.enable = true;
      #   mbsync = {
      #     enable = true;
      #     patterns = [ "INBOX" ];
      #   };
      #   astroid = {
      #     enable = true;
      #     sendMailCommand = "msmtp --read-envelope-from --read-recipients";

      #   };
      #   msmtp.enable = true;
      # };

      ucsd = {
        address = "dmcao@ucsd.edu";
        userName = "dmcao@ucsd.edu";
        realName = "David Cao";
        passwordCommand = "PASSWORD_STORE_DIR=$HOME/default/pass/ pass 'Root/TritonLink' | sed '4q;d' | cut -d' ' -f2";

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

        neomutt.enable = true;
      };
    };
  };

  xdg = {
    configFile = {
      "user-dirs.dirs".source = "${extra}/x/.config/user-dirs.dirs";
      "awesome".source = "${extra}/awesome";
    };
    dataFile = {
      "fonts".source = "${config.home.homeDirectory}/default/fonts";
    };
    mimeApps = {
      enable = true;
      associations.added = {
        "text/x-emacs-lisp" = "emacs.desktop";
        "text/plain" = "emacs.desktop";
        "text/html" = "org.gnome.gedit.desktop";
      };
      defaultApplications = {
        "text/html" = "org.qutebrowser.qutebrowser.desktop";
      };
    };
  };

  home = {
    # We do this to preserve permissions in our aerc config files
    activation = {
      linkAerc = config.lib.dag.entryAfter [ "installPackages" ] (
        ''
        test -e ${config.home.homeDirectory}/.config/aerc || $DRY_RUN_CMD ln -s ${dots}/extra/aerc ${config.home.homeDirectory}/.config/
        ''
        );
      linkWeechat = config.lib.dag.entryBefore [ "linkGeneration" ] (
        ''
        test -e ${config.home.homeDirectory}/.weechat || $DRY_RUN_CMD ln -s ${dots}/extra/weechat ${config.home.homeDirectory}/.weechat
        ''
        );
      setXDGSettings = config.lib.dag.entryBefore [ "linkGeneration" ] (
        ''
        # We already set $BROWSER so we don't need this
        # xdg-settings set default-web-browser qutebrowser.desktop
        ''
        );
      fixZoomSSO = config.lib.dag.entryBefore [ "linkGeneration" ] (
        ''
        # see nixpkgs #73532
        echo "embeddedBrowserForSSOLogin=false" > ~/.config/zoomus.conf
        ''
      );
    };

    packages = with pkgs;
      let
        custom-r = (rWrapper.override {
          packages = with rPackages;
            let
              r-ledger = buildRPackage {
                name = "r-ledger";
                src = pkgs.fetchFromGitHub {
                  owner = "trevorld";
                  repo = "r-ledger";
                  rev = "5066f9968481f91005fcecdbd80e74dc0d7fe9cf";
                  sha256 = "198ylg4hwnwc4w9pn3wsiigq25v80rpn61k8449a4f35vrfrcpga";
                };
                
                propagatedBuildInputs = [ rlang dplyr rio rlang stringr tidyr tibble tidyselect ];
                nativeBuildInputs = [ rlang dplyr rio rlang stringr tidyr tibble tidyselect ];
              };
            in [ ggplot2 dplyr r-ledger tibble tidyr zoo littler ]; });
      in [
        fd bat

        qutebrowser rofi-pass ncmpcpp
        pavucontrol pass xdg-user-dirs
        sxiv cmst obs-studio discord libnotify
        ranger qbittorrent aspell darktable mpv
        blueman spotify nix-prefetch-github
        youtube-dl mako jq imgur-sh
        wl-clipboard fzf hugo ffmpeg
        ipe scribus neofetch imagemagick
        arduino keybase-gui exa firefox cabal2nix
        woeusb nix-prefetch-git jpegoptim woff2
        nix-index sbcl mpc_cli geckodriver
        tokei androidenv.androidPkgs_9_0.platform-tools
        sent screen-message pinentry-qt aerc w3m
        haskellPackages.hpack slack
        bean-add
        ledger hledger ledger-autosync python37Packages.ofxclient
        s3cmd maim feh xorg.xbacklight xorg.xfd gnome3.cheese
        xclip xorg.xev gnuapl xorg.xwininfo bench
        signal-desktop hyperfine vale
        ride weechat bandwhich broot dos2unix
        openssl nix-npm-install
        graphviz kona rlwrap zoom-us
        stack gdb flameshot zotero
        sqlite heroku racket krita
        z3 zenith rustc qrencode paperkey
        sparkleshare jdk11 macchanger zotero
        mailspring thunderbird nnn

        julia

        (python38.withPackages (ps: with ps; [ beancount ]))

        custom-r

        (rPackages.littler.overrideDerivation (attrs: {
          preConfigure = "export PATH=${custom-r}/bin/:\$PATH";
        }))

        dcao-sh

        texlive.combined.scheme-full

        cmake llvmPackages_9.clang-unwrapped llvmPackages_9.llvm libxml2 zlib

        (st.override {
          conf = (import ./cfg/st/config.nix) {};
          patches = [];
        })

        # acme
        fortune cowsay lolcat cmatrix libcaca
      ];

    file = {
      ".ncmpcpp/config".source = "${extra}/ncmpcpp/config";
      # "bin/sway_rename.sh".source = "${extra}/sway/sway_rename.sh";
      ".wall.jpg".source = "${pkgs.catalina-wall}/share/artwork/gnome/catalina.jpg";
      ".notmuch-config".source = "/home/david/.config/notmuch/notmuchrc";
      ".doom.d" = {
        source = "${extra}/emacs/.doom.d";
        onChange = updateDoom;
      };
      # We need this to add extra astroid config files
      astroid = { source = "${extra}/astroid"; target = ".config/astroid/"; recursive = true; };
      emacs = { source = "${extra}/emacs"; target = "."; recursive = true; onChange = "rm ~/.emacs.d/config.el"; };
      qutebrowser = { source = "${extra}/qutebrowser"; target = "."; recursive = true; };
      herbstluftwm = { source = "${extra}/herbstluftwm"; target = "."; recursive = true; };
      ranger = { source = "${extra}/ranger"; target = "."; recursive = true; };
      rofi = { source = "${extra}/rofi"; target = "."; recursive = true; };
    };

    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "${browser}";
      TERM = "xterm-256color";
      PASSWORD_STORE_DIR = "$HOME/default/pass/";
      FZF_DEFAULT_OPTS = "--height 50% --reverse --ansi";
      LEDGER_FILE = "$HOME/default/ledger/spending.ldg";
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
        musdl = "youtube-dl -i --extract-audio --audio-format mp3 --audio-quality 0";
        startx = "startx ~/.xinitrc";
        ea = "exa -la";
        n = "nvim ~/default/vimwiki/index.md -c 'NV'";
        w = "nvim ~/default/vimwiki/index.md -c 'NV'";
        h = "hledger";
        leg = "ledger";
        lsync = "ledger-autosync -l /home/david/default/ledger/combined.ldg --payee-format '{payee}' >> /home/david/default/ledger/review.ldg";
      };
    };

    git = {
      enable = true;
      userName = "David Cao";
      userEmail = "david@cao.sh";
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
        postNew = ''
        for x in ''$(notmuch search --output=files tag:deleted) ; do mv ''$x ''${x}T ; done
        '';
      };
      search.excludeTags = [ "deleted" "spam" "muted" ];
    };

    msmtp = {
      enable = true;
    };

    astroid = {
      enable = true;
      externalEditor = "st -e nvim -c 'set ft=mail' '+set tw=72' %1";
      
      pollScript = ''
      export PASSWORD_STORE_DIR=/home/david/default/pass/
      mbsync --all -Xm -Xs
      notmuch new'';
      extraConfig = {
        editor.attachment_directory = "~/dl";
      };
    };

    alot = {
      enable = true;
    };

    neomutt = {
      enable = true;
    };

    direnv = {
      enable = true;
      enableFishIntegration = true;
    };
  
    rofi = {
      enable = true;
    };

    beets = {
      enable = false;
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

    tmux = {
      enable = true;
      escapeTime = 0;
      historyLimit = 10000;
      keyMode = "vi";
      plugins = with pkgs.tmuxPlugins; [
        resurrect
      ];
      sensibleOnTop = true;
      shortcut = "z";
      terminal = "screen-256color";
      extraConfig = ''
        set -g mouse on
        setw -g monitor-activity off
        set -g visual-activity off
        set-option -g repeat-time 250
        set-option -g message-style "bg=#${colors.base00}, fg=#${colors.base06}"
        bind-key R source-file ~/.tmux.conf \; display-message ":: Config reloaded"

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
        bind-key Escape copy-mode
        bind-key v paste-buffer
        bind-key -T copy-mode-vi 'v' send -X begin-selection
        bind-key -T copy-mode-vi 'y' send -X copy-selection
        bind-key -T copy-mode-vi 'Space' send -X halfpage-down
        bind-key -T copy-mode-vi 'Bspace' send -X halfpage-up
         
        # extra commands for interacting with the ICCCM clipboard
        bind-key C-c run "tmux save-buffer - | wl-copy"
        bind-key C-v run "tmux set-buffer \"$(wl-paste)\"; tmux paste-buffer"
         
        # easy-to-remember split pane commands
        bind-key / split-window -h
        bind-key - split-window -v
        unbind-key '"'
        unbind-key %
         
        # moving between panes with vim movement keys
        bind-key -r h select-pane -L
        bind-key -r j select-pane -D
        bind-key -r k select-pane -U
        bind-key -r l select-pane -R
         
        # moving between windows with vim movement keys
        bind-key -r C-h select-window -t :-
        bind-key -r C-l select-window -t :+
         
        # resize panes with vim movement keys
        bind-key -r H resize-pane -L 1
        bind-key -r J resize-pane -D 1
        bind-key -r K resize-pane -U 1
        bind-key -r L resize-pane -R 1
        
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
        packages.myVimPackage = {
          start = with pkgs.vimPlugins; [
            ale fugitive surround vim-nix lightline-vim
            vimtex ultisnips vimwiki fzf-vim fzfWrapper
            vim-signature
          ] ++ [ nvPlugins.notational-fzf-vim ];
          opt = [];
        };
        customRC = import ./cfg/nvim/rc.nix;
      };
    };
  };

  services = {
    lorri.enable = true;

    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      extraConfig = "pinentry-program /home/david/.nix-profile/bin/pinentry-qt";
    };

    # compton = {
    #   enable = true;
    #   backend = "glx";
    #   vSync = "opengl-mswc";
    #   extraOptions = builtins.readFile "${extra}/compton/.config/compton.conf";
    # };

    syncthing.enable = true;
    dropbox.enable = true;

    mpd = {
      enable = true;
      musicDirectory = "${config.home.homeDirectory}/default/mus";
    };

    dunst = {
      enable = true;

      settings = {
        shortcuts = {
          "close" = "ctrl+space";
          "close_all" = "ctrl+shift+space";
          "history" = "ctrl+grave";
        };

        global = {
          # monitor = 0;
          follow = "mouse";
          geometry = "300x5-4-40";
          indicate_hidden = true;
          shrink = false;
          transparency = 0;
          notification_height = 0;
          separator_height = 2;
          padding = 8;
          horizontal_padding = 12;
          frame_width = 3;
          separator_color = "frame";
          sort = true;
          idle_threshold = 15;
          font = "Monospace 11";
          line_height = 0;
          dmenu = "/usr/bin/rofi -dmenu -p 'dunst:'";
          browser = browser;
          format = "<b>%s</b>\\n%b";
          alignment = "left";
          show_age_threshold = 60;
          word_wrap = true;
          ellipsize = "middle";
          ignore_newline = false;
          stack_duplicates = true;
          hide_duplicant_count = false;
          show_indicators = true;
        };

        urgency_low = {
          background = "#282828";
          foreground = "#a89984";
          frame_color = "#666666";
          timeout = 5;
        };

        urgency_normal = {
          background = "#282828";
          foreground = "#ebdbb2";
          frame_color = "#ebdbb2";
          timeout = 10;
        };

        urgency_critical = {
          background = "#282828";
          foreground = "#fb4934";
          frame_color = "#fb4934";
          timeout = 0;
        };
      };
    };

  };

}
