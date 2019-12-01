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
  ];

  imports =
    [ # Include the results of the hardware scan.
    ./hw-boomerang.nix
    /etc/nixos/cachix.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    kernelPackages = pkgs.linuxPackages_5_3;
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
      };
    };
    tmpOnTmpfs = true;
  };

  # Trackpoint
  hardware = {
    cpu.intel.updateMicrocode = true;
    acpilight.enable = true;
    bluetooth = {
      enable = true;
      extraConfig = ''
        [General]
        Enable=Source,Sink,Media,Socket
      '';
    };

    trackpoint = {
      enable = true;
      emulateWheel = true;
      speed = 160;
    };

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ beignet vaapiIntel libvdpau-va-gl vaapiVdpau ];
    };
  };

  # Networking
  networking = {
    hostName = "boomerang";
    wireless.enable = true;
    connman.enable = true;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
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
    libinput-gestures ripgrep

    # fs
    ntfs3g exfat

    # editors
    neovim emacs

    # misc
    gnupg bashmount light xdg_utils
  ];

  programs.fish.enable = true;

  # swapfile stuff
  swapDevices = [
    { device = "/swapfile1"; size = 8192; }
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:
  services.undervolt = {
    enable = true;
    coreOffset = "-85";
  };

  services.blueman.enable = true;

  services.emacs.enable = true;

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
    layout = "us";
    xkbOptions = "eurosign:e";
    autoRepeatDelay = 200;
    autoRepeatInterval = 25;
    videoDrivers = [ "intel" ];

    displayManager.gdm = {
      enable = true;
    };
    
    windowManager.awesome = {
      enable = true;
    };

    libinput = {
      enable = true;
      accelProfile = "flat";
      naturalScrolling = true;
      disableWhileTyping = true;
      tapping = false;
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
    extraGroups = [ "wheel" "video" "input" ]; # Enable ‘sudo’ for the user.
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
