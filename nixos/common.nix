{
  pkgs,
  config,
  hostname,
  ...
}: {
  # Import submodules
  imports = [
    ./programs.nix
  ];

  # Lix
  nix.package = pkgs.lixPackageSets.stable.lix;

  # Enable experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Silence the "Git tree is dirty" warning on flake rebuilds
  nix.settings.warn-dirty = false;

  # Allow unfree software
  nixpkgs.config.allowUnfree = true;

  # Use GRUB bootloader
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    gfxmodeEfi = "1024x768,auto";
    configurationLimit = 20;
  };

  # Display Manager and Niri 
  programs.niri.enable = true;
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm = {
    enable = true;
    background = "${pkgs.pantheon.elementary-wallpapers}/share/backgrounds/Morskie Oko.jpg";
    greeters.slick = {
      enable = true;
      font = {
        package = pkgs.ubuntu-classic;
        name = "Ubuntu 11";
      };
      theme = {
        package = pkgs.yaru-theme;
        name = "Yaru-dark";
      };
      iconTheme = {
        package = pkgs.yaru-theme;
        name = "Yaru";
      };
      cursorTheme = {
        package = pkgs.yaru-theme;
        name = "Yaru";
      };
      draw-user-backgrounds = false;
      extraConfig = ''
        background-color=#2C001E
        show-hostname=true
        show-a11y=true
        show-keyboard=true
        show-power=true
        show-clock=false
        xft-antialias=true
      '';
    };
  };

  # Networking and Bluetooth
  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  networking.nftables.enable = true;
  networking.firewall.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Locale
  # en_GB gives proper English and metric defaults :)
  i18n.defaultLocale = "en_GB.UTF-8";

  # Layout
  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  # Console font
  console.font = "Lat2-Terminus16";

  # Time
  time.timeZone = "Europe/Brussels";

  # Sound server
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Garbage collector
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 10d";
  };

  # Nix Store optimiser
  nix.optimise = {
    automatic = true;
    dates = "weekly";
  };

  # Printing and scanning
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [pkgs.hplipWithPlugin];
  services.ipp-usb.enable = true;
  services.printing.enable = true;

  # User 'alex'
  users.users.alex = {
    isNormalUser = true;
    description = "Alexandre Ros";
    shell = pkgs.zsh;
    extraGroups = [
      "audio"
      "libvirtd"
      "lp"
      "networkmanager"
      "scanner"
      "video"
      "wheel"
    ];
  };

  # Power profiles and management
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  
  # doas security
  security.sudo.enable = false;
  security.doas = {
    enable = true;
    extraRules = [
      {
        groups = ["wheel"];
        persist = true;
      }
    ];
  };

  # gnome-keyring
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;

  # Disable root login
  users.users.root.hashedPassword = "!";

  system.stateVersion = "25.11";
}
