# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, options, ... }:

{
  nix = {
    binaryCachePublicKeys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs=" ];
    binaryCaches = [ "https://hydra.iohk.io" "https://cache.nixos.org" ];
    nixPath = options.nix.nixPath.default ++ [ "nixpkgs-overlays=/etc/nixos/overlays-compat/" ];
  };

  nixpkgs.overlays = [
    (import ./overlays/dcao.nix)
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/1152483c83315d0e9189683fc7b9a45cd9c56cd9.tar.gz;
    }))
  ];

  imports = [ # Include the results of the hardware scan.
    ./hw-minimac.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    kernelPackages = pkgs.linuxPackages;
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
      };
    };
    tmpOnTmpfs = true;
  };

  # Networking
  networking = {
    hostName = "minimac";
    useDHCP = false;
    interfaces.enp0s2.useDHCP = true;
  };

  services.connman.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";
  time.hardwareClockInLocalTime = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # core
    coreutils gitAndTools.gitFull htop
    wget curl zip unzip tree bc
    gcc pkg-config binutils ccache gnumake
    libinput-gestures ripgrep xorg.xmodmap

    # fs
    ntfs3g exfat

    # editors
    neovim emacs

    # misc
    gnupg bashmount light xdg_utils
  ];

  programs.fish.enable = true;

  programs.adb.enable = true;

  # swapfile stuff
  swapDevices = [
    { device = "/swapfile1"; size = 8192; }
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  services.blueman.enable = true;

  services.keybase.enable = true;
  services.kbfs.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  programs.ssh.startAgent = true;

  # Add postgres for development
  services.postgresql.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;
  };

  # TLP
  services.tlp.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    exportConfiguration = true;
    layout = "us";
    autoRepeatDelay = 200;
    autoRepeatInterval = 25;
    videoDrivers = [ "intel" ];

    # displayManager = {
    #   gdm = {
    #     enable = true;
    #   };
    # };
    # 
    # windowManager.herbstluftwm = {
    #   enable = true;
    # };

    displayManager.startx.enable = true;

    libinput = {
      enable = true;
      # dev = "/dev/input/event14";
      # accelProfile = "flat";
      # naturalScrolling = true;
      disableWhileTyping = true;
      # tapping = false;
    };
  };

  # Fonts!!!
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      iosevka
      mplus-outline-fonts
      siji
      roboto
      libre-baskerville
      emacs-all-the-icons-fonts
      ibm-plex
      fira
      alegreya
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "Iosevka" ];
      };
    };
  };

  services.logind = {
    lidSwitch = "hybrid-sleep";
  };

  environment.etc."sleep.conf".text = ''
    [Sleep]
    HibernateDelaySec=900
  '';

  i18n.inputMethod.enabled = "ibus";

  nixpkgs.config = {
    allowUnfree = true; 
  };

  services.dbus.packages = with pkgs; [ blueman ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.david = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "input" "adbusers" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };

  # sudo options
  security.sudo.wheelNeedsPassword = false;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
